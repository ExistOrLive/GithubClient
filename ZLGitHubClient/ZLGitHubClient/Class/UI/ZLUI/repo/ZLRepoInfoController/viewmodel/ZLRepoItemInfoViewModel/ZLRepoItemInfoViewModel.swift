//
//  ZLRepoItemInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/2.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoItemInfoViewModel: ZLBaseViewModel {
    
    // model
    private var repoInfoModel : ZLGithubRepositoryModel?
    
    private var currentBranch : String?                  // 当前选中的分支
    
    // view
    private var repoItemInfoView : ZLRepoItemInfoView?
    
        
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let repoInfoModel : ZLGithubRepositoryModel = targetModel as? ZLGithubRepositoryModel else {
            return
        }
        self.repoInfoModel = repoInfoModel
        
        guard let repoItemInfoView : ZLRepoItemInfoView = targetView as? ZLRepoItemInfoView else
        {
            return
        }
        self.repoItemInfoView = repoItemInfoView
        self.repoItemInfoView?.delegate = self
        
        self.setViewDataForRepoItemInfoView()
    }
    
    
    func setViewDataForRepoItemInfoView()
    {
        self.repoItemInfoView?.branchInfoLabel.text = self.repoInfoModel?.default_branch
        
        self.repoItemInfoView?.languageInfoLabel.text = self.repoInfoModel?.language
        
       // self.setCodeInfo()
    }
    
    
    func setCodeInfo()
    {
        let size = self.repoInfoModel?.size ?? 0
        if size == 0
        {
            self.repoItemInfoView?.codeInfoLabel.text = nil
        }
        else
        {
            if size < 1024
            {
                self.repoItemInfoView?.codeInfoLabel.text = "\(size)B"
            }
            else if size < 1024 * 1024
            {
                self.repoItemInfoView?.codeInfoLabel.text = "\(size / 1024)KB"
            }
            else
            {
                self.repoItemInfoView?.codeInfoLabel.text = "\(size / 1024 / 1024)GB"
            }
            
        }
    }
}


extension ZLRepoItemInfoViewModel : ZLRepoItemInfoViewDelegate
{
     func onZLRepoItemInfoViewEvent(type : ZLRepoItemType)
     {
        if self.repoInfoModel == nil
        {
            return
        }
        
        switch(type)
        {
        case .action : do{
            let workflowVC = ZLRepoWorkflowsController.init()
            workflowVC.repoFullName = self.repoInfoModel?.full_name
            self.viewController?.navigationController?.pushViewController(workflowVC, animated: true)
            }
        case .branch :do{
            ZLRepoBranchesView.showRepoBranchedView(repoFullName: self.repoInfoModel!.full_name,currentBranch: self.currentBranch ?? self.repoInfoModel!.default_branch , handle: {(branch: String) in
                
                self.currentBranch = branch
                self.repoItemInfoView?.branchInfoLabel.text = branch
            })
            }
        case .pullRequest : do{
            let controller = ZLRepoPullRequestController.init()
            controller.repoFullName = self.repoInfoModel?.full_name
            self.viewController?.navigationController?.pushViewController(controller, animated: true)
            }
        case .code : do{
            let controller = ZLRepoContentController()
            controller.branch = self.currentBranch ?? self.repoInfoModel!.default_branch
            controller.repoFullName = self.repoInfoModel?.full_name
            controller.path = ""
            self.viewController?.navigationController?.pushViewController(controller, animated: true)
            }
        case .commit : do{
            let controller = ZLRepoCommitController.init()
            controller.repoFullName = self.repoInfoModel?.full_name
            controller.branch = self.currentBranch ?? self.repoInfoModel!.default_branch
            self.viewController?.navigationController?.pushViewController(controller, animated: true)
            }
        case .language : do{
            ZLRepoLanguagesPercentView.showRepoLanguagesPercentView(fullName: self.repoInfoModel?.full_name ?? "")
            }
        }
    }
}

