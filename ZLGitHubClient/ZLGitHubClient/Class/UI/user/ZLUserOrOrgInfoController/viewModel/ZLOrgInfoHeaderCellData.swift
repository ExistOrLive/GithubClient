//
//  ZLOrgInfoHeaderCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/12.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService

class ZLOrgInfoHeaderCellData: ZLGithubItemTableViewCellData {

    private var data: ZLGithubOrgModel

    init(data: ZLGithubOrgModel) {
        self.data = data
        super.init()
    }

    override func getCellReuseIdentifier() -> String {
        "ZLOrgInfoHeaderCell"
    }

    override func getCellHeight() -> CGFloat {
        UITableView.automaticDimension
    }

}

extension ZLOrgInfoHeaderCellData: ZLOrgInfoHeaderCellDataSourceAndDelegate {
    var name: String {
        return "\(data.name ?? "")(\(data.loginName ?? ""))"
    }

    var time: String {
        let createdAtStr = ZLLocalizedString(string: "created at", comment: "创建于")
        return "\(createdAtStr) \((data.created_at as NSDate?)?.dateStrForYYYYMMdd() ?? "")"
    }

    var desc: String {
        data.bio ?? ""
    }

    var avatarUrl: String {
        data.avatar_url ?? ""
    }
}
