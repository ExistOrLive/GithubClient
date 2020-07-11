//
//  ZLRepoIssuesViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/14.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoIssuesViewModel: ZLBaseViewModel {
    
    var baseView : ZLRepoIssuesView?
    
    // model
    var fullName : String?
    var filterOpen : Bool = true
    var currentPage : Int = 0
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        self.fullName = targetModel as? String
        
        guard let repoIssuesView : ZLRepoIssuesView = targetView as? ZLRepoIssuesView else{
            return
        }
        self.baseView = repoIssuesView
        self.baseView?.githubItemListView.delegate = self
        self.baseView?.githubItemListView.beginRefresh()
    }
    
    @IBAction func onFilterButtonClicked(_ sender: Any) {
        
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: ZLLocalizedString(string: "Filter", comment: ""), withInitIndex: self.filterOpen ? 0 : 1, withDataArray: ["open","closed"], withResultBlock: {(result : UInt) in
            
            self.baseView?.filterLabel.text = result == 0 ? "open" : "closed"
            self.filterOpen = result == 0 ? true : false
            
            SVProgressHUD.show()
            
            self.baseView?.githubItemListView.clearListView()
            self.loadNewData()
            
        })
        
    }
    
}



extension ZLRepoIssuesViewModel
{
    func loadNewData(){
        
        if self.fullName == nil {
            SVProgressHUD.dismiss()
            self.baseView?.githubItemListView.endRefreshWithError()
            return
        }
        
        weak var weakSelf = self
        
        ZLRepoServiceModel.shared().getRepositoryIssues(withFullName: self.fullName!, state: self.filterOpen ?  "open" : "closed", per_page:10, page: 1, serialNumber: NSString.generateSerialNumber()) { (resultModel : ZLOperationResultModel) in
            
            SVProgressHUD.dismiss()
            
            if resultModel.result == false
            {
                weakSelf?.baseView?.githubItemListView.endRefreshWithError()
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query issues Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }
            
            guard let data : [ZLGithubIssueModel] = resultModel.data as? [ZLGithubIssueModel] else
            {
                weakSelf?.baseView?.githubItemListView.endRefreshWithError()
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
            weakSelf?.baseView?.githubItemListView.resetCellDatas(cellDatas: cellDatas)
            weakSelf?.currentPage = 1
        }
    }
    
    
    func loadMoreData(){
        
        if self.fullName == nil {
            SVProgressHUD.dismiss()
            self.baseView?.githubItemListView.endRefreshWithError()
            return
        }
        
        weak var weakSelf = self
        
        ZLRepoServiceModel.shared().getRepositoryIssues(withFullName: self.fullName!, state: self.filterOpen ?  "open" : "closed", per_page:10, page: Int(self.currentPage) + 1, serialNumber: NSString.generateSerialNumber()) { (resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false
            {
                weakSelf?.baseView?.githubItemListView.endRefreshWithError()
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query issues Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }
            
            guard let data : [ZLGithubIssueModel] = resultModel.data as? [ZLGithubIssueModel] else
            {
                weakSelf?.baseView?.githubItemListView.endRefreshWithError()
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
            weakSelf?.baseView?.githubItemListView.appendCellDatas(cellDatas: cellDatas)
            weakSelf?.currentPage = weakSelf!.currentPage + 1
        }
    }
    
}



extension ZLRepoIssuesViewModel : ZLGithubItemListViewDelegate
{
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        self.loadMoreData()
    }
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void
    {
        self.loadNewData()
    }
}
