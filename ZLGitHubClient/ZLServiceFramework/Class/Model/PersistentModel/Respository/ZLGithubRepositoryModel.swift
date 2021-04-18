//
//  ZLGithubRepositoryModel.swift
//  ZLServiceFramework
//
//  Created by 朱猛 on 2021/4/8.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import MJExtension

@objcMembers open class ZLGithubLicenseModel: ZLBaseObject{
    open var node_id: String?
    open var name: String?                         // Apache License 2.0
    open var spdxId: String?                       // Apache-2.0
    open var key: String?                          // apache-2.0
}

@objcMembers open class ZLGithubRepositoryModel: ZLBaseObject {
    
    open var repo_id: String?
    open var node_id: String?
    
    open var name: String?
    open var full_name: String?
    open var desc_Repo: String?
    open var html_url: String?
    open var isPriva: Bool = false
    open var homepage_url: String?
    open var language: String?                          // 主要语言
    open var default_branch: String?                    // 默认分支
    open var sourceRepoFullName: String?                // parent repo
    
    open var open_issues_count: Int = 0                 // open issue数
    open var stargazers_count: Int = 0                  // star数
    open var subscribers_count: Int = 0                 // watch数
    open var forks_count: Int = 0                       // fork数
    
    open var updated_at: Date?
    open var created_at: Date?
    open var pushed_at: Date?
    
    open var owner: ZLGithubUserBriefModel?              // owener
    open var license: ZLGithubLicenseModel?              // license信息
    
    open override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["repo_id":"id",
                "desc_Repo":"description",
                "isPriva":"private",
                "sourceRepoFullName":"source.full_name",
                "homepage_url":"homepage"]
    }
    
    open override func mj_newValue(fromOldValue oldValue: Any!, property: MJProperty!) -> Any! {
        if "created_at" == property.name ||
            "updated_at" == property.name ||
            "pushed_at" == property.name {
            if let str: String = oldValue as? String{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                return dateFormatter.date(from: str)
            }
            return nil
        }
        return oldValue
    }
    
    
    convenience init(queryData: RepoInfoQuery.Data){
        self.init()
        node_id = queryData.repository?.nodeId
        repo_id = queryData.repository?.repoId == nil ? nil :String(queryData.repository!.repoId!)
        
        name = queryData.repository?.name
        full_name = queryData.repository?.fullName
        html_url = queryData.repository?.htmlUrl
        desc_Repo = queryData.repository?.descRepo
        homepage_url = queryData.repository?.homepageUrl
        isPriva = queryData.repository?.isPrivate ?? false
        language = queryData.repository?.primaryLanguage?.name
        default_branch = queryData.repository?.defaultBranchRef?.name
        open_issues_count = queryData.repository?.issues.totalCount ?? 0
        stargazers_count = queryData.repository?.stargazerCount ?? 0
        subscribers_count = queryData.repository?.watchers.totalCount ?? 0
        forks_count = queryData.repository?.forkCount ?? 0
        sourceRepoFullName = queryData.repository?.parent?.nameWithOwner
        
        let ownerModel = ZLGithubUserBriefModel()
        ownerModel.node_id = queryData.repository?.owner.nodeId
        ownerModel.loginName = queryData.repository?.owner.login
        ownerModel.html_url = queryData.repository?.owner.htmlUrl
        ownerModel.avatar_url = queryData.repository?.owner.avatarUrl
        ownerModel.type = queryData.repository?.isInOrganization ?? false ? .organization : .user
        owner = ownerModel
        
        let licenseModel = ZLGithubLicenseModel()
        licenseModel.node_id = queryData.repository?.licenseInfo?.nodeId
        licenseModel.name = queryData.repository?.licenseInfo?.name
        licenseModel.spdxId = queryData.repository?.licenseInfo?.spdxId
        licenseModel.key = queryData.repository?.licenseInfo?.key
        license = licenseModel
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        created_at = dateFormatter.date(from: queryData.repository?.createdAt ?? "")
        updated_at = dateFormatter.date(from: queryData.repository?.updatedAt ?? "")
        pushed_at = dateFormatter.date(from: queryData.repository?.pushedAt ?? "")
    }
    
}
