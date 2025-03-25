//
//  ZLIssueNoneCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/8.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZMMVVM

class ZLIssueNoneCellData: ZMBaseTableViewCellViewModel {
    
    private let infoText: String
    
    init(info: String) {
        infoText = info
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLIssueNoneCell"
    }
}


extension ZLIssueNoneCellData: ZLIssueNoneCellDataSource {
    var info: String {
        infoText
    }
}

