//
//  ZLUserInfoHeaderCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/6.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService
import ZLUtilities

class ZLUserInfoHeaderCellData: ZLTableViewBaseCellData {

    let stateModel: ZLUserInfoStateModel

    init(stateModel: ZLUserInfoStateModel) {
        self.stateModel = stateModel
        super.init()
        cellReuseIdentifier = "ZLUserInfoHeaderCell"
    }
    
    var userModel: ZLGithubUserModel? {
        stateModel.userModel
    }
}

// MARK: - Action
extension ZLUserInfoHeaderCellData {

    func followUser() {
        ZLProgressHUD.show()
        stateModel.followUser { [weak self] res, msg in
            ZLProgressHUD.dismiss()
            guard let self = self else { return }
            ZLToastView.showMessage(msg)
        }
    }

    func unfollowUser() {
        ZLProgressHUD.show()
        stateModel.unfollowUser { [weak self] res, msg in
            ZLProgressHUD.dismiss()
            guard let self = self else { return }
            ZLToastView.showMessage(msg)
        }
    }

    func BlockUser() {
        ZLProgressHUD.show()
        stateModel.BlockUser { [weak self] res, msg in
            ZLProgressHUD.dismiss()
            guard let self = self else { return }
            ZLToastView.showMessage(msg)
        }
    }

    func unBlockUser() {
        ZLProgressHUD.show()
        stateModel.unBlockUser { [weak self] res, msg in
            ZLProgressHUD.dismiss()
            guard let self = self else { return }
            ZLToastView.showMessage(msg)
        }
    }

}

// MARK: - ZLUserInfoHeaderCellDataSourceAndDelegate
extension ZLUserInfoHeaderCellData: ZLUserInfoHeaderCellDataSourceAndDelegate {

    var name: String {
        return "\(userModel?.name ?? "")(\(userModel?.loginName ?? ""))"
    }
    
    var loginName: String {
        return userModel?.loginName ?? ""
    }

    var time: String {
        let createdAtStr = ZLLocalizedString(string: "created at", comment: "创建于")
        return "\(createdAtStr) \((userModel?.created_at as NSDate?)?.dateStrForYYYYMMdd() ?? "")"
    }

    var desc: String {
        userModel?.bio ?? ""
    }

    var avatarUrl: String {
        userModel?.avatar_url ?? ""
    }

    var reposNum: String {
        if (userModel?.repositories ?? 0) >= 1000 {
            return String(format: "%.1f", Double(userModel?.repositories ?? 0) / 1000.0) + "k"
        } else {
            return "\(userModel?.repositories ?? 0)"
        }
    }

    var gistsNum: String {
        if (userModel?.gists ?? 0) >= 1000 {
            return String(format: "%.1f", Double(userModel?.gists ?? 0) / 1000.0) + "k"
        } else {
            return "\(userModel?.gists ?? 0)"
        }
    }

    var followersNum: String {
        if (userModel?.followers ?? 0) >= 1000 {
            return String(format: "%.1f", Double(userModel?.followers ?? 0) / 1000.0) + "k"
        } else {
            return "\(userModel?.followers ?? 0)"
        }
    }

    var followingNum: String {
        if (userModel?.following ?? 0) >= 1000 {
            return String(format: "%.1f", Double(userModel?.following ?? 0) / 1000.0) + "k"
        } else {
            return "\(userModel?.following ?? 0)"
        }
    }


    var blockStatus: Bool? {
        stateModel.blockStatus
    }
    var followStatus: Bool? {
        stateModel.followStatus
    }

    func onFollowButtonClicked() {
        guard let followStatus = stateModel.followStatus else { return }
        if followStatus {
            unfollowUser()
        } else {
            followUser()
        }
    }
    func onBlockButtonClicked() {
        guard let blockStatus = stateModel.blockStatus else { return }
        if blockStatus {
            unBlockUser()
        } else {
            BlockUser()
        }
    }

    func onReposNumButtonClicked() {
        if let login = userModel?.loginName,
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController,
                                     params: ["login": login,
                                              "type": ZLUserAdditionInfoType.repositories.rawValue]) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func onGistsNumButtonClicked() {
        if let login = userModel?.loginName,
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController,
                                     params: ["login": login,
                                              "type": ZLUserAdditionInfoType.gists.rawValue]) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func onFollowsNumButtonClicked() {
        if let login = userModel?.loginName,
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController,
                                     params: ["login": login,
                                              "type": ZLUserAdditionInfoType.followers.rawValue]) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func onFollowingNumButtonClicked() {
        if let login = userModel?.loginName,
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController,
                                     params: ["login": login,
                                              "type": ZLUserAdditionInfoType.following.rawValue]) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
