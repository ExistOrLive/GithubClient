//
//  ZLOrgInfoHeaderCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/12.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZLUIUtilities
import ZMMVVM

class ZLOrgInfoHeaderCellData: ZMBaseTableViewCellViewModel {

    private let stateModel: ZLUserInfoStateModel

    init(stateModel: ZLUserInfoStateModel) {
        self.stateModel = stateModel
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLOrgInfoHeaderCell"
    }
    
    var orgModel: ZLGithubOrgModel? {
        return stateModel.orgModel
    }
}

extension ZLOrgInfoHeaderCellData: ZLOrgInfoHeaderCellDataSourceAndDelegate {
    var name: String {
        return "\(orgModel?.name ?? "")(\(orgModel?.loginName ?? ""))"
    }
    
    var loginName: String {
        return orgModel?.loginName ?? ""
    }

    var time: String {
        let createdAtStr = ZLLocalizedString(string: "created at", comment: "创建于")
        return "\(createdAtStr) \((orgModel?.created_at as NSDate?)?.dateStrForYYYYMMdd() ?? "")"
    }

    var desc: String {
        orgModel?.bio ?? ""
    }

    var avatarUrl: String {
        orgModel?.avatar_url ?? ""
    }
}
