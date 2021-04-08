//
//  ZLViewerServiceModel.swift
//  ZLServiceFramework
//
//  Created by 朱猛 on 2021/4/7.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

@objcMembers class ZLViewerServiceModel: ZLBaseServiceModel, ZLViewerServiceModuleProtocol {
    
    private static let shared : ZLViewerServiceModel = ZLViewerServiceModel()
    
    override init() {
        super.init()
    }
    
    static public func sharedServiceModel() -> ZLViewerServiceModel{
        return shared
    }
    
    
    func getMyIssues(key: String?,
                     state: ZLGithubIssueState,
                     filter: ZLIssueFilterType,
                     after: String? ,
                     serialNumber : String,
                     completeHandle: ((ZLOperationResultModel) -> Void)?){
        
        var filterStr = ""
        
        switch filter{
        case .assigned:
            filterStr = "archived:false is:issue assignee:@me"
        case .created:
            filterStr = "archived:false is:issue author:@me"
        case .mentioned:
            filterStr = "archived:false is:issue mentions:@me"
        }
        
        let query = "\(key ?? "") \(filterStr) \(state == .open ? "is:open" : "is:closed")"
        
        let githubResponse = {(result : Bool, responseObject : Any, serialNumber : String) in
            
            let resultModel : ZLOperationResultModel = ZLOperationResultModel()
            resultModel.result = result
            resultModel.data = responseObject
            resultModel.serialNumber = serialNumber
            
            if completeHandle != nil {
                DispatchQueue.main.async {
                    completeHandle!(resultModel)
                }
            }
            
        }
        
        ZLGithubHttpClient.default().searchItem(after: after,
                                                query: query,
                                                type: .Issue,
                                                serialNumber: serialNumber,
                                                block: githubResponse)
    }
    
    func getMyPRs(key: String?,
                  state: ZLGithubPullRequestState,
                  filter: ZLPRFilterType,
                  after: String? ,
                  serialNumber : String,
                  completeHandle: ((ZLOperationResultModel) -> Void)?){
        
        var filterStr = ""
        
        switch filter{
        case .assigned:
            filterStr = "archived:false is:pr assignee:@me"
        case .created:
            filterStr = "archived:false is:pr author:@me"
        case .mentioned:
            filterStr = "archived:false is:pr mentions:@me"
        case .review_request:
            filterStr = "archived:false is:pr review-requested:@me"
        }
        
        let query = "\(key ?? "") \(filterStr) \(state == .open ? "is:open" : "is:closed")"
        
        let githubResponse = {(result : Bool, responseObject : Any, serialNumber : String) in
            
            let resultModel : ZLOperationResultModel = ZLOperationResultModel()
            resultModel.result = result
            resultModel.data = responseObject
            resultModel.serialNumber = serialNumber
            
            if completeHandle != nil {
                DispatchQueue.main.async {
                    completeHandle!(resultModel)
                }
            }
            
        }
        
        ZLGithubHttpClient.default().searchItem(after: after,
                                                query: query,
                                                type: .Issue,
                                                serialNumber: serialNumber,
                                                block: githubResponse)
        
    }
    
    func getMyOrgs(serialNumber : String,
                   completeHandle: ((ZLOperationResultModel) -> Void)?){
        
        let githubResponse = {(result : Bool, responseObject : Any, serialNumber : String) in
            
            let resultModel : ZLOperationResultModel = ZLOperationResultModel()
            resultModel.result = result
            resultModel.data = responseObject
            resultModel.serialNumber = serialNumber
            
            if completeHandle != nil {
                DispatchQueue.main.async {
                    completeHandle!(resultModel)
                }
            }
            
        }
        
        ZLGithubHttpClient.default().getOrgs(serialNumber: serialNumber,
                                             block: githubResponse)
    }
    
}

