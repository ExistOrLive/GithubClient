//
//  ZLUserTableViewCellDataForViewerOrgs.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/22.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLGitRemoteService
import ZMMVVM

class ZLUserTableViewCellDataForViewerOrgs: ZMBaseTableViewCellViewModel {

    let data: ViewerOrgsQuery.Data.Viewer.Organization.Edge.Node

    init(data: ViewerOrgsQuery.Data.Viewer.Organization.Edge.Node) {
        self.data = data
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLUserTableViewCell"
    }

    override func zm_onCellSingleTap() {
        if let orgInfoVC = ZLUIRouter.getUserInfoViewController(loginName: data.login) {
            orgInfoVC.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(orgInfoVC, animated: true)
        }
    }
}

extension ZLUserTableViewCellDataForViewerOrgs: ZLUserTableViewCellDelegate {
    func getName() -> String? {
        return data.name
    }

    func getLoginName() -> String? {
        return data.login
    }

    func getAvatarUrl() -> String? {
        return data.avatarUrl
    }

    func getCompany() -> String? {
        return nil
    }

    func getLocation() -> String? {
        return data.location
    }

    func desc() -> String? {
        return data.description
    }

    func longPressAction(view: UIView) {
        guard let sourceViewController = zm_viewController,
              let url = URL(string: "https://github.com/\(data.login.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")") else {
                  return
              }
        view.showShareMenu(title: url.absoluteString, url: url, sourceViewController: sourceViewController)
    }

    func hasLongPressAction() -> Bool {
        true
    }

}
