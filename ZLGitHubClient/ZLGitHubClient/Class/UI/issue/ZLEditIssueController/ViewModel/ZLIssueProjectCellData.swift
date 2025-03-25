//
//  ZLIssueProjectCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/24.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZMMVVM

class ZLIssueProjectCellData: ZMBaseTableViewCellViewModel {
    
    let data: IssueEditInfoQuery.Data.Repository.Issue.ProjectCard.Node
    
    init(data: IssueEditInfoQuery.Data.Repository.Issue.ProjectCard.Node) {
        self.data = data
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLIssueProjectCell"
    }
}

extension ZLIssueProjectCellData: ZLIssueProjectCellDataSourceAndDeledate {
    
    var projectTitle: String {
        data.project.name
    }
    
    var projectColumnTitle: String {
        data.column?.name ?? ""
    }
    
    var toDoValue: Double {
        if data.project.progress.enabled {
            return data.project.progress.todoPercentage
        } else {
            return 1.0
        }
    }
    
    var doneValue: Double {
        if data.project.progress.enabled {
            return data.project.progress.donePercentage
        } else {
            return 0.0
        }
    }
    
    var inProgessValue: Double {
        if data.project.progress.enabled {
            return data.project.progress.inProgressPercentage
        } else {
            return 0.0
        }
    }
}
