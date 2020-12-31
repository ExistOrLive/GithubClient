//
//  ZLMyRepoesController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/24.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLMyRepoesController: ZLBaseViewController {
    
    // view
    var itemListView : ZLGithubItemListView!
    
    // after
    var after : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ZLLocalizedString(string: "My Repos", comment: "")
        
        // view
        let itemListView = ZLGithubItemListView()
        itemListView.setTableViewHeader()
        itemListView.setTableViewFooter()
        itemListView.delegate = self
        self.contentView.addSubview(itemListView)
        itemListView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.itemListView = itemListView
        
        self.itemListView.beginRefresh()
    }

}

extension ZLMyRepoesController : ZLGithubItemListViewDelegate {
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {
        
        weak var weakSelf = self
        ZLServiceManager.sharedInstance.repoServiceModel?.getTopReposWith(afterCursor: nil , serialNumber: NSString.generateSerialNumber()) { (resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel{
                    ZLToastView.showMessage(errorModel.message)
                }
                weakSelf?.itemListView.endRefreshWithError()
            } else {
                if let data = resultModel.data as? ViewerTopRepositoriesQuery.Data {
                    weakSelf?.after = data.viewer.topRepositories.pageInfo.endCursor
                    var cellDatas : [ZLRepoTableViewCellDataForTopRepoQuery] = []
                    for tmpData in data.viewer.topRepositories.nodes!{
                        let cellData = ZLRepoTableViewCellDataForTopRepoQuery(data: tmpData!)
                        cellDatas.append(cellData)
                    }
                    weakSelf?.addSubViewModels(cellDatas)
                    weakSelf?.itemListView.resetCellDatas(cellDatas: cellDatas)
                } else {
                    weakSelf?.itemListView.endRefreshWithError()
                }
            }
        }
        
    }
    
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        
        weak var weakSelf = self
        ZLServiceManager.sharedInstance.repoServiceModel?.getTopReposWith(afterCursor: self.after , serialNumber: NSString.generateSerialNumber()) { (resultModel : ZLOperationResultModel) in
            if resultModel.result == false {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel{
                    ZLToastView.showMessage(errorModel.message)
                }
                weakSelf?.itemListView.endRefreshWithError()
            } else {
                if let data = resultModel.data as? ViewerTopRepositoriesQuery.Data {
                    weakSelf?.after = data.viewer.topRepositories.pageInfo.endCursor
                    var cellDatas : [ZLRepoTableViewCellDataForTopRepoQuery] = []
                    for tmpData in data.viewer.topRepositories.nodes!{
                        let cellData = ZLRepoTableViewCellDataForTopRepoQuery(data: tmpData!)
                        cellDatas.append(cellData)
                    }
                    weakSelf?.addSubViewModels(cellDatas)
                    weakSelf?.itemListView.appendCellDatas(cellDatas: cellDatas)
                } else {
                    weakSelf?.itemListView.endRefreshWithError()
                }
            }
        }
    }
    
}
