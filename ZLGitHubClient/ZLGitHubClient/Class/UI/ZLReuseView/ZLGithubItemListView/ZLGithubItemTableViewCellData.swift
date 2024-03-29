//
//  ZLGithubItemTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import Foundation
import UIKit
import ZLBaseUI
import ZLGitRemoteService

@objc protocol ZLGithubItemTableViewCellDataProtocol: NSObjectProtocol {
    func getCellReuseIdentifier() -> String

    func getCellHeight() -> CGFloat

    func onCellSingleTap()

    func getCellSwipeActions() -> UISwipeActionsConfiguration?
}

class ZLGithubItemTableViewCellData: ZLBaseViewModel, ZLGithubItemTableViewCellDataProtocol {
    func getCellReuseIdentifier() -> String {
        return "UITableViewCell"
    }

    func getCellHeight() -> CGFloat {
        return 0
    }

    func onCellSingleTap() {

    }

    func getCellSwipeActions() -> UISwipeActionsConfiguration? {
        return nil
    }

    func clearCache() {

    }

}

extension ZLGithubItemTableViewCellData {

    class func getCellDataWithData(data: Any?) -> ZLGithubItemTableViewCellData? {

        if data == nil {
            return nil
        } else if let data = data as? ZLGithubRepositoryModel {
            return ZLRepositoryTableViewCellData.init(data: data)
        } else if let data = data as? ZLGithubUserModel {
            return ZLUserTableViewCellData.init(userModel: data)
        } else if let data = data as? ZLGithubPullRequestModel {
            return ZLPullRequestTableViewCellData.init(eventModel: data)
        } else if let data = data as? ZLGithubEventModel {
            return ZLEventTableViewCellData.getCellDataWithEventModel(eventModel: data)
        } else if let data = data as? ZLGithubGistModel {
            return ZLGistTableViewCellData.init(data: data)
        } else if let data = data as? ZLGithubCommitModel {
            return ZLCommitTableViewCellData.init(commitModel: data)
        } else if let data = data as? ZLGithubIssueModel {
            return ZLIssueTableViewCellData.init(issueModel: data)
        } else if let data = data as? ZLGithubNotificationModel {
            return ZLNotificationTableViewCellData.init(data: data)
        } else if let data = data as? ZLGithubRepoWorkflowModel {
            return ZLWorkflowTableViewCellData.init(data: data)
        } else if let data = data as? ZLGithubRepoWorkflowRunModel {
            return ZLWorkflowRunTableViewCellData.init(data: data)
        } else {
            return nil
        }
    }

}
