//
//  ZLReleaseInfoHeaderCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/11.
//  Copyright © 2025 ZM. All rights reserved.
//


import UIKit
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService
import ZMMVVM

class ZLReleaseInfoHeaderCellData: ZMBaseTableViewCellViewModel {
    
    typealias ReleaseData = RepoReleaseInfoQuery.Data.Repository.Release
    
    var data: ReleaseData? {
        (zm_superViewModel as? ZLReleaseInfoViewModel)?.data
    }
    

    override var zm_cellReuseIdentifier: String {
        return "ZLReleaseInfoHeaderCell"
    }
}

extension ZLReleaseInfoHeaderCellData: ZLReleaseInfoHeaderCellDataSourceAndDelegate {
    
    var repoOwnerAvatarString: String {
        data?.repository.owner.avatarUrl ?? ""
    }
    
    var repoOwnerLogin: String {
        data?.repository.owner.login ?? ""
    }
    
    var repoFullName: String {
        data?.repository.nameWithOwner ?? ""
    }
    
    var repoName: String {
        data?.repository.name ?? ""
    }
    
    var commitSha: String {
        String(data?.tagCommit?.oid.prefix(7) ?? "")
    }
    
    func onRepoOwnerAvatarAction() {
        if let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName: repoOwnerLogin) {
            userInfoVC.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
        }
    }
    
    func onRepoFullNameAction() {
        if let userInfoVC = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
            userInfoVC.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
        }
    }
    
    func onCommitAction() {
        if let commitInfoVC = ZLUIRouter.getCommitInfoViewController(login: repoOwnerLogin, repoName: repoName, ref: data?.tagCommit?.oid ?? "") {
            commitInfoVC.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(commitInfoVC, animated: true)
        }
    }
    
    
    var authorLogin: String {
        data?.author?.login ?? ""
    }
    
    var authorAvatarString: String {
        data?.author?.avatarUrl ?? ""
    }
    
    var tagName: String {
        data?.tagName ?? ""
    }
    
    func onAuthorAvatarAction() {
        if let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName: authorLogin) {
            userInfoVC.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
        }
    }
    
    
    var isLatest: Bool {
        data?.isLatest ?? false
    }
    
    var isDraft: Bool {
        data?.isDraft ?? false
    }
    
    var isPre: Bool {
        data?.isPrerelease ?? false
    }
    
    

    var title: String {
        data?.name ?? ""
    }
    
    var time: String {
        let timeStr = NSDate.getLocalStrSinceCurrentTime(withGithubTime: data?.updatedAt ?? "")
        return timeStr
    }
}
