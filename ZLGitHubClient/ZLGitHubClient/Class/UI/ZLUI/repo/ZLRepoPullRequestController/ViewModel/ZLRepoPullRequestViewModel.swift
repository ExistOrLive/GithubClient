//
//  ZLRepoPullRequestViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/15.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoPullRequestViewModel: ZLBaseViewModel {
    
    var pullRequestListView : ZLPullRequestListView?
    
    var fullName : String?
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
    
        guard let pullRequestListView : ZLPullRequestListView = targetView as? ZLPullRequestListView else
        {
            return
        }
        self.pullRequestListView = pullRequestListView
        self.pullRequestListView?.delegate = self
        
        self.fullName = targetModel as? String
        
        self.pullRequestListView?.beginRefresh()
    }
}

extension ZLRepoPullRequestViewModel : ZLPullRequestListViewDelegate
{
    func pullRequestListViewRefreshDragUp(pullRequestListView: ZLPullRequestListView) {
        //self.sendPullRequestListRequest()
    }
    
 
        
    func pullRequestListViewRefreshDragDown(pullRequestListView: ZLPullRequestListView) -> Void
    {
        self.sendPullRequestListRequest()
    }
}


extension ZLRepoPullRequestViewModel
{
    func sendPullRequestListRequest()
    {
        if self.fullName == nil
        {
            ZLToastView.showMessage("Repo fullName is nil")
            return
        }
        
        weak var weakSelf = self
        ZLRepoServiceModel.shared().getRepoPullRequest(withFullName: self.fullName!, state: "all", serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false
            {
                weakSelf?.pullRequestListView?.endRefreshWithError()
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query Pull Request Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }
            
            guard let data : [ZLGithubPullRequestModel] = resultModel.data as? [ZLGithubPullRequestModel] else
            {
                weakSelf?.pullRequestListView?.endRefreshWithError()
                ZLToastView.showMessage("ZLGithubPullRequestModel transfer error")
                return;
            }
            
            var cellDatas : [ZLPullRequestTableViewCellData] = []
            for pullRequestModel in data
            {
                let cellData = ZLPullRequestTableViewCellData.init(eventModel: pullRequestModel)
                self.addSubViewModel(cellData)
                cellDatas.append(cellData)
            }
            weakSelf?.pullRequestListView?.resetCellDatas(cellDatas: cellDatas)
            
        })
    }
}
