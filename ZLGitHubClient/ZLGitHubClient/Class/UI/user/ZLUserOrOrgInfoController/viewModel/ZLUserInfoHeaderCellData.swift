//
//  ZLUserInfoHeaderCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/6.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService
import ZLUtilities
import ZMMVVM

class ZLUserInfoHeaderCellData: ZMBaseTableViewCellViewModel {

    let stateModel: ZLUserInfoStateModel

    init(stateModel: ZLUserInfoStateModel) {
        self.stateModel = stateModel
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLUserInfoHeaderCell"
    }
    
    
    var userModel: ZLGithubUserModel? {
        stateModel.userModel
    }
}

// MARK: - Action
extension ZLUserInfoHeaderCellData {

    func followUser() {
        ZLProgressHUD.show()
        stateModel.followUser { res, msg in
            ZLProgressHUD.dismiss()
            ZLToastView.showMessage(msg)
        }
    }

    func unfollowUser() {
        ZLProgressHUD.show()
        stateModel.unfollowUser { res, msg in
            ZLProgressHUD.dismiss()
            ZLToastView.showMessage(msg)
        }
    }

    func BlockUser() {
        ZLProgressHUD.show()
        stateModel.BlockUser { res, msg in
            ZLProgressHUD.dismiss()
            ZLToastView.showMessage(msg)
        }
    }

    func unBlockUser() {
        ZLProgressHUD.show()
        stateModel.unBlockUser { res, msg in
            ZLProgressHUD.dismiss()
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
        "\(userModel?.repositories ?? 0)"
    }

    var gistsNum: String {
        "\(userModel?.gists ?? 0)"
    }

    var followersNum: String {
        "\(userModel?.followers ?? 0)"
    }

    var followingNum: String {
        "\(userModel?.following ?? 0)"
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
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func onGistsNumButtonClicked() {
        if let login = userModel?.loginName,
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController,
                                     params: ["login": login,
                                              "type": ZLUserAdditionInfoType.gists.rawValue]) {
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func onFollowsNumButtonClicked() {
        if let login = userModel?.loginName,
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController,
                                     params: ["login": login,
                                              "type": ZLUserAdditionInfoType.followers.rawValue]) {
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func onFollowingNumButtonClicked() {
        if let login = userModel?.loginName,
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController,
                                     params: ["login": login,
                                              "type": ZLUserAdditionInfoType.following.rawValue]) {
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
