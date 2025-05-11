//
//  ZLReleaseTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/10.
//  Copyright © 2025 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService
import ZMMVVM

class ZLReleaseTableViewCellData: ZMBaseTableViewCellViewModel {
    
    typealias ReleaseData = RepoReleasesQuery.Data.Repository.Release.Node
    
    let data: ReleaseData
    
    init(data: ReleaseData) {
        self.data = data
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLReleaseTableViewCell"
    }
    
    override func zm_onCellSingleTap() {
        
        let vc = ZLReleaseInfoController()
        vc.login = data.repository.owner.login
        vc.repoName = data.repository.name
        vc.tagName = data.tagName
        
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ZLReleaseTableViewCellData: ZLReleaseTableViewCellDataSourceAndDelegate {
    
    var authorLogin: String {
        data.author?.login ?? ""
    }
    
    var authorAvatarString: String {
        data.author?.avatarUrl ?? ""
    }
    
    var tagName: String {
        data.tagName 
    }
    
    func onAuthorAvatarAction() {
        if let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName: authorLogin) {
            userInfoVC.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
        }
    }
    
    
    var isLatest: Bool {
        data.isLatest
    }
    
    var isDraft: Bool {
        data.isDraft
    }
    
    var isPre: Bool {
        data.isPrerelease
    }
    
    

    var title: String {
        data.name ?? ""
    }
    
    var time: String {
        let timeStr = NSDate.getLocalStrSinceCurrentTime(withGithubTime: data.updatedAt)
        return timeStr
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
        view.showShareMenu(title: data.name ?? "", url: url, sourceViewController: vc)
    }
    
}
