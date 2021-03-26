//
//  ZLIssueTableViewCellDataProvider.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/26.
//  Copyright © 2021 ZM. All rights reserved.
//

import Foundation

extension ZLIssueTableViewCellData {
    
    static func getCellDatasWithIssueModel(data:IssueInfoQuery.Data, firstPage:Bool) -> [ZLGithubItemTableViewCellData]{
        
        var cellDatas : [ZLGithubItemTableViewCellData] = []
       
        if firstPage {
            
            let cellData = ZLIssueHeaderTableViewCellData(data: data)
            cellDatas.append(cellData)
            
            if let issueData = data.repository?.issue {
                let cellData1 = ZLIssueBodyTableViewCellData(data: issueData)
                cellDatas.append(cellData1)
            }
            
        }
    
        if let timelinesArray = data.repository?.issue?.timelineItems.nodes {
            for tmptimeline in timelinesArray {
                if let timeline = tmptimeline {
                    if timeline.asIssueComment != nil {
                        let cellData = ZLIssueCommentTableViewCellData(data: timeline.asIssueComment!)
                        cellDatas.append(cellData)
                    } else if timeline.asSubscribedEvent != nil {
                        continue
                    } else if timeline.__typename == "MentionedEvent"{
                        continue
                    } else {
                        let cellData = ZLIssueTimelineTableViewCellData(data: timeline)
                        cellDatas.append(cellData)
                    }
                }
            }
        }
        
        return cellDatas
    }
    
}
