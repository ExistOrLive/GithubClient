//
//  ZLRepoWatchedUsersViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/24.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoWatchedUsersViewModel: ZLBaseViewModel {
    
    var itemListView : ZLGithubItemListView?
    
    // model
    var fullName : String?
    var currentPage : Int = 0
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        self.fullName = targetModel as? String
        
        guard let itemsView : ZLGithubItemListView = targetView as? ZLGithubItemListView else{
            return
        }
        self.itemListView = itemsView
        self.itemListView?.delegate = self
        self.itemListView?.beginRefresh()
    }
}

extension ZLRepoWatchedUsersViewModel
{
    func loadNewData()
    {
        if self.fullName == nil
        {
            ZLToastView .showMessage("fullName is nil")
            self.itemListView?.endRefreshWithError()
            return
        }
        
        weak var weakSelf = self
        
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoWatchers(withFullName: self.fullName!, serialNumber: NSString.generateSerialNumber(),per_page: 10, page: 1) { (resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false
            {
                weakSelf?.itemListView?.endRefreshWithError()
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query Watchers Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }
            
            guard let data : [ZLGithubUserModel] = resultModel.data as? [ZLGithubUserModel] else
            {
                weakSelf?.itemListView?.endRefreshWithError()
                ZLToastView.showMessage("ZLGithubUserModel transfer error")
                return;
            }
            
            var cellDatas : [ZLUserTableViewCellData] = []
            for userData in data
            {
                let cellData = ZLUserTableViewCellData.init(userModel: userData)
                self.addSubViewModel(cellData)
                cellDatas.append(cellData)
            }
            weakSelf?.itemListView?.resetCellDatas(cellDatas: cellDatas)
            weakSelf?.currentPage = 1
        }
    }
    
    func loadMoreData()
    {
        if self.fullName == nil
        {
            ZLToastView .showMessage("fullName is nil")
            self.itemListView?.endRefreshWithError()
            return
        }
        
        weak var weakSelf = self
        
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoWatchers(withFullName: self.fullName!, serialNumber: NSString.generateSerialNumber(),per_page: 10, page: self.currentPage + 1) { (resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false
            {
                weakSelf?.itemListView?.endRefreshWithError()
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query Watchers Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }
            
            guard let data : [ZLGithubUserModel] = resultModel.data as? [ZLGithubUserModel] else
            {
                weakSelf?.itemListView?.endRefreshWithError()
                ZLToastView.showMessage("ZLGithubUserModel transfer error")
                return;
            }
            
            var cellDatas : [ZLUserTableViewCellData] = []
            for userData in data
            {
                let cellData = ZLUserTableViewCellData.init(userModel: userData)
                self.addSubViewModel(cellData)
                cellDatas.append(cellData)
            }
            weakSelf?.itemListView?.appendCellDatas(cellDatas: cellDatas)
            weakSelf?.currentPage = weakSelf!.currentPage + 1
        }
    }
    
}



extension ZLRepoWatchedUsersViewModel : ZLGithubItemListViewDelegate
{
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        self.loadMoreData()
    }
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void
    {
        self.loadNewData()
    }
}
