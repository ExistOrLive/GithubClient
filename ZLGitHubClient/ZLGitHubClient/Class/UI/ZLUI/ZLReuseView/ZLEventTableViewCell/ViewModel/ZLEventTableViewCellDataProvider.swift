
//
//  ZLEventTableViewCellDataProvider.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/1.
//  Copyright © 2019 ZM. All rights reserved.
//

import Foundation

extension ZLEventTableViewCellData
{
    static func getCellDataWithEventModel(eventModel : ZLGithubEventModel) -> ZLEventTableViewCellData
    {
        switch eventModel.type
        {
        case .pushEvent: do{
            return ZLPushEventTableViewCellData(eventModel: eventModel)
            }
        case .commitCommentEvent:do{
            return ZLCommitCommentEventTableViewCellData(eventModel: eventModel)
            }
        case .createEvent:do{
            return ZLCreateEventTableViewCellData(eventModel: eventModel)
            }
        case .deleteEvent:do{
            return ZLDeleteEventTableViewCellData(eventModel: eventModel)
            }
        case .forkEvent:do{
            return ZLForkEventTableViewCellData(eventModel: eventModel)
            }
        default : do
        {
                return ZLEventTableViewCellData(eventModel: eventModel)
            }
        }
    }
}
