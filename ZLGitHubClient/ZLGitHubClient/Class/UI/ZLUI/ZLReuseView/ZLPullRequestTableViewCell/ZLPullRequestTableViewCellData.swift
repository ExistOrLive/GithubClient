//
//  ZLPullRequestTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLPullRequestTableViewCellData: ZLGithubItemTableViewCellData {

    let pullRequestModel : ZLGithubPullRequestModel
    
    init(eventModel : ZLGithubPullRequestModel)
    {
        self.pullRequestModel = eventModel
        super.init()
    }
    
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let cell : ZLPullRequestTableViewCell = targetView as? ZLPullRequestTableViewCell else {
            return
        }
        cell.fillWithData(data: self)
        cell.delegate = self
    }
    
    override func getCellHeight() -> CGFloat
    {
        return 100.0
    }
    
    override func getCellReuseIdentifier() -> String
    {
        return "ZLPullRequestTableViewCell"
    }
}

extension ZLPullRequestTableViewCellData
{
    func getTitle() -> String?
    {
        return self.pullRequestModel.title
    }
    
    func getAssistInfo() -> String?
    {
        if self.pullRequestModel.state == "open"
        {
            let assitInfo = "#\(self.pullRequestModel.number) \(self.pullRequestModel.user.loginName) \(ZLLocalizedString(string: "created at", comment: "创建于")) \((self.pullRequestModel.created_at as NSDate).dateLocalStrSinceCurrentTime())"
            return assitInfo
        }
        else 
        {
            var date : Date? = nil
            
            if self.pullRequestModel.merged_at != nil
            {
                date = self.pullRequestModel.merged_at
            }
            else if self.pullRequestModel.closed_at != nil
            {
                date = self.pullRequestModel.closed_at
            }
            else if self.pullRequestModel.updated_at != nil
            {
                date = self.pullRequestModel.updated_at
            }
            
            if date != nil
            {
                let assitInfo = "#\(self.pullRequestModel.number) \(self.pullRequestModel.user.loginName) \(ZLLocalizedString(string: "closed at", comment: "关闭于")) \((date! as NSDate).dateLocalStrSinceCurrentTime())"
                           return assitInfo
            }
            else
            {
                return ""
            }
            
          
        }
    }
    
   
    
    
    
}


extension ZLPullRequestTableViewCellData : ZLPullRequestTableViewCellDelegate
{
    func onCellClicked() {
        let vc = ZLWebContentController.init()
        vc.requestURL = URL.init(string: self.pullRequestModel.html_url)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

