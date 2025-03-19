//
//  ZLUserAdditionInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZLUIUtilities
import ZMMVVM

@objcMembers class ZLUserAdditionInfoController: ZMTableViewController  {

    var type: ZLUserAdditionInfoType = .repositories                       // ! 附加信息类型 仓库/代码片段等
    var login: String = ""                                        // login
    var currentPage: Int  =  0                     // 当前页号
    static let per_page: UInt = 20                            // 每页多少记录
    
    @objc init() {
        super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        
        switch type {
        case .repositories:do {
            self.title = ZLLocalizedString(string: "repositories", comment: "仓库")
        }
        case .gists:do {
            self.title = ZLLocalizedString(string: "gists", comment: "代码片段")
        }
        case .followers:do {
            self.title = ZLLocalizedString(string: "followers", comment: "粉丝")
        }
        case .following:do {
            self.title = ZLLocalizedString(string: "following", comment: "关注")
        }
        case .starredRepos:do {
            self.title = ZLLocalizedString(string: "stars", comment: "标星")
        }
        @unknown default:
            break 
        }
        
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        setRefreshViews(types: [.header,.footer])
        tableView.register(ZLRepositoryTableViewCell.self,
                           forCellReuseIdentifier: "ZLRepositoryTableViewCell")
        tableView.register(ZLUserTableViewCell.self,
                           forCellReuseIdentifier: "ZLUserTableViewCell")
        tableView.register(ZLGistTableViewCell.self,
                           forCellReuseIdentifier: "ZLGistTableViewCell")
    }
    
    override func refreshLoadNewData() {
        loadData(isLoadNew: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(isLoadNew: false)
    }
}


extension ZLUserAdditionInfoController {
    func loadData(isLoadNew: Bool) {
        var page = 1
        if !isLoadNew {
            page = self.currentPage
        }
        
        ZLUserServiceShared()?.getAdditionInfo(forUser: login,
                                               infoType: type,
                                               page: UInt(page),
                                               per_page: Self.per_page,
                                               serialNumber: NSString.generateSerialNumber()) { [weak self](resultModel) in
            guard let self else { return }
            if resultModel.result == true, let itemArray = resultModel.data as? [Any] {

                let cellDataArray: [ZMBaseTableViewCellViewModel] = itemArray.compactMap {
                    self.getCellDataWithData(data: $0)
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
    
    func getCellDataWithData(data: Any?) -> ZMBaseTableViewCellViewModel? {

        if let data = data as? ZLGithubRepositoryModel {
            return ZLRepositoryTableViewCellDataV3(data: data)
        } else if let data = data as? ZLGithubUserModel {
            return ZLUserTableViewCellDataV3(model: data)
        } else if let data = data as? ZLGithubGistModel {
            return ZLGistTableViewCellData.init(data: data)
        }
        return nil
    }
}
