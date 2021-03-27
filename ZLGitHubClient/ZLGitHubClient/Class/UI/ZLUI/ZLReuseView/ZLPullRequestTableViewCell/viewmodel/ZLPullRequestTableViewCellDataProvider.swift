//
//  ZLPullRequestTableViewCellDataProvider.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/26.
//  Copyright © 2021 ZM. All rights reserved.
//

import Foundation

extension ZLPullRequestTableViewCellData {
    static func getCellDatasWithPRModel(data:PrInfoQuery.Data, firstPage:Bool) -> [ZLGithubItemTableViewCellData]{
        
        var cellDatas : [ZLGithubItemTableViewCellData] = []
        
        if firstPage {
            let headercellData = ZLPullRequestHeaderTableViewCellData(data: data)
            cellDatas.append(headercellData)
            
            if let pullrequest = data.repository?.pullRequest {
                let bodyCellData = ZLPullRequestBodyTableViewCellData(data: pullrequest)
                cellDatas.append(bodyCellData)
            }
        }
              
        if let timelines = data.repository?.pullRequest?.timelineItems.nodes {
            for timeline in timelines {
                if let comment =  timeline?.asIssueComment {
                    let bodyCellData = ZLPullRequestCommentTableViewCellData(data: comment)
                    cellDatas.append(bodyCellData)
                } else if timeline?.asSubscribedEvent != nil ||
                            timeline?.asUnsubscribedEvent != nil ||
                            timeline?.asMentionedEvent != nil ||
                            timeline?.asAddedToProjectEvent != nil ||
                            timeline?.asRemovedFromProjectEvent != nil {
                    continue
                } else if let timeline  = timeline{
                    let timelinedata = ZLPullRequestTimelineTableViewCellData(data: timeline)
                    cellDatas.append(timelinedata)
                }
            }
        }
        
        return cellDatas
    }
}
