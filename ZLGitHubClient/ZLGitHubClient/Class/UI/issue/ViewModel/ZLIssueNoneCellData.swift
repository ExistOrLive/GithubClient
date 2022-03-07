//
//  ZLIssueNoneCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/8.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit

class ZLIssueNoneCellData: ZLGithubItemTableViewCellData {
    private let infoText: String
    
    init(info: String) {
        infoText = info
        super.init()
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLIssueNoneCell"
    }

    override func getCellHeight() -> CGFloat {
        UITableView.automaticDimension
    }
    
}


extension ZLIssueNoneCellData: ZLIssueNoneCellDataSource {
    var info: String {
        infoText
    }
}

