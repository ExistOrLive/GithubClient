//
//  ZLRepoContributorsController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/8.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZMMVVM
import ZLGitRemoteService

class ZLRepoContributorsController: ZMTableViewController {
    
    let repoFullName: String
    
    init(repoFullName: String) {
        self.repoFullName = repoFullName
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ZLLocalizedString(string: "contributor", comment: "贡献者")
        
        self.setRefreshViews(types: [.header])
        
        self.tableView.contentInsetAdjustmentBehavior = .automatic
        self.tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        self.tableView.register(ZLUserTableViewCell.self,
                                forCellReuseIdentifier: "ZLUserTableViewCell")
        
        self.viewStatus = .loading
        self.refreshLoadNewData()
    }
    
    
    override func refreshLoadNewData() {
        ZLRepoServiceShared()?.getRepositoryContributors(withFullName: repoFullName,
                                                        serialNumber: NSString.generateSerialNumber()) { [weak self](resultModel: ZLOperationResultModel) in
            guard let self else { return }
            self.viewStatus = .normal
            self.endRefreshViews()
            
            if resultModel.result,
               let data: [ZLGithubUserModel] = resultModel.data as? [ZLGithubUserModel] {
                
                self.sectionDataArray.forEach({ $0.zm_removeFromSuperViewModel() })
                self.sectionDataArray.removeAll()
                
                let cellDataArray = data.map { ZLUserTableViewCellDataV3(model: $0) }
                self.zm_addSubViewModels(cellDataArray)
                self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDataArray)]
                self.tableView.reloadData()
                
                self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
                
            } else {
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query Contributors Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
            }
        }
    }
}


