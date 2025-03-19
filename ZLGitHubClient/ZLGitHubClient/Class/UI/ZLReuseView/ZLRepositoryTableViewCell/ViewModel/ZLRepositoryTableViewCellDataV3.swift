//
//  ZLRepositoryTableViewCellDataV2 2.swift
//  ZLGitHubClient
//
//  Created by admin on 3/19/25.
//  Copyright © 2025 ZM. All rights reserved.
//


import UIKit
import ZLUIUtilities
import ZMMVVM
import ZLBaseExtension
import ZLGitRemoteService

class ZLRepositoryTableViewCellDataV3: ZMBaseTableViewCellViewModel {

    private let data: ZLGithubRepositoryModel
    
    init(data: ZLGithubRepositoryModel) {
        self.data = data
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        "ZLRepositoryTableViewCell"
    }

    override func zm_onCellSingleTap() {
        
        if  let fullName = data.full_name,
            !fullName.isEmpty,
            let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: fullName) {
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension ZLRepositoryTableViewCellDataV3: ZLRepositoryTableViewCellDelegate {
    func onRepoAvaterClicked() {

        if let login = data.owner?.loginName,
           let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName: login) {
            userInfoVC.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
        }
    }

    func getOwnerAvatarURL() -> String? {
        return self.data.owner?.avatar_url
    }

    func getRepoFullName() -> String? {
        return self.data.full_name
    }

    func getRepoName() -> String? {
        return self.data.name
    }

    func getOwnerName() -> String? {
        return self.data.owner?.loginName
    }

    func getRepoMainLanguage() -> String? {
        return self.data.language
    }

    func getRepoDesc() -> String? {
        return self.data.desc_Repo
    }

    func isPriva() -> Bool {
        return self.data.isPriva
    }

    func starNum() -> Int {
        return Int(self.data.stargazers_count)
    }

    func forkNum() -> Int {
        return Int(self.data.forks_count)
    }

    func hasLongPressAction() -> Bool {
        if let html_url = data.html_url,
           let _ = URL(string: html_url) {
            return true
        }
        if let _ = data.full_name {
            return true
        }
        return false
    }

    func longPressAction(view: UIView) {
        if let html_url = data.html_url,
           let url = URL(string: html_url),
           let vc = zm_viewController {
            view.showShareMenu(title: html_url, url: url, sourceViewController: vc)
        } else if let fullName = data.full_name,
           let url = URL(string: "https://github.com/\(fullName)"),
           let vc = zm_viewController {
            view.showShareMenu(title: url.absoluteString, url: url, sourceViewController: vc)
        }
    }

}
