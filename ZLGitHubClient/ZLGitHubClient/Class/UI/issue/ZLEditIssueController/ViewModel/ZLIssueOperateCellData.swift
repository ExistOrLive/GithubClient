//
//  ZLIssueOperateCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/9.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit

class ZLIssueOperateCellData: ZLGithubItemTableViewCellData {
    
    private let type: ZLEditIssueOperationType
    private let turnOn: Bool
    private let _clickBlock: ((UIButton) -> Void)?
    
    init(operationType: ZLEditIssueOperationType,
         turnOn: Bool,
         clickBlock: ((UIButton) -> Void)?) {
        self.type = operationType
        self.turnOn = turnOn
        self._clickBlock = clickBlock
        super.init()
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLIssueOperateCell"
    }

    override func getCellHeight() -> CGFloat {
        UITableView.automaticDimension
    }
    
}


extension ZLIssueOperateCellData: ZLIssueOperateCellDataSource {
    
    var clickBlock: ((UIButton) -> Void)? {
        _clickBlock
    }
    
    var opeationType: ZLEditIssueOperationType {
        type 
    }
    
    var on: Bool {
        turnOn
    }
}

