//
//  ZLEventTableViewCellDataProvider.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/1.
//  Copyright © 2019 ZM. All rights reserved.
//

import Foundation

extension ZLEventTableViewCellData {
    static func getCellDataWithEventModel(eventModel: ZLGithubEventModel) -> ZLEventTableViewCellData {
        switch eventModel.type {
        case .pushEvent: do {
            return ZLPushEventTableViewCellData(eventModel: eventModel)
            }
        case .commitCommentEvent:do {
            return ZLCommitCommentEventTableViewCellData(eventModel: eventModel)
            }
        case .createEvent:do {
            return ZLCreateEventTableViewCellData(eventModel: eventModel)
            }
        case .deleteEvent:do {
            return ZLDeleteEventTableViewCellData(eventModel: eventModel)
            }
        case .forkEvent:do {
            return ZLForkEventTableViewCellData(eventModel: eventModel)
            }
        case .gollumEvent:do {
            return ZLGollumEventTableViewCellData(eventModel: eventModel)
            }
        case .issuesEvent:do {
            return ZLIssueEventTableViewCellData(eventModel: eventModel)
            }
        case .issueCommentEvent:do {
            return ZLIssueCommentEventTableViewCellData(eventModel: eventModel)
            }
        case .publicEvent:do {
            return ZLPullRequestEventTableViewCellData(eventModel: eventModel)
            }
        case .pullRequestEvent:do {
            return ZLPullRequestEventTableViewCellData(eventModel: eventModel)
            }
        case .pullRequestReviewCommentEvent:do {
             return ZLPullRequestReviewCommentEventTableViewCellData(eventModel: eventModel)
            }
        case .memberEvent:do {
            return ZLMemberEventTableViewCellData(eventModel: eventModel)
            }
        case .watchEvent:do {
            return ZLWatchEventTableViewCellData(eventModel: eventModel)
            }
        case .releaseEvent:do {
            return ZLReleaseEventTableViewCellData(eventModel: eventModel)
            }
        default : do {
                return ZLEventTableViewCellData(eventModel: eventModel)
            }
        }
    }
}
