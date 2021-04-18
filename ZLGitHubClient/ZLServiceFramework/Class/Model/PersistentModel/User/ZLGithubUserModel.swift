//
//  ZLGithubUserModel.swift
//  ZLServiceFramework
//
//  Created by 朱猛 on 2021/4/8.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import MJExtension



// MARK: ----- ZLGithubUserBriefModel -----
@objcMembers open class ZLGithubUserBriefModel: ZLBaseObject {
    open var node_id: String?               // node_id 用于与graphql api 交互
    open var user_id: String?               // databaseid
    open var loginName: String?
    open var html_url: String?
    open var avatar_url: String?
    open var type: ZLGithubUserType = .user
    
    open override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["user_id":"id","loginName":"login"]
    }
    
    open override func mj_newValue(fromOldValue oldValue: Any!, property: MJProperty!) -> Any! {
        if "type" == property.name {
            if let str: String = oldValue as? String{
                if "Organization" == str {
                    return ZLGithubUserType.organization.rawValue
                } else {
                    return ZLGithubUserType.user.rawValue
                }
            }
            return ZLGithubUserType.user.rawValue
        }
        return oldValue
    }
}

// MARK: ----- ZLGithubUserModel -----
@objcMembers open class ZLGithubUserModel: ZLGithubUserBriefModel{
    
    open var name: String?
    
    open var company: String?
    open var blog: String?
    open var location: String?
    open var email: String?
    open var bio: String?
    
    open var followers: Int = 0
    open var following: Int = 0
    open var gists: Int{
        get{
            if _gists == nil{
                return private_gists + public_gists
            }
            return _gists ?? 0
        }
        set{
            _gists = newValue
        }
        
    }
    open var repositories: Int{
        get{
            if _repositories == nil {
                return public_repos + total_private_repos
            }
            return _repositories ?? 0
        }
        set{
            _repositories = newValue
        }
    }
    
    open var created_at: Date?
    open var updated_at: Date?
    
    open var statusMessage: String?
    
    open var isViewer: Bool = false
    open var viewerIsFollowing: Bool = false
    open var isDeveloperProgramMember: Bool = false
    
    // MARK: private property
    open var public_repos: Int = 0
    open var total_private_repos: Int = 0
    private var _repositories: Int?
    open var private_gists: Int = 0
    open var public_gists: Int = 0
    private var _gists: Int?
    
    
    open override func mj_newValue(fromOldValue oldValue: Any!, property: MJProperty!) -> Any! {
        if "created_at" == property.name ||
            "updated_at" == property.name {
            if let str: String = oldValue as? String{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                return dateFormatter.date(from: str)
            }
            return nil
        }
        return super.mj_newValue(fromOldValue: oldValue, property: property)
    }
    
    
    convenience init(queryData: UserInfoQuery.Data){
        self.init()
        user_id = queryData.user?.userId == nil ? nil : String(queryData.user!.userId!)
        node_id = queryData.user?.nodeId
        loginName = queryData.user?.loginName
        html_url = queryData.user?.htmlUrl
        avatar_url = queryData.user?.avatarUrl
        type = .user
        
        name = queryData.user?.name
        company = queryData.user?.company
        blog = queryData.user?.blog
        location = queryData.user?.location
        email = queryData.user?.email
        bio = queryData.user?.bio
        
        followers = queryData.user?.followers.totalCount ?? 0
        following = queryData.user?.following.totalCount ?? 0
        gists = queryData.user?.gists.totalCount ?? 0
        repositories = queryData.user?.repositories.totalCount ?? 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        created_at = dateFormatter.date(from: queryData.user?.createdAt ?? "")
        updated_at = dateFormatter.date(from: queryData.user?.updatedAt ?? "")
        
        statusMessage = queryData.user?.status?.message
        isViewer = queryData.user?.isViewer ?? false
        viewerIsFollowing = queryData.user?.viewerIsFollowing ?? false
        isDeveloperProgramMember = queryData.user?.isDeveloperProgramMember ?? false
    }
    
    convenience init(viewerQueryData: ViewerInfoQuery.Data){
        self.init()
        user_id = String(viewerQueryData.viewer.userId ?? 0)
        node_id = viewerQueryData.viewer.nodeId
        loginName = viewerQueryData.viewer.loginName
        html_url = viewerQueryData.viewer.htmlUrl
        avatar_url = viewerQueryData.viewer.avatarUrl
        type = .user
        
        name = viewerQueryData.viewer.name
        company = viewerQueryData.viewer.company
        blog = viewerQueryData.viewer.blog
        location = viewerQueryData.viewer.location
        email = viewerQueryData.viewer.email
        bio = viewerQueryData.viewer.bio
        
        followers = viewerQueryData.viewer.followers.totalCount
        following = viewerQueryData.viewer.following.totalCount
        gists = viewerQueryData.viewer.gists.totalCount
        repositories = viewerQueryData.viewer.repositories.totalCount
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        created_at = dateFormatter.date(from: viewerQueryData.viewer.createdAt )
        updated_at = dateFormatter.date(from: viewerQueryData.viewer.updatedAt )
        
        statusMessage = viewerQueryData.viewer.status?.message
        isViewer = viewerQueryData.viewer.isViewer
        viewerIsFollowing = viewerQueryData.viewer.viewerIsFollowing
        isDeveloperProgramMember = viewerQueryData.viewer.isDeveloperProgramMember
    }
    
    convenience init(UserOrOrgQueryData queryData: UserOrOrgInfoQuery.Data){
        self.init()
        user_id = queryData.user?.userId == nil ? nil : String(queryData.user!.userId!)
        node_id = queryData.user?.nodeId
        loginName = queryData.user?.loginName
        html_url = queryData.user?.htmlUrl
        avatar_url = queryData.user?.avatarUrl
        type = .user
        
        name = queryData.user?.name
        company = queryData.user?.company
        blog = queryData.user?.blog
        location = queryData.user?.location
        email = queryData.user?.email
        bio = queryData.user?.bio
        
        followers = queryData.user?.followers.totalCount ?? 0
        following = queryData.user?.following.totalCount ?? 0
        gists = queryData.user?.gists.totalCount ?? 0
        repositories = queryData.user?.repositories.totalCount ?? 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        created_at = dateFormatter.date(from: queryData.user?.createdAt ?? "")
        updated_at = dateFormatter.date(from: queryData.user?.updatedAt ?? "")
        
        statusMessage = queryData.user?.status?.message
        isViewer = queryData.user?.isViewer ?? false
        viewerIsFollowing = queryData.user?.viewerIsFollowing ?? false
        isDeveloperProgramMember = queryData.user?.isDeveloperProgramMember ?? false
    }
    
    
    
}


// MARK: ----- ZLGithubOrgModel -----
// 废弃 ZLGithubOrgModel 使用 ZLGithubUserModel 统一保存User和Organization
@objcMembers open class ZLGithubOrgModel: ZLGithubUserBriefModel{
    
    open var name: String?
    
    open var blog: String?
    open var location: String?
    open var email: String?
    open var bio: String?

    open var members: Int = 0
    open var teams: Int = 0
    open var repositories: Int{
        get{
            if _repositories == nil {
                return public_repos + total_private_repos
            }
            return _repositories ?? 0
        }
        set{
            _repositories = newValue
        }
    }
    
    open var created_at: Date?
    open var updated_at: Date?
    
    open var viewerIsAMember: Bool = false
    
    // MARK: private property
    open var public_repos: Int = 0
    open var total_private_repos: Int = 0
    private var _repositories: Int?
    
    open override func mj_newValue(fromOldValue oldValue: Any!, property: MJProperty!) -> Any! {
        if "created_at" == property.name ||
            "updated_at" == property.name {
            if let str: String = oldValue as? String{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                return dateFormatter.date(from: str)
            }
            return nil
        }
        return super.mj_newValue(fromOldValue: oldValue, property: property)
    }
    
    convenience init(queryData: OrgInfoQuery.Data){
        self.init()
        
        user_id = String(queryData.organization?.userId ?? 0)
        node_id = queryData.organization?.nodeId
        loginName = queryData.organization?.loginName
        html_url = queryData.organization?.htmlUrl
        avatar_url = queryData.organization?.avatarUrl
        type = .organization
        
        name = queryData.organization?.name
        blog = queryData.organization?.blog
        location = queryData.organization?.location
        email = queryData.organization?.email
        bio = queryData.organization?.bio
        
        members = queryData.organization?.membersWithRole.totalCount ?? 0
        teams = queryData.organization?.teams.totalCount ?? 0
        repositories = queryData.organization?.repositories.totalCount ?? 0
        viewerIsAMember = queryData.organization?.viewerIsAMember ?? false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        created_at = dateFormatter.date(from: queryData.organization?.createdAt ?? "")
        updated_at = dateFormatter.date(from: queryData.organization?.updatedAt ?? "")
    }
    
    convenience init(UserOrOrgQueryData queryData: UserOrOrgInfoQuery.Data){
        self.init()
        
        user_id = String(queryData.organization?.userId ?? 0)
        node_id = queryData.organization?.nodeId
        loginName = queryData.organization?.loginName
        html_url = queryData.organization?.htmlUrl
        avatar_url = queryData.organization?.avatarUrl
        type = .organization
        
        name = queryData.organization?.name
        blog = queryData.organization?.blog
        location = queryData.organization?.location
        email = queryData.organization?.email
        bio = queryData.organization?.bio
        
        members = queryData.organization?.membersWithRole.totalCount ?? 0
        teams = queryData.organization?.teams.totalCount ?? 0
        repositories = queryData.organization?.repositories.totalCount ?? 0
        viewerIsAMember = queryData.organization?.viewerIsAMember ?? false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        created_at = dateFormatter.date(from: queryData.organization?.createdAt ?? "")
        updated_at = dateFormatter.date(from: queryData.organization?.updatedAt ?? "")
    }
    
}

