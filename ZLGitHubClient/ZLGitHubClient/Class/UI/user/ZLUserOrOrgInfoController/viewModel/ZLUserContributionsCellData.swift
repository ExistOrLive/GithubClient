//
//  ZLUserContributionsCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/9.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities

class ZLUserContributionsCellData: ZLTableViewBaseCellData {

    // data
    private var _loginName: String

    init(loginName: String) {
        self._loginName = loginName
        super.init()
        cellReuseIdentifier =  "ZLUserContributionsCell"
    }
}

extension ZLUserContributionsCellData: ZLUserContributionsCellDelegate {

    var loginName: String {
        _loginName
    }

}
