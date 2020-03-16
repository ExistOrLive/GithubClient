//
//  ZLRepoCommitViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoCommitViewModel: ZLBaseViewModel {
    
    private var fullName : String?
    
    private var utilDate : Date?
    
    private var itemListView : ZLGithubItemListView?
    
    private var commitArray : [ZLGithubCommitModel] = []
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        self.fullName = targetModel as? String
        
        guard let itemListView = targetView as? ZLGithubItemListView else
        {
            return
        }
        self.itemListView = itemListView
        self.itemListView?.delegate = self
        
        self.itemListView?.beginRefresh()
    }
}

extension ZLRepoCommitViewModel
{
    func loadMoreData()
    {
        if self.fullName == nil
        {
            ZLToastView .showMessage("fullName is nil")
            return
        }
        
        weak var weakSelf = self
        ZLRepoServiceModel.shared().getRepoCommit(withFullName: self.fullName!, until: self.utilDate, since: nil, serialNumber: NSString.generateSerialNumber(), completeHandle: { (resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false
            {
                weakSelf?.itemListView?.endRefreshWithError()
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query Pull Request Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
            }
            
            guard let data : [ZLGithubCommitModel] = resultModel.data as? [ZLGithubCommitModel] else
            {
                weakSelf?.itemListView?.endRefreshWithError()
                ZLToastView.showMessage("ZLGithubCommitModel transfer error")
                return;
            }
            
            weakSelf?.utilDate = data.last
            var cellDatas : [ZLCommitTableViewCellData] = []
            for commitModel in data
            {
                let cellData = ZLCommitTableViewCellData.init(commitModel:commitModel )
                self.addSubViewModel(cellData)
                cellDatas.append(cellData)
            }
            weakSelf?.itemListView?.resetCellDatas(cellDatas: cellDatas)
            
            
        })
    }
    
    func loadNewData()
    {
        if self.fullName == nil
        {
            ZLToastView .showMessage("fullName is nil")
            return
        }
        
        ZLRepoServiceModel.shared().getRepoCommit(withFullName: self.fullName!, until: Date.init(), since: nil, serialNumber: NSString.generateSerialNumber(), completeHandle: { (resultModel : ZLOperationResultModel) in
            
        })
    }
}


 
extension ZLRepoCommitViewModel : ZLGithubItemListViewDelegate
{
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void
    {
        self.loadNewData()
    }
    
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) -> Void
    {
        self.loadMoreData()()
    }
}
