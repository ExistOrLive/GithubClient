//
//  ZLGithubNotificationModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/8.
//  Copyright © 2020 ZM. All rights reserved.
//

import MJExtension

@objcMembers open class ZLGithubNotificationSubjectModel: ZLBaseObject{
    open var title : String?
    open var url : String?
    open var lasted_comment_url : String?
    open var type : String?
}


/**
      https://docs.github.com/en/rest/reference/activity#notifications
   
    Notification Reason :
           assign,  author, comment, invatation , manual, mention, review_requested, security_alert, state_change,subscribed, team_mention
   
 */

@objcMembers open class ZLGithubNotificationModel: ZLBaseObject {
    
    open var id_Notification: String?
    open var unread : Bool = false
    open var url : String?
    open var subscription_url : String?
    open var updated_at : Date?
    open var last_read_at : Date?
    
    open var reason : String = "assign"          //
    
    open var subject: ZLGithubNotificationSubjectModel?
    open var repository : ZLGithubRepositoryModel?
    
    open override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["id_Notification":"id"]
    }
    
    
    open override func mj_newValue(fromOldValue oldValue: Any!, property: MJProperty!) -> Any! {
        if((property.name == "updated_at" ||
            property.name == "last_read_at") &&
            property.type.typeClass == Date.self) {
                
            guard let dateStr : String =  oldValue as? String else {
                return nil
            }
            let dateFormatter : DateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
            
            return dateFormatter.date(from: dateStr)
            
        }
        
        return oldValue
    }
}
