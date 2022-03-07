//
//  ZLIssueMileStoneCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/24.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit

class ZLIssueMileStoneCellData: ZLGithubItemTableViewCellData {
    
    let data: IssueEditInfoQuery.Data.Repository.Issue.Milestone
    
    init(data: IssueEditInfoQuery.Data.Repository.Issue.Milestone) {
        self.data = data
        super.init()
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLIssueMilestoneCell"
    }

    override func getCellHeight() -> CGFloat {
        UITableView.automaticDimension
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
