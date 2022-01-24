//
//  ZLIssueProjectCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/24.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit

class ZLIssueProjectCellData: ZLBaseViewModel {
    
    let data: IssueEditInfoQuery.Data.Repository.Issue.ProjectCard.Node
    
    init(data: IssueEditInfoQuery.Data.Repository.Issue.ProjectCard.Node) {
        self.data = data
        super.init()
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
        data.project.progress.todoPercentage
    }
    
    var doneValue: Double {
        data.project.progress.donePercentage
    }
    
    var inProgessValue: Double {
        data.project.progress.inProgressPercentage
    }
}
