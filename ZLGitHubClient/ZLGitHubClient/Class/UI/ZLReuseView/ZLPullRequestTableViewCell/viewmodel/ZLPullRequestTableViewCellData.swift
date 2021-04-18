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
    }
    
    override func getCellHeight() -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    override func getCellReuseIdentifier() -> String
    {
        return "ZLPullRequestTableViewCell"
    }
    
    override func onCellSingleTap() {
                
        if let url = URL(string: pullRequestModel.html_url) {
            if url.pathComponents.count >= 5 && url.pathComponents[3] == "pull" {
                ZLUIRouter.navigateVC(key: ZLUIRouter.PRInfoController,
                                      params: ["login":url.pathComponents[1],
                                               "repoName":url.pathComponents[2],
                                               "number":Int(url.pathComponents[4]) ?? 0])
            } else {
                let vc = ZLWebContentController.init()
                vc.requestURL = url
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension ZLPullRequestTableViewCellData : ZLPullRequestTableViewCellDelegate
{
    
    func getPullRequestRepoFullName() -> String?{
        if let url = URL(string: pullRequestModel.html_url) {
            if url.pathComponents.count >= 5 && url.pathComponents[3] == "pull" {
                return "\(url.pathComponents[1])/\(url.pathComponents[2])"
            }
        }
        return nil
    }
    
    func onClickPullRequestRepoFullName() {
        if let url = URL(string: pullRequestModel.html_url) {
            if url.pathComponents.count >= 5 && url.pathComponents[3] == "pull" {
                if let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: "\(url.pathComponents[1])/\(url.pathComponents[2])"){
                    self.viewController?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func getPullRequestTitle() -> String?
    {
        return self.pullRequestModel.title
    }
    
    func getPullRequestAssistInfo() -> String?
    {
        if self.pullRequestModel.state == .open
        {
            let assitInfo = "#\(self.pullRequestModel.number) \(self.pullRequestModel.user.loginName ?? "") \(ZLLocalizedString(string: "created at", comment: "创建于")) \((self.pullRequestModel.created_at as NSDate).dateLocalStrSinceCurrentTime())"
            return assitInfo
        }
        else 
        {
            if self.pullRequestModel.merged_at != nil{
                let assitInfo = "#\(self.pullRequestModel.number) \(self.pullRequestModel.user.loginName ?? "") \(ZLLocalizedString(string: "merged at", comment: "合并于")) \((self.pullRequestModel.merged_at! as NSDate).dateLocalStrSinceCurrentTime())"
                return assitInfo
            }
            
            var date : Date? = nil
            
            if self.pullRequestModel.closed_at != nil{
                date = self.pullRequestModel.closed_at
            }
            else if self.pullRequestModel.updated_at != nil{
                date = self.pullRequestModel.updated_at
            }
            
            if date != nil{
                let assitInfo = "#\(self.pullRequestModel.number) \(self.pullRequestModel.user.loginName ?? "") \(ZLLocalizedString(string: "closed at", comment: "关闭于")) \((date! as NSDate).dateLocalStrSinceCurrentTime())"
                           return assitInfo
            }
            else{
                return ""
            }
        }
    }
    
    func getPullRequestState() -> ZLGithubPullRequestState {
        return self.pullRequestModel.state
    }
    
    func isPullRequestMerged() -> Bool {
        return self.pullRequestModel.merged_at != nil
    }
}


