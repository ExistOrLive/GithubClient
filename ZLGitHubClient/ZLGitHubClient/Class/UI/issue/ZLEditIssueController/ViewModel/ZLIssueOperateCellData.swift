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
    
    init(operationType: ZLEditIssueOperationType, turnOn: Bool) {
        self.type = operationType
        self.turnOn = turnOn
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
    var attributedTitle: NSAttributedString {
        switch type {
        case .subscribe:
            if turnOn {
                return ZLLocalizedString(string: "Issue_Unsubscribe", comment: "")
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 16))
                    .foregroundColor(.label(withName: "CommonOperationColor"))
            } else {
                return ZLLocalizedString(string: "Issue_Subscribe", comment: "")
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 16))
                    .foregroundColor(.label(withName: "CommonOperationColor"))
            }
        case .lock:
            if turnOn {
                return ZLLocalizedString(string: "Issue_Unlock", comment: "")
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 16))
                    .foregroundColor(.label(withName: "CommonOperationColor"))
            } else {
                return ZLLocalizedString(string: "Issue_Lock", comment: "")
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 16))
                    .foregroundColor(.label(withName: "CommonOperationColor"))
            }
        case .closeOrOpen:
            if turnOn {
                return ZLLocalizedString(string: "Issue_Close", comment: "")
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 18))
                    .foregroundColor(.label(withName: "WarningOperationColor"))
            } else {
                return ZLLocalizedString(string: "Issue_Reopen", comment: "")
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 18))
                    .foregroundColor(.label(withName: "RecommandOperationColor"))
            }
        }
    }
    
    var opeationType: ZLEditIssueOperationType {
        type 
    }
}

