//
//  ZLSimpleUserTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/24.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZMMVVM

class ZLSimpleUserTableViewCellData: ZMBaseTableViewCellViewModel {
    
    var _loginName: String
    var _avatarUrl: String
    
    init(loginName: String, avatarUrl: String) {
        _loginName = loginName
        _avatarUrl = avatarUrl
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        "ZLSimpleUserTableViewCell"
    }
}

extension ZLSimpleUserTableViewCellData: ZLSimpleUserTableViewCellDataSource {
    var avatarUrl: String {
        _avatarUrl
    }
    
    var loginName: String {
        _loginName
    }
}
