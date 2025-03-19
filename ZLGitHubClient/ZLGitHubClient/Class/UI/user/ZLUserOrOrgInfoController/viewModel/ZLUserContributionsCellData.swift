//
//  ZLUserContributionsCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/9.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZMMVVM

class ZLUserContributionsCellData: ZMBaseTableViewCellViewModel {

    // data
    private var _loginName: String

    init(loginName: String) {
        self._loginName = loginName
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        "ZLUserContributionsCell"
    }
}

extension ZLUserContributionsCellData: ZLUserContributionsCellDelegate {

    var loginName: String {
        _loginName
    }

}
