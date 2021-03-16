//
//  ZLIssueBodyTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/17.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLIssueBodyTableViewCellData: ZLGithubItemTableViewCellData {

    typealias IssueData = IssueInfoQuery.Data.Repository.Issue
    
    let data : IssueData
    
    init(data : IssueData) {
        self.data = data
        super.init()
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        super.bindModel(targetModel, andView: targetView)
        if let cell : ZLIssueCommentTableViewCell = targetView as? ZLIssueCommentTableViewCell {
            cell.fillWithData(data:self)
        }
    }
    
    
    override func getCellReuseIdentifier() -> String {
        return "ZLIssueCommentTableViewCell";
    }
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension;
    }

}

extension ZLIssueBodyTableViewCellData : ZLIssueCommentTableViewCellDelegate {
    
    func getActorAvatarUrl() -> String {
        return data.author?.avatarUrl ?? ""
    }
    
    func getActorName() -> String {
        return data.author?.login ?? ""
    }
    
    func getTime() -> String {
        return  NSDate.getLocalStrSinceCurrentTime(withGithubTime: data.createdAt )
    }
    
    func getCommentHtml() -> String {
        return data.bodyHtml
    }
    
    func getCommentText() -> String {
        return data.bodyText
    }
    
    
}

