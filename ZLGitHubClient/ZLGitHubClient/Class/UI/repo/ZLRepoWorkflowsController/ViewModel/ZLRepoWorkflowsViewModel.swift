//
//  ZLRepoWorkflowsViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoWorkflowsViewModel: ZLBaseViewModel {
    
    // view
    var baseView : ZLGithubItemListView?
    
    // model
    var repoFullName : String?
    var currentPage : Int = 0
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let view : ZLGithubItemListView = targetView as? ZLGithubItemListView else {
            return
        }
        baseView = view
        baseView?.delegate = self
        
        repoFullName = targetModel as? String
        
        baseView?.beginRefresh()
    }
    
    
    func loadMoreData() {
        
        weak var weakSelf = self
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoWorkflows(withFullName: repoFullName ?? "", per_page: 20, page: self.currentPage + 1, serialNumber: NSString.generateSerialNumber()) { (result : ZLOperationResultModel) in
            
            if result.result == false  {
                ZLToastView.showMessage("Query failed")
                weakSelf?.baseView?.endRefreshWithError()
                return
            }
            
            guard let dataArray : [ZLGithubRepoWorkflowModel] = result.data as? [ZLGithubRepoWorkflowModel] else {
                ZLToastView.showMessage("Query failed")
                weakSelf?.baseView?.endRefreshWithError()
                return
            }
            
            var cellDatas : [ZLGithubItemTableViewCellData] = []
            for data in dataArray {
                let cellData = ZLWorkflowTableViewCellData.init(data: data)
                cellData.repoFullName = self.repoFullName ?? ""
                cellDatas.append(cellData)
                weakSelf?.addSubViewModel(cellData)
            }
            weakSelf?.baseView?.appendCellDatas(cellDatas: cellDatas)
            weakSelf?.currentPage += 1
            
        }
        
    }
    
    func loadNewData() {
        
        weak var weakSelf = self
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoWorkflows(withFullName: repoFullName ?? "", per_page: 20, page: 1, serialNumber: NSString.generateSerialNumber()) { (result : ZLOperationResultModel) in
            
            if result.result == false  {
                ZLToastView.showMessage("Query failed")
                weakSelf?.baseView?.endRefreshWithError()
                return
            }
            
            guard let dataArray : [ZLGithubRepoWorkflowModel] = result.data as? [ZLGithubRepoWorkflowModel] else {
                ZLToastView.showMessage("Query failed")
                weakSelf?.baseView?.endRefreshWithError()
                return
            }
            
            var cellDatas : [ZLGithubItemTableViewCellData] = []
            for data in dataArray {
                let cellData = ZLWorkflowTableViewCellData.init(data: data)
                cellData.repoFullName = self.repoFullName ?? ""
                cellDatas.append(cellData)
                weakSelf?.addSubViewModel(cellData)
            }
            weakSelf?.baseView?.resetCellDatas(cellDatas: cellDatas)
            weakSelf?.currentPage = 2
            
        }
        
    }

}

extension ZLRepoWorkflowsViewModel: ZLGithubItemListViewDelegate {
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void{
        self.loadNewData()
    }
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) -> Void{
        self.loadMoreData()
    }
}
