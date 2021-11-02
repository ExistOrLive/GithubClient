//
//  ZLOrgsViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/22.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLOrgsViewController: ZLBaseViewController, ZLGithubItemListViewDelegate {

    var githubItemListView : ZLGithubItemListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ZLLocalizedString(string: "organizations", comment: "")
                
        let listView = ZLGithubItemListView()
        self.githubItemListView = listView
        
        self.contentView.addSubview(listView)
        listView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        listView.setTableViewHeader()
        listView.delegate = self
        
        listView.beginRefresh()
        
    }
    
    
    // ZLGithubItemListViewDelegate
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {
        
        ZLServiceManager.sharedInstance.viewerServiceModel?.getMyOrgs(serialNumber: NSString.generateSerialNumber())
        { [weak weakSelf = self](resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false {
                weakSelf?.githubItemListView.endRefreshWithError()
                if let errorMessage : ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel{
                    ZLToastView.showMessage("Query Orgs Failed \(errorMessage.statusCode) \(errorMessage.message)");
                }
            } else {
                if let queryResult : ViewerOrgsQuery.Data = resultModel.data as? ViewerOrgsQuery.Data{
                    var cellDatas : [ZLUserTableViewCellDataForViewerOrgs] = []
                    if let edges = queryResult.viewer.organizations.edges {
                        for edge in edges  {
                            if let node = edge?.node {
                                let cellData = ZLUserTableViewCellDataForViewerOrgs(data: node)
                                weakSelf?.addSubViewModel(cellData)
                                cellDatas.append(cellData)
                            }
                        }
                    }
                    
                    weakSelf?.githubItemListView.resetCellDatas(cellDatas: cellDatas)
                } else {
                    weakSelf?.githubItemListView.endRefreshWithError()
                }
            }
        }
    }
    
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        
    }
}
