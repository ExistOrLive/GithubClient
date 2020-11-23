//
//  ZLWorkboardTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/20.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit


class ZLWorkboardTableViewCellData: ZLBaseViewModel,ZLWorkboardTableViewCellDataProtocol {
    
    private let celltitle : String
    private let cellavatarURL : String
    private let type : ZLWorkboardType
    
    init(title:String = "", avatarURL :String = "", type : ZLWorkboardType){
        self.type = type
        switch type {
        case .issues:
            self.celltitle = ZLLocalizedString(string: "issues", comment: "")
            self.cellavatarURL = "issues_icon"
        case .pullRequest:
            self.celltitle = ZLLocalizedString(string: "pull requests", comment: "")
            self.cellavatarURL = "pr_icon"
        case .repos:
            self.celltitle = ZLLocalizedString(string: "repositories", comment: "")
            self.cellavatarURL = "repo_icon"
        case .orgs:
            self.celltitle = ZLLocalizedString(string: "organizations", comment: "")
            self.cellavatarURL = "org_icon"
        case .starRepos:
            self.celltitle = ZLLocalizedString(string: "star", comment: "")
            self.cellavatarURL = "star_icon"
        case .events:
            self.celltitle = ZLLocalizedString(string: "Events", comment: "")
            self.cellavatarURL = "event_icon"
        case .fixRepo:
            self.celltitle = title
            self.cellavatarURL = avatarURL
        }
            
        super.init()
    }
    
    var title: String{
        get{
            return self.celltitle
        }
    }
    
    var avatarURL: String{
        get{
            return self.cellavatarURL
        }
    }
    
    var isGithubItem: Bool{
        get{
            if self.type == .fixRepo{
                return true
            } else {
                return false
            }
        }
    }
    
    func onCellClicked() {
        switch self.type {
        case .issues:
            guard let vc = SYDCentralPivotUIAdapter.getMyIssuesController() else { return }
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case .pullRequest:
            break
        case .repos:
            break
        case .orgs:
            guard let vc = SYDCentralPivotUIAdapter.getOrgsViewController() else { return }
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case .starRepos:
            guard let vc = SYDCentralPivotUIAdapter.getZLStarRepoViewController() else { return  }
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case .events:
            guard let vc = SYDCentralPivotUIAdapter.getZLNewsViewController() else { return  }
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case .fixRepo:
            break
        }
        
    }
    
    
}
