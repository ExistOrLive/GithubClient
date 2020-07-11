//
//  ZLGithubRepoWorkflowRunModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

@objcMembers class  ZLGithubRepoWorkflowCommit : ZLBaseObject {
    var id_commit : String?
    var tree_id : String?
    var message : String?
    var timestamp : Date?
    var author_name : String?
    var author_email : String?
    var committer_name : String?
    var committer_email : String?
    
    override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["id_commit":"id",
                "author_name":"author.name",
                "author_email":"author.email",
                "committer_name":"committer.name",
                "committer_email":"committer.email"]
    }
    
    override func mj_newValue(fromOldValue oldValue: Any!, property: MJProperty!) -> Any! {
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


@objcMembers class ZLGithubRepoWorkflowRunModel: ZLBaseObject {
    var id_workflowrun : String?
    var node_id : String?
    var workflow_id : String?
    
    var head_branch : String?
    var head_sha : String?
    var run_number : Int  = 0
    var event : String?                       // push pull_request issue
    var status : String?                      // completed in_progess
    var conclusion : String?                  // failure cancelled success
    var created_at : Date?
    var updated_at : Date?
    
    
    var url : String?
    var html_url : String?
    var jobs_url : String?
    var logs_url : String?
    var check_suite_url : String?
    var artifacts_url : String?
    var workflow_url : String?
    
    var repository : ZLGithubRepositoryModel?
    var head_repository : ZLGithubRepositoryModel?
    var head_commit : ZLGithubRepoWorkflowCommit?
    
    
    override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["id_workflowrun":"id"]
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
