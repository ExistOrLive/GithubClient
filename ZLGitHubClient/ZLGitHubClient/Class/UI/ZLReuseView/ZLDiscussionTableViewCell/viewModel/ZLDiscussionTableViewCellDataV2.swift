//
//  ZLDiscussionTableViewCellDataV2.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/4/12.
//  Copyright © 2025 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService
import ZMMVVM

class ZLDiscussionTableViewCellDataV2: ZMBaseTableViewCellViewModel {
    
    typealias DiscussionData = RepoDiscussionsQuery.Data.Repository.Discussion.Node
    
    let data: DiscussionData
    
    init(data: DiscussionData) {
        self.data = data
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLDiscussionTableViewCell"
    }
    
    override func zm_onCellSingleTap() {
        let discussionInfo = ZLDiscussionInfoController()
        discussionInfo.login = data.repository.owner.login
        discussionInfo.repoName = data.repository.name
        discussionInfo.number = data.number
        zm_viewController?.navigationController?.pushViewController(discussionInfo, animated: true)
    }
}

extension ZLDiscussionTableViewCellDataV2: ZLDiscussionTableViewCellDataSourceAndDelegate {
    
    
    
    var repositoryFullName: String {
        data.repository.nameWithOwner
    }
    
    var title: String {
        data.title
    }
        
    var updateOrCreateTime: String {
        if !data.updatedAt.isEmpty  {
            let timeStr = NSDate.getLocalStrSinceCurrentTime(withGithubTime: data.updatedAt)
            return "\(ZLLocalizedString(string: "update at", comment: "更新于")) \(timeStr)"
        } else if  !data.createdAt.isEmpty {
            let timeStr = NSDate.getLocalStrSinceCurrentTime(withGithubTime: data.createdAt)
            return "\(ZLLocalizedString(string: "created at", comment: "创建于")) \(timeStr)"
        } else {
            return ""
        }
    }
    
    var upvoteNumber: Int {
        data.upvoteCount
    }
    
    var commentNumber: Int {
        data.comments.totalCount
    }
    
    func onClickRepoFullName() {
        if let url = URL(string: self.data.url) {
            if url.pathComponents.count >= 5 {
                if let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: "\(url.pathComponents[1])/\(url.pathComponents[2])") {
                    zm_viewController?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func hasLongPressAction() -> Bool {
        if let _ = URL(string: data.url) {
            return true
        } else {
            return false
        }
    }

    func longPressAction(view: UIView) {
        guard let vc = zm_viewController,
              let url = URL(string: self.data.url) else { return }
        view.showShareMenu(title: data.title, url: url, sourceViewController: vc)
    }
    
}
