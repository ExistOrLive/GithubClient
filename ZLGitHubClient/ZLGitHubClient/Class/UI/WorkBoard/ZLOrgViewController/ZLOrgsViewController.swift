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
        
        weak var weakSelf = self
        ZLServiceManager.sharedInstance.viewerServiceModel?.getMyOrgs(serialNumber: NSString.generateSerialNumber())
        { (resultModel : ZLOperationResultModel) in
            if resultModel.result == false {
                weakSelf?.githubItemListView.endRefreshWithError()
                if let errorMessage : ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel{
                    ZLToastView.showMessage("Query Orgs Failed \(errorMessage.statusCode) \(errorMessage.message)");
                }
                return
            } else {
                if let queryResult : ViewerOrgsQuery.Data = resultModel.data as? ViewerOrgsQuery.Data{
                    var cellDatas : [ZLUserTableViewCellDataForViewerOrgs] = []
                    for edge in queryResult.viewer.organizations.edges! {
                        let cellData = ZLUserTableViewCellDataForViewerOrgs(data: edge!.node!)
                        weakSelf?.addSubViewModel(cellData)
                        cellDatas.append(cellData)
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
