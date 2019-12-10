//
//  ZLProfileEventCollectionViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/8.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLProfileEventCollectionViewCellData: ZLBaseViewModel {
    
    let data : ZLGithubEventModel
    
    var timeText : String?
    {
        get{
            return (self.data.created_at as NSDate).dateLocalStrSinceCurrentTime()
        }
    }
    
    var repo : String?
    {
        get{
            return self.data.repo.name
        }
    }
    
    
    var eventInfo : String?
    {
        get{
            return self.data.eventDescription
        }
    }
    
    init(data: ZLGithubEventModel)
    {
        self.data = data;
        super.init()
    }

}
