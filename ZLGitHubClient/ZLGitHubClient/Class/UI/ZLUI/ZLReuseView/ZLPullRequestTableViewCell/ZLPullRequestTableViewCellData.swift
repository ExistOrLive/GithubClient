//
//  ZLPullRequestTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLPullRequestTableViewCellData: ZLBaseViewModel {

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
    
}

extension ZLPullRequestTableViewCellData
{
    func getTitle() -> String
    {
        return self.pullRequestModel.title
    }
    
    func getAssistInfo() -> String
    {
        if self.pullRequestModel.state == "open"
        {
            let assitInfo = "#\(self.pullRequestModel.number) \(self.pullRequestModel.user.loginName) \(ZLLocalizedString(string: "created at", comment: "创建于")) \((self.pullRequestModel.created_at as NSDate).dateLocalStrSinceCurrentTime())"
            return assitInfo
        }
        else 
        {
           let assitInfo = "#\(self.pullRequestModel.number) \(self.pullRequestModel.user.loginName) \(ZLLocalizedString(string: "closed at", comment: "关闭于")) \((self.pullRequestModel.closed_at as NSDate).dateLocalStrSinceCurrentTime())"
            return assitInfo
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

