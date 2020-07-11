//
//  ZLGithubRepoWorkflowModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/10.
//  Copyright © 2020 ZM. All rights reserved.
//


@objcMembers class ZLGithubRepoWorkflowModel: ZLBaseObject {
    
    var id_workflow : String?
    var node_id : String?
    var name : String?
    var path : String?
    var state : String = "active"     // active
    var url : String?
    var html_url : String?
    var badge_url : String?
    var created_at : Date?
    var updated_at : Date?
    
    
    override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["id_workflow":"id"]
    }
    
    override func mj_newValue(fromOldValue oldValue: Any!, property: MJProperty!) -> Any! {
        if((property.name == "created_at" ||
            property.name == "updated_at") &&
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
