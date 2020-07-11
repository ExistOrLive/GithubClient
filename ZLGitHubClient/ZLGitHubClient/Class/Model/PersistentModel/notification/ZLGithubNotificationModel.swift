//
//  ZLGithubNotificationModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/8.
//  Copyright © 2020 ZM. All rights reserved.
//

@objcMembers class ZLGithubNotificationSubjectModel: ZLBaseObject{
    var title : String?
    var url : String?
    var lasted_comment_url : String?
    var type : String?
}


/**
      https://docs.github.com/en/rest/reference/activity#notifications
   
    Notification Reason :
           assign,  author, comment, invatation , manual, mention, review_requested, security_alert, state_change,subscribed, team_mention
   
 */

@objcMembers class ZLGithubNotificationModel: ZLBaseObject {
    
    var id_Notification: String?
    var unread : Bool = false
    var url : String?
    var subscription_url : String?
    var updated_at : Date?
    var last_read_at : Date?
    
    var reason : String = "assign"          //
    
    var subject: ZLGithubNotificationSubjectModel?
    var repository : ZLGithubRepositoryModel?
    
    override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["id_Notification":"id"]
    }
    
    
    override func mj_newValue(fromOldValue oldValue: Any!, property: MJProperty!) -> Any! {
        if((property.name == "updated_at" ||
            property.name == "last_read_at") &&
            property.type.typeClass == NSDate.self) {
                
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
