//
//  ZLGithubItemTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import Foundation
import UIKit
import ZLBaseUI
import ZLGitRemoteService

@objc protocol ZLGithubItemTableViewCellDataProtocol: NSObjectProtocol {
    func getCellReuseIdentifier() -> String

    func getCellHeight() -> CGFloat

    func onCellSingleTap()

    func getCellSwipeActions() -> UISwipeActionsConfiguration?
}

class ZLGithubItemTableViewCellData: ZLBaseViewModel, ZLGithubItemTableViewCellDataProtocol {
    func getCellReuseIdentifier() -> String {
        return "UITableViewCell"
    }

    func getCellHeight() -> CGFloat {
        return 0
    }

    func onCellSingleTap() {

    }

    func getCellSwipeActions() -> UISwipeActionsConfiguration? {
        return nil
    }

    func clearCache() {

    }

}

