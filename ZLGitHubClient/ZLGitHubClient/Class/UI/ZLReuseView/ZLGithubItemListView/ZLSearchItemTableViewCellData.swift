//
//  ZLSearchItemTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/4/13.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLSearchItemTableViewCellData: ZLGithubItemTableViewCellData {
    
    typealias Data = SearchItemQuery.Data.Search.Node
    
    private var data:Data?
    private var labels : [(String,String)]?
    
    init(data : Data){
        self.data = data
        super.init()
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if let cell = targetView as? ZLUserTableViewCell {
            cell.fillWithData(data: self)
        }
        
        if let cell = targetView as? ZLRepositoryTableViewCell {
            cell.fillWithData(data: self)
        }
        
        if let cell = targetView as? ZLPullRequestTableViewCell {
            cell.fillWithData(data: self)
        }
        
        if let cell = targetView as? ZLIssueTableViewCell {
            cell.fillWithData(cellData: self)
        }
    }
    
    override func getCellReuseIdentifier() -> String {
        if data?.asUser != nil ||
            data?.asOrganization != nil {
            return "ZLUserTableViewCell"
        }
        if data?.asRepository != nil {
            return "ZLRepositoryTableViewCell"
        }
        if data?.asIssue != nil {
            return "ZLIssueTableViewCell"
        }
        if data?.asPullRequest != nil {
            return "ZLPullRequestTableViewCell"
        }
        
        return "UITableViewCell"
        
    }
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func onCellSingleTap() {
        
        if let login = data?.asUser?.login,let vc = ZLUIRouter.getUserInfoViewController(loginName: login) {
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        if let login = data?.asOrganization?.login,let vc = ZLUIRouter.getUserInfoViewController(loginName: login) {
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        if let fullName = data?.asRepository?.nameWithOwner,let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: fullName){
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        if let issue = data?.asIssue{
            if let vc = ZLUIRouter.getVC(key: ZLUIRouter.IssueInfoController, params: ["login":issue.repository.owner.login,
                                                                                    "repoName":issue.repository.name,
                                                                                    "number":issue.number]){
                vc.hidesBottomBarWhenPushed = true
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
           
            return
        }
        
        if let pr = data?.asPullRequest{
            if let vc = ZLUIRouter.getVC(key: ZLUIRouter.PRInfoController, params:  ["login":pr.repository.owner.login,
                                                                                  "repoName":pr.repository.name,
                                                                                  "number":pr.number]) {
                vc.hidesBottomBarWhenPushed = true
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
           
            return
        }
        
    }
    
    override func getCellSwipeActions() -> UISwipeActionsConfiguration?{
        return nil
    }
    
    override func clearCache(){
        
    }
    

}

extension ZLSearchItemTableViewCellData: ZLUserTableViewCellDelegate {
    
    func getName() -> String? {
        var name: String? = nil
        if let userName = data?.asUser?.userName{
            name = userName
        } else if let orgName = data?.asOrganization?.orgName{
            name = orgName
        }
        return name
    }
    
    func getLoginName() -> String? {
        var login: String? = nil
        if let userLogin = data?.asUser?.login{
            login = userLogin
        } else if let orgLogin = data?.asOrganization?.login{
            login = orgLogin
        }
        return login
    }
    
    func getAvatarUrl() -> String? {
        var avatarUrl: String? = nil
        if let userAvatarUrl = data?.asUser?.avatarUrl{
            avatarUrl = userAvatarUrl
        } else if let orgAvatarUrl = data?.asOrganization?.avatarUrl{
            avatarUrl = orgAvatarUrl
        }
        return avatarUrl
    }
    
    func getCompany() -> String? {
        return nil
    }
    
    func getLocation() -> String? {
        return nil
    }
    
    func desc() -> String? {
        var desc: String? = nil
        if let userDesc = data?.asUser?.bio{
            desc = userDesc
        } else if let orgDesc = data?.asOrganization?.description {
            desc = orgDesc
        }
        return desc
    }
    
    
    
}

extension ZLSearchItemTableViewCellData: ZLRepositoryTableViewCellDelegate {
    
    func onRepoAvaterClicked() {
        if let login = data?.asRepository?.owner.login {
            if let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName:login){
                userInfoVC.hidesBottomBarWhenPushed = true
                self.viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
            }
        }
    }
    
    func getOwnerAvatarURL() -> String?{
        return data?.asRepository?.owner.avatarUrl
    }
    
    func getRepoFullName() -> String?{
        data?.asRepository?.nameWithOwner
    }
    
    func getRepoName() -> String?
    {
        data?.asRepository?.repoName
    }
    
    func getOwnerName() -> String?{
        data?.asRepository?.owner.login
    }
    
    func getRepoMainLanguage() -> String?{
        data?.asRepository?.primaryLanguage?.name
    }
    
    func getRepoDesc() -> String?{
        data?.asRepository?.description
    }
    
    func isPriva() -> Bool{
        data?.asRepository?.isPrivate ?? false
    }
    
    func starNum() -> Int{
        data?.asRepository?.stargazerCount ?? 0
    }
    
    func forkNum() -> Int{
        data?.asRepository?.forkCount ?? 0
    }
    
}

extension ZLSearchItemTableViewCellData: ZLIssueTableViewCellDelegate {

    func getIssueRepoFullName() -> String?{
        data?.asIssue?.repository.nameWithOwner
    }
    
    func getIssueTitleStr() -> String?{
        data?.asIssue?.title
    }
    
    func isIssueClosed() -> Bool{
        data?.asIssue?.issueState == IssueState.closed
    }
    
    func getIssueAssistStr() -> String? {
        
        if self.isIssueClosed() {
            return "#\(data?.asIssue?.number ?? 0) \(data?.asIssue?.author?.login ?? "") \(ZLLocalizedString(string: "closed at", comment: "")) \(NSDate.getLocalStrSinceCurrentTime(withGithubTime: data?.asIssue?.closedAt ?? ""))"
        } else {
            
             return "#\(data?.asIssue?.number ?? 0) \(data?.asIssue?.author?.login ?? "")  \(ZLLocalizedString(string: "opened at", comment: "")) \(NSDate.getLocalStrSinceCurrentTime(withGithubTime: data?.asIssue?.createdAt ?? ""))"
        }
        
    }
    
    func getIssueLabels() -> [(String,String)] {
        
        if self.labels == nil {
            if let nodes = data?.asIssue?.labels?.nodes {
                self.labels = []
                for label in nodes {
                    self.labels?.append((label?.name ?? "",label?.color ?? ""))
                }
            }
        }
        return self.labels ?? []
    }

    func onClickIssueRepoFullName() {
        
        if let fullName = data?.asIssue?.repository.nameWithOwner, let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: fullName) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

extension ZLSearchItemTableViewCellData: ZLPullRequestTableViewCellDelegate {
    
    func onClickPullRequestRepoFullName() {
        if let fullName = data?.asPullRequest?.repository.nameWithOwner,let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: fullName) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getPullRequestRepoFullName() -> String? {
        return data?.asPullRequest?.repository.nameWithOwner
    }
    
    func getPullRequestTitle() -> String?{
        data?.asPullRequest?.title
    }
    
    func getPullRequestAssistInfo() -> String?
    {
        guard let data = data?.asPullRequest else {
            return nil
        }
        
        if data.prState == .open
        {
            let assitInfo = "#\(data.number) \(data.author?.login ?? "") \(ZLLocalizedString(string: "created at", comment: "创建于")) \(NSDate.getLocalStrSinceCurrentTime(withGithubTime:data.createdAt))"
            return assitInfo
        }
        else
        {
            if let mergedAt = data.mergedAt{
                let assitInfo = "#\(data.number) \(data.author?.login ?? "") \(ZLLocalizedString(string: "merged at", comment: "合并于")) \(NSDate.getLocalStrSinceCurrentTime(withGithubTime:mergedAt))"
                return assitInfo
            }
            
            if let closedAt = data.closedAt {
                let assitInfo = "#\(data.number) \(data.author?.login ?? "") \(ZLLocalizedString(string: "closed at", comment: "关闭于")) \(NSDate.getLocalStrSinceCurrentTime(withGithubTime:closedAt))"
                return assitInfo
            }
          
            return ""
        }
    }
    
    func getPullRequestState() -> ZLGithubPullRequestState {
        switch(data?.asPullRequest?.prState){
        case .closed:
            return .closed
        case .merged:
            return .merged
        case .open:
            return .open
        default:
            return .closed
        }
    }
    
    func isPullRequestMerged() -> Bool {
        return data?.asPullRequest?.mergedAt != nil
    }
    
}

