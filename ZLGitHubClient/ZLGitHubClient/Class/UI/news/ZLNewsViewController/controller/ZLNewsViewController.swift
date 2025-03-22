//
//  ZLNewsViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/21.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZMMVVM
import ZLUIUtilities
import ZLGitRemoteService

class ZLNewsViewController: ZMTableViewController {
    
    var currentPage: Int = 0
    static let per_page: Int = 20
    
    lazy var loginName: String = {
        ZLServiceManager.sharedInstance.viewerServiceModel?.currentUserModel?.loginName ?? ""
    }()
    
    
    @objc init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        title = ZLLocalizedString(string: "news", comment: "动态")
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        setRefreshViews(types: [.header,.footer])
        tableView.register(ZLEventTableViewCell.self, 
                           forCellReuseIdentifier: "ZLEventTableViewCell")
        tableView.register(ZLPushEventTableViewCell.self, 
                           forCellReuseIdentifier: "ZLPushEventTableViewCell")
        tableView.register(ZLCommitCommentEventTableViewCell.self, 
                           forCellReuseIdentifier: "ZLCommitCommentEventTableViewCell")
        tableView.register(ZLIssueCommentEventTableViewCell.self, 
                           forCellReuseIdentifier: "ZLIssueCommentEventTableViewCell")
        tableView.register(ZLIssueEventTableViewCell.self, 
                           forCellReuseIdentifier: "ZLIssueEventTableViewCell")
        tableView.register(ZLCommitCommentEventTableViewCell.self, 
                           forCellReuseIdentifier: "ZLCommitCommentEventTableViewCell")
        tableView.register(ZLPullRequestEventTableViewCell.self, 
                           forCellReuseIdentifier: "ZLPullRequestEventTableViewCell")
    }
    
    func registerNotification() {
        // 注册事件监听
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLGithubConfigUpdate_Notification, object: nil)
    }
    
    override func refreshLoadNewData() {
        loadData(isLoadNew: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(isLoadNew: false)
    }

}

// MARK: - Action
extension ZLNewsViewController {
    @objc func onNotificationArrived(notification: Notification) {
        ZLLog_Info("onNotificationArrived: notification[\(notification.name)]")

        switch notification.name {
            case ZLGithubConfigUpdate_Notification: do {
                self.tableView.reloadData()
            }
            default:
                ZLLog_Info("event have no deal")
        }
    }
}


// MARK: - Request
extension ZLNewsViewController {
    func loadData(isLoadNew: Bool) {

        var page = 1
        if !isLoadNew {
            page = currentPage
        }
        
        ZLEventServiceShared()?.getReceivedEvents(forUser: loginName,
                                                  page: UInt(page),
                                                  per_page: UInt(Self.per_page),
                                                  serialNumber: NSString.generateSerialNumber())
        { [weak self] resultModel in
            guard let self else { return }
            if resultModel.result == true, let itemArray: [ZLGithubEventModel] = resultModel.data as? [ZLGithubEventModel] {

                let cellDataArray: [ZMBaseTableViewCellViewModel] = itemArray.map {
                    let cellData = ZLEventTableViewCellData.getCellDataWithEventModel(eventModel: $0)
                    return cellData
                }
                self.zm_addSubViewModels(cellDataArray)
                
                if isLoadNew {
                    self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDataArray)]
                    self.currentPage = 2
                } else {
                    self.sectionDataArray.first?.cellDatas.append(contentsOf: cellDataArray)
                    self.currentPage = self.currentPage + 1
                }
                
                self.tableView.reloadData()
                
                self.endRefreshViews(noMoreData: cellDataArray.count < Self.per_page)
                self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal

            } else {
                self.endRefreshViews()
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
                
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
            }
        }
    }

}
