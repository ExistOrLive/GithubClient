//
//  ZLGithubRepoWorkflowModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/10.
//  Copyright © 2020 ZM. All rights reserved.
//
import ZLBaseFramework
import MJExtension

@objcMembers open class ZLGithubRepoWorkflowModel: ZLBaseObject {
    
    open var id_workflow : String?
    open var node_id : String?
    open var name : String?
    open var path : String?
    open var state : String = "active"     // active
    open var url : String?
    open var html_url : String?
    open var badge_url : String?
    open var created_at : Date?
    open var updated_at : Date?
    
    
    open override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["id_workflow":"id"]
    }
    
    open override func mj_newValue(fromOldValue oldValue: Any!, property: MJProperty!) -> Any! {
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
