//
//  ZLIssueInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/16.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZLUIUtilities
import ZLUtilities
import ZMMVVM

class ZLIssueInfoController: ZMTableViewController {

    // input model
    @objc var login: String?
    @objc var repoName: String?
    @objc var number: Int = 0

    // model
    var issueData: IssueInfoQuery.Data?
    var after: String?
    var issueId: String?
    
    // vc
    var commentVC: ZLSubmitCommentController?
    
    // ViewModel
    var issueBodyCellData: ZLIssueBodyTableViewCellData?
    var timelineCellDatas: [ZMBaseTableViewCellViewModel] = []
    
    @objc init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    
    override func setupUI() {
        super.setupUI()
           
        self.title = "#\(number)"
        
        self.zmNavigationBar.addRightView(moreButton)
       
        self.tableView.removeFromSuperview()
        self.contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(tableView)
        verticalStackView.addArrangedSubview(bottomView)
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        tableView.register(ZLIssueHeaderTableViewCell.self,
                           forCellReuseIdentifier: "ZLIssueHeaderTableViewCell")
        tableView.register(ZLIssueCommentTableViewCell.self,
                           forCellReuseIdentifier: "ZLIssueCommentTableViewCell")
        tableView.register(ZLIssueTimelineTableViewCell.self,
                           forCellReuseIdentifier: "ZLIssueTimelineTableViewCell")
        
        self.setRefreshViews(types: [.header,.footer])
    }
    
    lazy var moreButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: ZLIconFont.More.rawValue,
                                                     attributes: [.font: UIFont.zlIconFont(withSize: 30),
                                                                  .foregroundColor: UIColor.label(withName: "ICON_Common")]),
                                  for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        return button
    }()
    
    lazy private var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy private var bottomView: ZLIssueInfoBottomView = {
        let view = ZLIssueInfoBottomView()
        view.isHidden = true
        view.commentButton.addTarget(self,
                                     action: #selector(onCommentButtonClick),
                                     for: .touchUpInside)
        view.infoButton.addTarget(self,
                                     action: #selector(onInfoButtonClick),
                                     for: .touchUpInside)
        return view
    }()
    
    override func refreshLoadNewData() {
        requestIssueInfo()
    }
    
    override func refreshLoadMoreData() {
        requestIssueTimeline(loadNewData: false)
    }
}

// MARK: - Action
extension ZLIssueInfoController {
    @objc func onMoreButtonClick(button: UIButton) {

        let path = "https://www.github.com/\(login?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")/\(repoName?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")/issues/\(number)"
        guard let url = URL(string: path) else { return }
        button.showShareMenu(title: path, url: url, sourceViewController: self)
    }
    
    @objc func onCommentButtonClick() {
        guard let issueId = self.issueId else { return }
        if commentVC == nil {
            commentVC = ZLSubmitCommentController()
            commentVC?.modalPresentationStyle = .fullScreen
        }
        commentVC?.issueId = issueId
        if let vc = commentVC {
            vc.submitSuccessBlock = { [weak self] in
                self?.requestIssueTimeline(loadNewData: false)
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func onInfoButtonClick() {
        let vc = ZLEditIssueController()
        vc.loginName = login
        vc.repoName = repoName
        vc.number = number
        vc.refreshStatusBlock = { [weak self] in
            self?.justRequestIssueInfo()
            self?.requestIssueTimeline(loadNewData: false)
        }
        vc.loadMoreTimelineBlock = { [weak self] in
            self?.requestIssueTimeline(loadNewData: false)
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}


//extension ZLIssueInfoController {
//    override func getEvent(_ event: Any?, fromSubViewModel subViewModel: ZLBaseViewModel) {
//        if let cellData = subViewModel as? ZLGithubItemTableViewCellData {
//            _reloadVisibleCellObserver.accept([cellData])
//        }
//    }
//}


//
extension ZLIssueInfoController {
    
    func requestIssueInfo() {
        
        ZLEventServiceShared()?.getRepositoryIssueInfo(withLoginName: login ?? "",
                                                       repoName: repoName ?? "",
                                                       number: Int32(number),
                                                       serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel: ZLOperationResultModel) in
            
            guard let self = self else { return }
            
            if resultModel.result,
               let data = resultModel.data as? IssueInfoQuery.Data,
               let issue = data.repository?.issue {
                self.issueData = data
                self.issueId = issue.id
      
                self.requestIssueTimeline(loadNewData: true)
                
                var cellDatas: [ZMBaseTableViewCellViewModel] = [
                    self.getIssueHeaderCellData(data: data)
                ]
                if let issue = data.repository?.issue {
                    cellDatas.append(self.getIssueBodyCellData(data: issue))
                }
             
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(200), execute: {
                    
                    self.bottomView.isHidden = false
                    self.bottomView.commentButton.isEnabled = issue.viewerCanReact
                    
                    self.zm_addSubViewModels(cellDatas)
                    
                    self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDatas)]
                    

                    self.tableView.reloadData()
                    self.endRefreshViews(noMoreData: true)
                    self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
                })
            } else {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
                self.endRefreshViews()
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
            }
        }
    }
    
    
    func requestIssueTimeline(loadNewData: Bool) {
                
        ZLEventServiceShared()?.getRepositoryIssueTimeline(withLoginName: login ?? "",
                                                           repoName: repoName ?? "",
                                                           number: Int32(number),
                                                           after: loadNewData ? nil : after,
                                                           serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel: ZLOperationResultModel) in
            
            guard let self = self else { return }
            if resultModel.result,
               let data = resultModel.data as? IssueTimeLineInfoQuery.Data,
               let timelines = data.repository?.issue?.timelineItems {
                
                self.after = timelines.pageInfo.endCursor
                let hasNextPage = timelines.pageInfo.hasNextPage
                
                let timelineCellDatas = self.getIssueTimelineCellData(data: timelines)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(200), execute: {
                    if loadNewData {
                        self.timelineCellDatas = timelineCellDatas
                    } else {
                        self.timelineCellDatas.append(contentsOf: timelineCellDatas)
                    }
                    self.zm_addSubViewModels(timelineCellDatas)
                    self.sectionDataArray.first?.cellDatas.append(contentsOf: timelineCellDatas)
                
                    self.tableView.reloadData()
                    self.endRefreshViews(noMoreData: !hasNextPage)
                    self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
                })
                
                
            } else {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
              
                self.endRefreshViews()
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
            }
        }
    }
    
    
    func justRequestIssueInfo() {
        
        ZLEventServiceShared()?.getRepositoryIssueInfo(withLoginName: login ?? "",
                                                       repoName: repoName ?? "",
                                                       number: Int32(number),
                                                       serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel: ZLOperationResultModel) in
            
            guard let self = self else { return }
            
            if resultModel.result,
               let data = resultModel.data as? IssueInfoQuery.Data,
               let issue = data.repository?.issue {
                
                if var cellDataArray = self.sectionDataArray.first?.cellDatas {
                    self.issueData = data
                    self.issueId = issue.id
                    
                   
                    /// headerData
                    let headerData = self.getIssueHeaderCellData(data: data)
                    if let index = cellDataArray.firstIndex(where: { $0 is ZLIssueHeaderTableViewCellData}) {
                        self.zm_addSubViewModel(headerData)
                        cellDataArray[index].zm_removeFromSuperViewModel()
                        cellDataArray[index] = headerData
                    }
                    
                    /// bodyData
                    if let issue = data.repository?.issue,
                       let index = cellDataArray.firstIndex(where: { $0 is ZLIssueBodyTableViewCellData}) {
                        let boydData = self.getIssueBodyCellData(data: issue)
                        self.zm_addSubViewModel(boydData)
                        cellDataArray[index].zm_removeFromSuperViewModel()
                        cellDataArray[index] = boydData
                    }
                       
                    self.sectionDataArray.first?.cellDatas = cellDataArray
                    self.tableView.reloadData()
            
                }
            
            }
        }
    }
}


extension ZLIssueInfoController {
    
    func getIssueTimelineCellData(data: IssueTimeLineInfoQuery.Data.Repository.Issue.TimelineItem) -> [ZMBaseTableViewCellViewModel] {

        var cellDatas: [ZMBaseTableViewCellViewModel] = []

        if let timelinesArray = data.nodes {
            for tmptimeline in timelinesArray {
                if let timeline = tmptimeline {
                    if let issueComment = timeline.asIssueComment {
                        let preCommentData = timelineCellDatas.first(where: {
                            if let commentCellData = $0 as? ZLIssueCommentTableViewCellData,
                               commentCellData.data.id == issueComment.id {
                                return true
                            }
                            return false
                        })
                        let cellData = ZLIssueCommentTableViewCellData(data: issueComment,
                                                                       cellHeight: preCommentData?.zm_cellHeight)
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
        let issueBodyCellData = ZLIssueBodyTableViewCellData(data: data,
                                            cellHeight: issueBodyCellData?.zm_cellHeight)
        self.issueBodyCellData = issueBodyCellData
        return issueBodyCellData
    }
}
