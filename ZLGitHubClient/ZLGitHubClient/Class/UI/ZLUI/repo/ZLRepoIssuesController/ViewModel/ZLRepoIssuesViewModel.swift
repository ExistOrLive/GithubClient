//
//  ZLRepoIssuesViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/14.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoIssuesViewModel: ZLBaseViewModel {

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

extension ZLRepoIssuesViewModel
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
        
        ZLRepoServiceModel.shared().getRepositoryIssues(withFullName: self.fullName!, serialNumber: NSString.generateSerialNumber()) { (resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false
            {
                weakSelf?.itemListView?.endRefreshWithError()
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query issues Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }
            
            guard let data : [ZLGithubIssueModel] = resultModel.data as? [ZLGithubIssueModel] else
            {
                weakSelf?.itemListView?.endRefreshWithError()
                ZLToastView.showMessage("ZLGithubIssueModel transfer error")
                return;
            }
            
            var cellDatas : [ZLIssueTableViewCellData] = []
            for issueModel in data
            {
                let cellData = ZLIssueTableViewCellData.init(issueModel: issueModel)
                self.addSubViewModel(cellData)
                cellDatas.append(cellData)
            }
            weakSelf?.itemListView?.resetCellDatas(cellDatas: cellDatas)
        }
    }
}


 
extension ZLRepoIssuesViewModel : ZLGithubItemListViewDelegate
{
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        
    }
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void
    {
        self.loadNewData()
    }
}
