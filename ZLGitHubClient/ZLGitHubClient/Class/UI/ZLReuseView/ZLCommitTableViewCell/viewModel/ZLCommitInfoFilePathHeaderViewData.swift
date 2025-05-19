
//
//  ZLCommitInfoFilePathHeaderViewData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/19.
//  Copyright © 2025 ZM. All rights reserved.
//

import ZMMVVM

class ZLCommitInfoFilePathHeaderViewData: ZMBaseTableViewReuseViewModel {
    
    let filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init()
    }

    override var zm_viewReuseIdentifier: String {
        return "ZLCommitInfoFilePathHeaderView"
    }
    
    override var zm_viewHeight: CGFloat {
        UITableView.automaticDimension
    }
}

