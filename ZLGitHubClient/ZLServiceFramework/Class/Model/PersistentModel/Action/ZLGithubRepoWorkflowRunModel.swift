//
//  ZLGithubRepoWorkflowRunModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLBaseFramework
import MJExtension

@objcMembers open class  ZLGithubRepoWorkflowCommit : ZLBaseObject {
    open var id_commit : String?
    open var tree_id : String?
    open var message : String?
    open var timestamp : Date?
    open var author_name : String?
    open var author_email : String?
    open var committer_name : String?
    open var committer_email : String?
    
    open override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["id_commit":"id",
                "author_name":"author.name",
                "author_email":"author.email",
                "committer_name":"committer.name",
                "committer_email":"committer.email"]
    }
    
    open override func mj_newValue(fromOldValue oldValue: Any!, property: MJProperty!) -> Any! {
        if((property.name == "timestamp") &&
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


@objcMembers open class ZLGithubRepoWorkflowRunModel: ZLBaseObject {
    
    open var id_workflowrun : String?
    open var node_id : String?
    open var workflow_id : String?
    
    open var head_branch : String?
    open var head_sha : String?
    open var run_number : Int  = 0
    open var event : String?                       // push pull_request issue
    open var status : String?                      // completed in_progess
    open var conclusion : String?                  // failure cancelled success
    open var created_at : Date?
    open var updated_at : Date?
    
    
    open var url : String?
    open var html_url : String?
    open var jobs_url : String?
    open var logs_url : String?
    open var check_suite_url : String?
    open var artifacts_url : String?
    open var workflow_url : String?
    
    open var repository : ZLGithubRepositoryModel?
    open var head_repository : ZLGithubRepositoryModel?
    open var head_commit : ZLGithubRepoWorkflowCommit?
    
    
    open override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["id_workflowrun":"id"]
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
