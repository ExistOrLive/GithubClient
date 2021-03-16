//
//  ZLIssueTimelineTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/16.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLIssueTimelineTableViewCellData: ZLGithubItemTableViewCellData {
    
    typealias IssueTimelineData = IssueInfoQuery.Data.Repository.Issue.TimelineItem.Node
    
    let data : IssueTimelineData
    
    init(data : IssueTimelineData) {
        self.data = data
        super.init()
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        super.bindModel(targetModel, andView: targetView)
        if let cell : ZLIssueTimelineTableViewCell = targetView as? ZLIssueTimelineTableViewCell {
            cell.fillWithData(data:self)
        }
    }
    
    
    override func getCellReuseIdentifier() -> String {
        return "ZLIssueTimelineTableViewCell";
    }
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension;
    }

}

extension ZLIssueTimelineTableViewCellData : ZLIssueTimelineTableViewCellDelegate {
    func getTimelineMessage() -> String {
        if let tmpdata = data.asClosedEvent {
            return "\(tmpdata.actor?.login ?? "") closed this issue"
        } else if let tmpdata = data.asLabeledEvent {
            return "\(tmpdata.actor?.login ?? "") added label \(tmpdata.label.name)"
        } else if let tmpdata = data.asReopenedEvent {
            return "\(tmpdata.actor?.login ?? "") reopened this issue"
        } else if let tmpdata = data.asAssignedEvent {
            var assignee : String? = nil
            if let bot = tmpdata.assignee?.asBot {
                assignee = bot.login
            } else if let user = tmpdata.assignee?.asUser {
                assignee = user.login
            } else if let mannequin = tmpdata.assignee?.asMannequin {
                assignee = mannequin.login
            } else if let org = tmpdata.assignee?.asOrganization {
                assignee = org.login
            }
            return "\(tmpdata.actor?.login ?? "") assigned \(assignee ?? "")"
        } else if let tmpdata = data.asSubscribedEvent {
            return "\(tmpdata.actor?.login ?? "") subscribed this issue"
        } else if let tmpdata = data.asUnlabeledEvent {
            return "\(tmpdata.actor?.login ?? "") removed label \(tmpdata.label.name)"
        } else if let tmpdata = data.asCommentDeletedEvent {
            return "\(tmpdata.actor?.login ?? "") deleted comment"
        } else if let tmpdata = data.asReferencedEvent {
            return "\(tmpdata.actor?.login ?? "") added a commit that referenced this issue \n \(tmpdata.commit?.message ?? "")"
        }
        return data.__typename
    }
}
