
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
        case .pushEvent: do
        {
            return ZLPushEventTableViewCellData(eventModel: eventModel)
            }
        default : do
        {
                return ZLEventTableViewCellData(eventModel: eventModel)
            }
        }
    }
}
