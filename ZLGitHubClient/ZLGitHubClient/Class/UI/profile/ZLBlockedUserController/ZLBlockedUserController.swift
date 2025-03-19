//
//  ZLBlockedUserController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/10/12.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLGitRemoteService
import ZMMVVM

class ZLBlockedUserController: ZMTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        self.title = ZLLocalizedString(string: "Blocked User", comment: "屏蔽的用户")
        
        self.setRefreshViews(types: [.header])
        self.tableView.register(ZLUserTableViewCell.self,
                           forCellReuseIdentifier: "ZLUserTableViewCell")
        self.tableView.contentInsetAdjustmentBehavior = .automatic
        self.tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }

    override func refreshLoadNewData() {
        
        ZLUserServiceShared()?.getBlockedUsers(withSerialNumber:NSString.generateSerialNumber())
        { [weak self] (model: ZLOperationResultModel) in
            guard let self else { return }
            self.viewStatus = .normal
            self.endRefreshViews()
            
            if model.result,
               let data: [ZLGithubUserModel] = model.data as? [ZLGithubUserModel]  {
                
                self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                let cellDataArray = data.map { ZLUserTableViewCellDataV3(model: $0) }
                self.zm_addSubViewModels(cellDataArray)
                self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDataArray)]
                self.tableView.reloadData()
                
                self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
            } else {
                if let errorModel: ZLGithubRequestErrorModel = model.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage("query Blocked User list failed statusCode[\(errorModel.statusCode)] errorMessage[\(errorModel.message)]")
                } else {
                    ZLToastView.showMessage("query Blocked User list failed")
                }
                
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
            }
        }
    }

}
