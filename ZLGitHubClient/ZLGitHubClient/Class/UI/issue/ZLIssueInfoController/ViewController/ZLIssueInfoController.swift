//
//  ZLIssueInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/16.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import RxSwift
import RxRelay
import ZLGitRemoteService
import ZLUIUtilities

class ZLIssueInfoController: ZLBaseViewController {

    // input model
    @objc var login: String?
    @objc var repoName: String?
    @objc var number: Int = 0

    // model
    var after: String?
    var issueId: String?
    
    // vc
    var commentVC: ZLSubmitCommentController?
    
    // ViewModel
    var issueHeaderCellData: ZLIssueHeaderTableViewCellData?
    var issueBodyCellData: ZLIssueBodyTableViewCellData?
    var timelineCellDatas: [ZLGithubItemTableViewCellData] = []
    
    // Observer
    let _errorObserver = PublishRelay<Void>()
    let _setObserver = PublishRelay<([ZLGithubItemTableViewCellData],Bool)>()
    let _reloadVisibleCellObserver = PublishRelay<[ZLGithubItemTableViewCellData]>()
    let _canReactObserver = BehaviorRelay<Bool>(value:false)

    private lazy var issueInfoView: ZLIssueInfoView = {
       let view = ZLIssueInfoView()
       return view
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        
        issueInfoView.beginRefresh()
    }
    
    
    func setupUI() {
        
        self.title = ZLLocalizedString(string: "issue", comment: "")

        self.zlNavigationBar.backButton.isHidden = false
        let button = UIButton.init(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: ZLIconFont.More.rawValue,
                                                     attributes: [.font: UIFont.zlIconFont(withSize: 30),
                                                                  .foregroundColor: UIColor.label(withName: "ICON_Common")]),
                                  for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)

        self.zlNavigationBar.rightButton = button

        // view
        self.contentView.addSubview(issueInfoView)
        issueInfoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        issueInfoView.fillWithData(viewData: self)
    
    }
    

    @objc func onMoreButtonClick(button: UIButton) {

        let path = "https://www.github.com/\(login?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")/\(repoName?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")/issues/\(number)"
        guard let url = URL(string: path) else { return }
        button.showShareMenu(title: path, url: url, sourceViewController: self)
    }
    
    func reloadData() {
        
        var cellDatas = [ZLGithubItemTableViewCellData]()
        guard let issueHeaderCellData = issueHeaderCellData,
           let issueBodyCellData = issueBodyCellData else {
               _setObserver.accept((cellDatas,false))
               return
        }
        
        cellDatas.append(issueHeaderCellData)
        cellDatas.append(issueBodyCellData)
        cellDatas.append(contentsOf: timelineCellDatas)
        
        _setObserver.accept((cellDatas,false))
    }
}

extension ZLIssueInfoController {
    override func getEvent(_ event: Any?, fromSubViewModel subViewModel: ZLBaseViewModel) {
        if let cellData = subViewModel as? ZLGithubItemTableViewCellData {
            _reloadVisibleCellObserver.accept([cellData])
        }
    }
}

// MARK: ZLIssueInfoViewDelegateAndDataSource
extension ZLIssueInfoController: ZLIssueInfoViewDelegateAndDataSource {
    
    var setObservable: Observable<([ZLGithubItemTableViewCellData], Bool)> {
        _setObserver.asObservable()
    }
    
    
    var canReactObservale: Observable<Bool> {
        _canReactObserver.asObservable()
    }
    
    var errorObservable: Observable<Void> {
        _errorObserver.asObservable()
    }
    
    var reloadVisibleCellObservale: Observable<([ZLGithubItemTableViewCellData])> {
        _reloadVisibleCellObserver.asObservable()
    }
    
    func onCommentButtonClick() {
        guard let issueId = self.issueId else { return }
        if commentVC == nil {
            commentVC = ZLSubmitCommentController()
            commentVC?.modalPresentationStyle = .fullScreen
        }
        commentVC?.issueId = issueId
        if let vc = commentVC {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func onInfoButtonClick() {
        let vc = ZLEditIssueController()
        vc.loginName = login
        vc.repoName = repoName
        vc.number = number
        vc.refreshStatusBlock = { [weak self] in
            self?.requestIssueInfo()
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func onRefreshPullDown() {
        requestIssueInfo()
        requestIssueTimeline(loadNewData: true)
    }

    func onRefreshPullUp() {
        requestIssueTimeline(loadNewData: false)
    }
}

//
extension ZLIssueInfoController {
    
    func requestIssueInfo() {
        
        guard let login = self.login, let repoName = self.repoName else {
            _errorObserver.accept(())
            return
        }

        ZLEventServiceShared()?.getRepositoryIssueInfo(withLoginName: login,
                                                       repoName: repoName,
                                                       number: Int32(number),
                                                       serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel: ZLOperationResultModel) in
            
            guard let self = self else { return }
            
            if resultModel.result == false {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
                self._errorObserver.accept(())
            } else {
                if let data = resultModel.data as? IssueInfoQuery.Data {
                    if let issue = data.repository?.issue {
                        
                        if let issueBodyCellData = self.issueBodyCellData,
                           let issueHeaderCellData = self.issueHeaderCellData {
                            issueBodyCellData.removeFromSuperViewModel()
                            issueHeaderCellData.removeFromSuperViewModel()
                        }
            
                        let issueBodyCellData = self.getIssueBodyCellData(data: issue)
                        let issueHeaderCellData = self.getIssueHeaderCellData(data: data)
                        self.addSubViewModel(issueBodyCellData)
                        self.addSubViewModel(issueHeaderCellData)
                        
                        self.issueBodyCellData = issueBodyCellData
                        self.issueHeaderCellData = issueHeaderCellData
                        self.title = issue.title
                        self.issueId = issue.id
                        self._canReactObserver.accept(issue.viewerCanReact)
                        self.reloadData()
                        
                    } else {
                        ZLToastView.showMessage("Not Found")
                        self._errorObserver.accept(())
                    }
                } else {
                    self._errorObserver.accept(())
                }
            }
        }
    }
    
    
    func requestIssueTimeline(loadNewData: Bool) {
        
        guard let login = self.login, let repoName = self.repoName else {
            _errorObserver.accept(())
            return
        }
        
        ZLEventServiceShared()?.getRepositoryIssueTimeline(withLoginName: login,
                                                           repoName: repoName,
                                                           number: Int32(number),
                                                           after: loadNewData ? nil : after,
                                                           serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel: ZLOperationResultModel) in
            
            guard let self = self else { return }
            
            if resultModel.result == false {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
                self._errorObserver.accept(())
            } else {
                
                if let data = resultModel.data as? IssueTimeLineInfoQuery.Data,
                   let timelines = data.repository?.issue?.timelineItems {
                    
                    let cellDatas = self.getIssueTimelineCellData(data: timelines)
                    if !cellDatas.isEmpty {
                        
                        if loadNewData {
                            for cellData in self.timelineCellDatas {
                                cellData.removeFromSuperViewModel()
                            }
                            self.timelineCellDatas = cellDatas
                        } else {
                            self.timelineCellDatas.append(contentsOf: cellDatas)
                        }
                        self.addSubViewModels(cellDatas)
                        self.reloadData()
                        if let after = timelines.pageInfo.endCursor {
                            self.after = after
                        }
                    } else if cellDatas.isEmpty && !loadNewData {
                        ZLToastView.showMessage("No More Data")
                        self._errorObserver.accept(())
                    } else {
                        self._errorObserver.accept(())
                    }
                
                } else {
                    self._errorObserver.accept(())
                }
            }
        }
    }
}


extension ZLIssueInfoController {
    
    func getIssueTimelineCellData(data: IssueTimeLineInfoQuery.Data.Repository.Issue.TimelineItem) -> [ZLGithubItemTableViewCellData] {

        var cellDatas: [ZLGithubItemTableViewCellData] = []

        if let timelinesArray = data.nodes {
            for tmptimeline in timelinesArray {
                if let timeline = tmptimeline {
                    if let issueComment = timeline.asIssueComment {
                        let cellData = ZLIssueCommentTableViewCellData(data: issueComment)
                        cellDatas.append(cellData)
                    } else if timeline.asSubscribedEvent != nil ||
                                timeline.asUnsubscribedEvent != nil ||
                                timeline.asMentionedEvent != nil ||
                                timeline.asRemovedFromProjectEvent != nil {
                        continue
                    } else {
                        let cellData = ZLIssueTimelineTableViewCellData(data: timeline)
                        cellDatas.append(cellData)
                    }
                }
            }
        }

        return cellDatas
    }
    
    func getIssueHeaderCellData(data: IssueInfoQuery.Data) -> ZLIssueHeaderTableViewCellData {
        return ZLIssueHeaderTableViewCellData(data: data)
    }
    
    func getIssueBodyCellData(data: IssueInfoQuery.Data.Repository.Issue) -> ZLIssueBodyTableViewCellData {
        return ZLIssueBodyTableViewCellData(data: data)
    }
}
