//
//  ZLIssueHeaderTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/16.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLIssueHeaderTableViewCellData: ZLGithubItemTableViewCellData {
    
    let data : IssueInfoQuery.Data
    
    init(data : IssueInfoQuery.Data){
        self.data = data
        super.init()
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLIssueHeaderTableViewCell"
    }
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        super.bindModel(targetModel, andView: targetView)
        if let cell : ZLIssueHeaderTableViewCell = targetView as? ZLIssueHeaderTableViewCell {
            cell.fillWithData(data:self)
        }
    }
}

extension ZLIssueHeaderTableViewCellData : ZLIssueHeaderTableViewCellDelegate {
    
    func getIssueAuthorAvatarURL() -> String {
        return data.repository?.owner.avatarUrl ?? ""
    }
    
    func getIssueRepoFullName() -> String {
        return data.repository?.nameWithOwner ?? ""
    }
    
    func getIssueNumber() -> Int {
        return data.repository?.issue?.number ?? 0
    }
    
    func getIssueState() -> Bool {
        return data.repository?.issue?.closed ?? false
    }
    
    func getIssueTitle() -> String {
        return data.repository?.issue?.title ?? ""
    }
    
    
}
