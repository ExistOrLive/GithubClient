//
//  ZLRepoContributorsViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/8.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoContributorsViewModel: ZLBaseViewModel {

    var itemListView : ZLGithubItemListView?
    var fullName : String?
    
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

extension ZLRepoContributorsViewModel
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
        
        ZLRepoServiceModel.shared().getRepositoryContributors(withFullName: self.fullName!, serialNumber: NSString.generateSerialNumber()) { (resultModel : ZLOperationResultModel) in
            if resultModel.result == false
            {
                weakSelf?.itemListView?.endRefreshWithError()
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query Contributors Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }
            
            guard let data : [ZLGithubUserModel] = resultModel.data as? [ZLGithubUserModel] else
            {
                weakSelf?.itemListView?.endRefreshWithError()
                ZLToastView.showMessage("ZLGithubUserModel transfer error")
                return;
            }
            
            var cellDatas : [ZLUserTableViewCellData] = []
            for userModel in data
            {
                let cellData = ZLUserTableViewCellData.init(userModel: userModel )
                self.addSubViewModel(cellData)
                cellDatas.append(cellData)
            }
            weakSelf?.itemListView?.resetCellDatas(cellDatas: cellDatas)
        }
    }
}


 
extension ZLRepoContributorsViewModel : ZLGithubItemListViewDelegate
{
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        
    }
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void
    {
        self.loadNewData()
    }
}

