//
//  ZLWorkboardTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/20.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZMMVVM

enum ZLWorkboardType: ZMBaseCellUniqueIDProtocol {
    var zm_ID: String {
        switch self {
        case .issues:
            return "issues"
        case .pullRequest:
            return "pullRequest"
        case .repos:
            return "repos"
        case .orgs:
            return "orgs"
        case .starRepos:
            return "starRepos"
        case .events:
            return "events"
        case .discussions:
            return "discussions"
        case .fixRepo(let repo):
            return "fixRepo_\(repo)"
        }
    }
    
    case issues
    case pullRequest
    case repos
    case orgs
    case starRepos
    case events
    case discussions
    case fixRepo(repo: String)
}

class ZLWorkboardTableViewCellData: ZMBaseTableViewCellViewModel{

    private let celltitle: String
    private let cellavatarURL: String
    private let type: ZLWorkboardType

    init(title: String = "", avatarURL: String = "", type: ZLWorkboardType) {
        self.type = type
        self.celltitle = title
        self.cellavatarURL = avatarURL
        super.init()
    }
    
    override var zm_cellID: any ZMBaseCellUniqueIDProtocol {
        self.type
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLWorkboardTableViewCell"
    }
    
    override dynamic var zm_cellHeight: CGFloat {
        60
    }
    

    var title: String {
        get {
            switch type {
            case .issues:
                return ZLLocalizedString(string: "issues", comment: "")
            case .pullRequest:
                return  ZLLocalizedString(string: "pull requests", comment: "")
            case .repos:
                return  ZLLocalizedString(string: "repositories", comment: "")
            case .orgs:
                return  ZLLocalizedString(string: "organizations", comment: "")
            case .starRepos:
                return ZLLocalizedString(string: "star", comment: "")
            case .events:
                return ZLLocalizedString(string: "Events", comment: "")
            case .discussions:
                return ZLLocalizedString(string: "Discussions", comment: "")
            case .fixRepo:
                return self.celltitle
            }

        }
    }

    var avatarURL: String {
        get {
            switch type {
            case .issues:
                return "issues_icon"
            case .pullRequest:
                return "pr_icon"
            case .repos:
                return "repo_icon"
            case .orgs:
                return "org_icon"
            case .starRepos:
                return "star_icon"
            case .events:
                return "event_icon"
            case .discussions:
                return "discussion_icon"
            case .fixRepo:
                return self.cellavatarURL
            }
        }
    }

    var isGithubItem: Bool {
        get {
            if case .fixRepo = type {
                return true
            }  else {
                return false
            }
        }
    }

    override func zm_onCellSingleTap() {
        switch self.type {
        case .issues:
            guard let vc = ZLUIRouter.getMyIssuesController() else { return }
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case .pullRequest:
            guard let vc = ZLUIRouter.getMyPullRequestsController() else {return}
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case .repos:
            guard let vc = ZLUIRouter.getMyReposController() else { return }
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case .orgs:
            guard let vc = ZLUIRouter.getOrgsViewController() else { return }
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case .starRepos:
            guard let vc = ZLUIRouter.getStarRepoViewController() else { return  }
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case .events:
            guard let vc = ZLUIRouter.getZLNewsViewController() else { return  }
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case .discussions:
            let vc = ZLMyDiscussionsController()
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case .fixRepo:
            guard let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: self.celltitle) else { return }
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        }

    }

}
