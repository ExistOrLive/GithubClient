//
//  ZLUserContributionsCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/9.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLUserContributionsCellData: ZLGithubItemTableViewCellData {
    
    // data
    private var _loginName: String
    
    
    init(loginName: String){
        self._loginName = loginName
        super.init()
    }
    
    override func update(_ targetModel: Any?) {
        guard let loginName = targetModel as? String else {
            return
        }
        self._loginName = loginName
    }
    
    override func getCellReuseIdentifier() -> String {
        "ZLUserContributionsCell"
    }
    
    override func getCellHeight() -> CGFloat {
        UITableView.automaticDimension
    }
}

extension ZLUserContributionsCellData: ZLUserContributionsCellDelegate {
    
    var loginName: String{
        _loginName
    }
    
}
