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
        
        self.setViewDataForRepoItemInfoView()
    }
    
    
    func setViewDataForRepoItemInfoView()
    {
        self.repoItemInfoView?.branchInfoLabel.text = self.repoInfoModel?.default_branch
        self.repoItemInfoView?.languageInfoLabel.text = self.repoInfoModel?.language
        
        self.setLanguageInfo()
        
    }
    
    
    func setLanguageInfo()
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
