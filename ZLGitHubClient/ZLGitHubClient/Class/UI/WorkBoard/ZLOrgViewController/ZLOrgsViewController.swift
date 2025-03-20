//
//  ZLOrgsViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/22.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZMMVVM
import ZLBaseExtension
import ZLGitRemoteService

class ZLOrgsViewController: ZMTableViewController {

    @objc init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewStatus = .loading
        self.refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.title = ZLLocalizedString(string: "organizations", comment: "")
        
        self.setRefreshViews(types: [.header])
        
        self.tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        self.tableView.register(ZLUserTableViewCell.self,
                                forCellReuseIdentifier: "ZLUserTableViewCell")
    }
    

    override func refreshLoadNewData() {
        ZLViewerServiceShared()?.getMyOrgs(serialNumber: NSString.generateSerialNumber()) { [weak self](resultModel: ZLOperationResultModel) in

            guard let self else { return }
            
            if resultModel.result,
               let queryResult: ViewerOrgsQuery.Data = resultModel.data as? ViewerOrgsQuery.Data {
                
                var cellDatas: [ZLUserTableViewCellDataForViewerOrgs] = []
                if let edges = queryResult.viewer.organizations.edges {
                    for edge in edges {
                        if let node = edge?.node {
                            let cellData = ZLUserTableViewCellDataForViewerOrgs(data: node)
                            cellDatas.append(cellData)
                        }
                    }
                }
                self.zm_addSubViewModels(cellDatas)
                
                self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDatas)]
               
                
                self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
                self.endRefreshViews()
                self.tableViewProxy.reloadData()
               
            } else {
                if let errorMessage: ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage("Query Orgs Failed \(errorMessage.statusCode) \(errorMessage.message)")
                }
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
                self.endRefreshViews()
            }
        }
    }
}
