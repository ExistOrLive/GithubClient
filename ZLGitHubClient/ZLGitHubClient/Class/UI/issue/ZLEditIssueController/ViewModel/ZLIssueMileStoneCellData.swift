//
//  ZLIssueMileStoneCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/24.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZMMVVM

class ZLIssueMileStoneCellData: ZMBaseTableViewCellViewModel {
    
    let data: IssueEditInfoQuery.Data.Repository.Issue.Milestone
    
    init(data: IssueEditInfoQuery.Data.Repository.Issue.Milestone) {
        self.data = data
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLIssueMilestoneCell"
    }
}

extension ZLIssueMileStoneCellData: ZLIssueMilestoneCellDelegateAndDataSource {
    
    var title: String {
        data.title
    }
    
    var percent: Double {
        data.progressPercentage
    }
}
