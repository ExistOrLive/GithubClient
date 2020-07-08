//
//  ZLRepoPullRequestViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/15.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoPullRequestViewModel: ZLBaseViewModel {
    
    // view
    var pullRequestView : ZLRepoPullRequestView?
    
    //model
    var fullName : String?
    var filterOpen : Bool = true
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
    
        guard let pullRequestView : ZLRepoPullRequestView = targetView as? ZLRepoPullRequestView else
        {
            return
        }
        self.pullRequestView = pullRequestView
        self.pullRequestView?.githubItemListView.delegate = self
        
        self.fullName = targetModel as? String
        
        self.pullRequestView?.githubItemListView.beginRefresh()
    }
    
    
    
    @IBAction func onFilterButtonClicked(_ sender: Any) {
        
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: ZLLocalizedString(string: "Filter", comment: ""), withInitIndex: self.filterOpen ? 0 : 1, withDataArray: ["open","closed"], withResultBlock: {(result : UInt) in
            
            self.pullRequestView?.filterLabel.text = result == 0 ? "open" : "closed"
            self.filterOpen = result == 0 ? true : false
            
            if self.fullName != nil {
                SVProgressHUD.show()
                self.sendPullRequestListRequest()
            }
            
        })
        
    }
    
    
}

extension ZLRepoPullRequestViewModel : ZLGithubItemListViewDelegate
{
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void{
        self .sendPullRequestListRequest()
    }
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) -> Void{
        
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
        ZLRepoServiceModel.shared().getRepoPullRequest(withFullName: self.fullName!, state: self.filterOpen ? "open" : "closed", serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
            
            SVProgressHUD.dismiss()
            
            if resultModel.result == false
            {
                weakSelf?.pullRequestView?.githubItemListView.endRefreshWithError()
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query Pull Request Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }
            
            guard let data : [ZLGithubPullRequestModel] = resultModel.data as? [ZLGithubPullRequestModel] else
            {
                weakSelf?.pullRequestView?.githubItemListView.endRefreshWithError()
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
            weakSelf?.pullRequestView?.githubItemListView.resetCellDatas(cellDatas: cellDatas)
            
        })
    }
}
