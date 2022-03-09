//
//  ZLIssueInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/16.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import FloatingPanel
import ZLBaseUI
import RxSwift
import RxRelay

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
    
    // Observer
    let _errorObserver = PublishRelay<Void>()
    let _resetObserver = PublishRelay<[ZLGithubItemTableViewCellData]>()
    let _appendObserver = PublishRelay<[ZLGithubItemTableViewCellData]>()
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
    
    var canReactObservale: Observable<Bool> {
        _canReactObserver.asObservable()
    }
    
    var errorObservable: Observable<Void> {
        _errorObserver.asObservable()
    }
    
    var resetObservable: Observable<([ZLGithubItemTableViewCellData])> {
        _resetObserver.asObservable()
    }
    
    var appendObservable: Observable<([ZLGithubItemTableViewCellData])> {
        _appendObserver.asObservable()
    }
    
    var reloadVisibleCellObservale: Observable<([ZLGithubItemTableViewCellData])> {
        _reloadVisibleCellObserver.asObservable()
    }
    
    func onCommentButtonClick() {
        guard let issueId = self.issueId else { return }
        if commentVC == nil {
            commentVC = ZLSubmitCommentController()
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
        self.present(vc, animated: true, completion: nil)
    }
    
    func onRefreshPullDown() {
        loadNewData()
    }

    func onRefreshPullUp() {
        loadMoreData()
    }
}


// MARK: Request
extension ZLIssueInfoController {

    func loadNewData() {
        
        guard let login = self.login, let repoName = self.repoName else {
            _errorObserver.accept(())
            return
        }

        ZLServiceManager.sharedInstance.eventServiceModel?.getRepositoryIssueInfo(withLoginName: login,
                                                                                 repoName: repoName,
                                                                                 number: Int32(number),
                                                                                 after: nil,
                                                                                 serialNumber: NSString.generateSerialNumber()) { [weak self](resultModel: ZLOperationResultModel) in

            if resultModel.result == false {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
                self?._errorObserver.accept(())
            } else {
                if let data = resultModel.data as? IssueInfoQuery.Data {

                    self?.title = data.repository?.issue?.title
                    self?.after = data.repository?.issue?.timelineItems.pageInfo.endCursor
                    self?.issueId = data.repository?.issue?.id

                    let cellDatas: [ZLGithubItemTableViewCellData] = ZLIssueTableViewCellData.getCellDatasWithIssueModel(data: data, firstPage: true)

                    self?.addSubViewModels(cellDatas)
                    self?._resetObserver.accept(cellDatas)
                    self?._canReactObserver.accept(data.repository?.issue?.viewerCanReact ?? false)

                } else {
                    self?._errorObserver.accept(())
                }
            }
        }
    }
    
    func loadMoreData() {
        
        guard let login = self.login, let repoName = self.repoName else {
            _errorObserver.accept(())
            return
        }

        ZLServiceManager.sharedInstance.eventServiceModel?.getRepositoryIssueInfo(withLoginName: login,
                                                                                 repoName: repoName,
                                                                                 number: Int32(number),
                                                                                 after: after,
                                                                                 serialNumber: NSString.generateSerialNumber()) { [weak self](resultModel: ZLOperationResultModel) in

            if resultModel.result == false {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
                self?._errorObserver.accept(())
            } else {
                if let data = resultModel.data as? IssueInfoQuery.Data {

                    self?.title = data.repository?.issue?.title
                    self?.after = data.repository?.issue?.timelineItems.pageInfo.endCursor

                    let cellDatas: [ZLGithubItemTableViewCellData] = ZLIssueTableViewCellData.getCellDatasWithIssueModel(data: data, firstPage: false)

                    self?.addSubViewModels(cellDatas)
                    self?._appendObserver.accept(cellDatas)

                } else {
                    self?._errorObserver.accept(())
                }
            }
        }
        
    }
}


