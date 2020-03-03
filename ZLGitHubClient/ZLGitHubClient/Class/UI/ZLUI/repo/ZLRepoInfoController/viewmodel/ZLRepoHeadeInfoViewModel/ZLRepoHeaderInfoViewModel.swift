//
//  ZLRepoHeaderInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/2.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoHeaderInfoViewModel: ZLBaseViewModel {
    
    // model
    private var repoInfoModel : ZLGithubRepositoryModel?
    
    // view
    private var repoHeaderInfoView : ZLRepoHeaderInfoView?

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let repoInfoModel : ZLGithubRepositoryModel = targetModel as? ZLGithubRepositoryModel else {
            return
        }
        self.repoInfoModel = repoInfoModel
        
        guard let repoHeaderInfoView : ZLRepoHeaderInfoView = targetView as? ZLRepoHeaderInfoView else
        {
            return
        }
        self.repoHeaderInfoView = repoHeaderInfoView
        self.repoHeaderInfoView?.delegate = self
        
        self.setViewDataForRepoHeaderInfoView()
    }
    
    
    
     func setViewDataForRepoHeaderInfoView()
     {
        self.repoHeaderInfoView?.headImageView.sd_setImage(with: URL.init(string: self.repoInfoModel?.owner.avatar_url ?? ""), placeholderImage: UIImage.init(named: "default_avatar"));
        self.repoHeaderInfoView?.repoNameLabel.text = self.repoInfoModel?.full_name
        self.repoHeaderInfoView?.descLabel.text = self.repoInfoModel?.desc_Repo
        self.repoHeaderInfoView?.issuesNumLabel.text = "\(self.repoInfoModel?.open_issues_count ?? 0)"
        self.repoHeaderInfoView?.watchersNumLabel.text = "\(self.repoInfoModel?.subscribers_count ?? 0)"
        self.repoHeaderInfoView?.starsNumLabel.text = "\(self.repoInfoModel?.stargazers_count ?? 0)"
        self.repoHeaderInfoView?.forksNumLabel.text = "\(self.repoInfoModel?.forks_count ?? 0)"
             
        guard let date : NSDate = self.repoInfoModel?.updated_at as NSDate? else
        {
                 return
        }
             
        let timeStr = NSString.init(format: "%@%@", ZLLocalizedString(string: "update at", comment: "更新于"),date.dateLocalStrSinceCurrentTime())
        self.repoHeaderInfoView?.timeLabel.text = timeStr as String
     }
}


extension ZLRepoHeaderInfoViewModel : ZLRepoHeaderInfoViewDelegate
{
    func onZLRepoHeaderInfoViewEvent(event: ZLRepoHeaderInfoViewEvent)
    {
        
    }
}
