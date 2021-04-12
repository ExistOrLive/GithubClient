//
//  ZLViewerServiceHeader.swift
//  ZLServiceFramework
//
//  Created by 朱猛 on 2021/4/7.
//  Copyright © 2021 ZM. All rights reserved.
//

import Foundation

@objc public  enum ZLIssueFilterType : NSInteger{
    case created
    case assigned
    case mentioned
}

@objc public enum ZLPRFilterType : NSInteger{
    case created
    case assigned
    case mentioned
    case review_request
}



@objc public protocol ZLViewerServiceModuleProtocol : ZLBaseServiceModuleProtocol {
    
    
    // MARK: ViewerInfo
    
    var currentUserLoginName: String? {get}
    
    var currentUserModel: ZLGithubUserModel? {get}
    
    func getCurrentUserModelFromServer() -> ZLGithubUserModel?
    
    
    func updateUserProfile(blog: String?,
                           location: String?,
                           bio: String?,
                           company: String?,
                           serialNumber : String,
                           completeHandle: ((ZLOperationResultModel) -> Void)?)
    
    // MARK: Viewer Issues PRS Orgs Repos
    
    func getMyIssues(key: String?,
                     state: ZLGithubIssueState,
                     filter: ZLIssueFilterType,
                     after: String? ,
                     serialNumber : String,
                     completeHandle: ((ZLOperationResultModel) -> Void)?)
    
    func getMyPRs(key: String?,
                  state: ZLGithubPullRequestState,
                  filter: ZLPRFilterType,
                  after: String? ,
                  serialNumber : String,
                  completeHandle: ((ZLOperationResultModel) -> Void)?)
    
    func getMyOrgs(serialNumber : String,
                   completeHandle: ((ZLOperationResultModel) -> Void)?)
    
    
    func getMyTopRepos(after: String?,
                       serialNumber : String,
                       completeHandle: ((ZLOperationResultModel) -> Void)?)
    
    // MARK: Viewer Config
    var fixedRepos: [Any] {get set}
    
}
