//
//  ZLProfileHeaderCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/10/7.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import ZLUIUtilities
import ZLGitRemoteService

class ZLProfileHeaderCellData: ZLTableViewBaseCellData {
    
    private var data: ZLGithubUserModel
    
    init(userModel: ZLGithubUserModel) {
        self.data = userModel
        super.init()
        self.cellReuseIdentifier = "ZLProfileHeaderCell"
    }
}

extension ZLProfileHeaderCellData: ZLProfileHeaderCellDataSourceAndDelegate {
      
    var loginName: String {
        return data.loginName ?? ""
    }
    
    var name: String {
        return "\(data.name ?? "")(\(data.loginName ?? ""))"
    }

    var createTime: String {
        let createdAtStr = ZLLocalizedString(string: "created at", comment: "创建于")
        return "\(createdAtStr) \((data.created_at as NSDate?)?.dateStrForYYYYMMdd() ?? "")"
    }

    var desc: String {
        data.bio ?? ""
    }

    var avatarUrl: String {
        data.avatar_url ?? ""
    }

    var reposNum: String {
        if data.repositories >= 1000 {
            return String(format: "%.1f", Double(data.repositories) / 1000.0) + "k"
        } else {
            return "\(data.repositories)"
        }
    }

    var gistsNum: String {
        if data.gists >= 1000 {
            return String(format: "%.1f", Double(data.gists) / 1000.0) + "k"
        } else {
            return "\(data.gists)"
        }
    }

    var followersNum: String {
        if data.followers >= 1000 {
            return String(format: "%.1f", Double(data.followers) / 1000.0) + "k"
        } else {
            return "\(data.followers)"
        }
    }

    var followingNum: String {
        if data.following >= 1000 {
            return String(format: "%.1f", Double(data.following) / 1000.0) + "k"
        } else {
            return "\(data.following)"
        }
    }


    func onReposNumButtonClicked() {
        if let login = data.loginName,
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController,
                                     params: ["login": login,
                                              "type": ZLUserAdditionInfoType.repositories.rawValue]) {
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func onGistsNumButtonClicked() {
        if let login = data.loginName,
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController,
                                     params: ["login": login,
                                              "type": ZLUserAdditionInfoType.gists.rawValue]) {
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func onFollowsNumButtonClicked() {
        if let login = data.loginName,
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController,
                                     params: ["login": login,
                                              "type": ZLUserAdditionInfoType.followers.rawValue]) {
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func onFollowingNumButtonClicked() {
        if let login = data.loginName,
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController,
                                     params: ["login": login,
                                              "type": ZLUserAdditionInfoType.following.rawValue]) {
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func onAvatarButtonClicked() {
        if let login = data.loginName,
           let vc = ZLUIRouter.getUserInfoViewController(loginName: login) {
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func onEditProfileButtonClicked() {
        let vc = ZLEditProfileController.init()
        vc.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
