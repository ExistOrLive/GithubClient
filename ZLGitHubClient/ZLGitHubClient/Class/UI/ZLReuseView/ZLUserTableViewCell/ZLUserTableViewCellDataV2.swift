//
//  ZLUserTableViewCellDataV2.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/22.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension
import ZLGitRemoteService

class ZLUserTableViewCellDataV2: ZLTableViewBaseCellData {
    
    private let model: ZLGithubUserModel

    init(model: ZLGithubUserModel) {
        self.model = model
        super.init()
    }
    
    override var cellReuseIdentifier: String {
        "ZLUserTableViewCell"
    }
        
    override func onCellSingleTap() {
        if let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName: model.loginName ?? "") {
            userInfoVC.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
        }
    }
}

extension ZLUserTableViewCellDataV2: ZLUserTableViewCellDelegate {
    
    func getName() -> String? {
        return model.name
    }

    func getLoginName() -> String? {
        return model.loginName
    }

    func getAvatarUrl() -> String? {
        return model.avatar_url
    }

    func getCompany() -> String? {
        return model.company
    }

    func getLocation() -> String? {
        return model.location
    }

    func desc() -> String? {
        return model.bio
    }

    func hasLongPressAction() -> Bool {
        true
    }

    func longPressAction(view: UIView) {
        guard let sourceViewController = viewController,
              let title = model.loginName,
              let url = URL(string: "https://github.com/\(title.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")") else {
                  return
              }

        view.showShareMenu(title: url.absoluteString, url: url, sourceViewController: sourceViewController)
    }
    
}
