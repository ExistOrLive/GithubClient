//
//  ZLEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by BeeCloud on 2019/11/26.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLEventTableViewCellData: NSObject {
    
    var eventModel : ZLGithubEventModel!
    
    override init() {
        super.init()
    }
    
    convenience init(eventModel : ZLGithubEventModel)
    {
        self.init()
        self.eventModel = eventModel;
    }
    
    func getActorAvaterURL() -> String
    {
        return self.eventModel.actor.avatar_url
    }
    
    func getActorName() -> String
    {
        return self.eventModel.actor.login
    }
    
    func getTimeStr() -> String
    {
        let timeStr = NSString.init(format: "%@",(self.eventModel.created_at as NSDate?)?.dateLocalStrSinceCurrentTime() ?? "")
        return timeStr as String
    }
    
    func getEventDescrption() -> String
    {
        return self.eventModel.eventDescription
    }
}
