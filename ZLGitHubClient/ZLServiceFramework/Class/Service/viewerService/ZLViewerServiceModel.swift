//
//  ZLViewerServiceModel.swift
//  ZLServiceFramework
//
//  Created by 朱猛 on 2021/4/7.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

@objcMembers class ZLViewerServiceModel: ZLBaseServiceModel, ZLViewerServiceModuleProtocol {
    
    //MAKR: private property 即便在servicemodel 类中也不可以直接访问
    private var _currentUserModel: ZLGithubUserModel?
    
    //MAKR: sharedInstance
    private static let shared : ZLViewerServiceModel = ZLViewerServiceModel()

    static func sharedServiceModel() -> ZLViewerServiceModel{
        return shared
    }
    
    override init() {
        super.init()
        
        ZLServiceManager.sharedInstance.loginServiceModel?.registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLLoginResult_Notification)
        ZLServiceManager.sharedInstance.loginServiceModel?.registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLLogoutResult_Notification)
        
        if let loginName = ZLSharedDataManager.sharedInstance().currentLoginName {
            self._currentUserModel = ZLToolManager.sharedInstance()?.zlDBModule.getViewerInfo(withLoginName: loginName)
        }
        
        let _ =  self.getCurrentUserModelFromServer()
    }
    
    deinit {
        ZLServiceManager.sharedInstance.loginServiceModel?.unRegisterObserver(self, name: ZLLoginResult_Notification)
        ZLServiceManager.sharedInstance.loginServiceModel?.unRegisterObserver(self, name: ZLLogoutResult_Notification)
    }
    
    @objc func onNotificationArrived(notification:Notification){
        switch notification.name{
        case ZLLoginResult_Notification:do {
            
            // 登陆成功，获取登陆用户信息
            if let loginProcess = notification.params as? ZLLoginProcessModel {
                if loginProcess.loginStep == ZLLoginStep_Success {
                    let _ = self.getCurrentUserModelFromServer()
                }
            }
            
        }
        case ZLLogoutResult_Notification:do {
            self._currentUserModel = nil
        }
        default:
            break;
        }
    }
    
    
    
    
    //MARK: ------ ZLViewerServiceModuleProtocol -----
    
    var currentUserLoginName: String?{
        get{
            var str:String? = nil
            ZLBaseServiceModel.dispatchSync(){
                str = self._currentUserModel?.loginName
            }
            return str
        }
    }
    
    var currentUserModel: ZLGithubUserModel?{
        get{
            var model: ZLGithubUserModel? = nil
            ZLBaseServiceModel.dispatchSync() {
                model = self._currentUserModel
            }
            return model
        }
        set{
            ZLBaseServiceModel.dispatchSync() {
                self._currentUserModel = newValue
            }
        }
    }

    
    func getCurrentUserModelFromServer() -> ZLGithubUserModel? {
        
        ZLGithubHttpClient.default().getCurrentUserInfo(serialNumber: NSString.generateSerialNumber()) { [weak self](result, data, serialNumber) in
            
            let operationModel = ZLOperationResultModel()
            operationModel.data = data!
            operationModel.result = result
            operationModel.serialNumber = serialNumber
            
            if result == true, let userModel = data as? ZLGithubUserModel {
                ZLSharedDataManager.sharedInstance().currentLoginName = userModel.loginName
                self?.currentUserModel = userModel
                ZLToolManager.sharedInstance()?.zlDBModule.insertOrUpdateViewerInfo(userModel)
            }
            
            ZLMainThreadDispatch {
                self?.postNotification(ZLGetCurrentUserInfoResult_Notification, withParams: operationModel)
            }
        }
        
        return self.currentUserModel
    }
    
    
    func updateUserProfile(blog: String?,
                           location: String?,
                           bio: String?,
                           company: String?,
                           serialNumber : String,
                           completeHandle: ((ZLOperationResultModel) -> Void)?){
        
        let githubResponse = {[weak self](result : Bool, responseObject : Any, serialNumber : String) in
            
            let resultModel : ZLOperationResultModel = ZLOperationResultModel()
            resultModel.result = result
            resultModel.data = responseObject
            resultModel.serialNumber = serialNumber
            
            if result == true, let userModel = responseObject as? ZLGithubUserModel {
                self?.currentUserModel = userModel
                ZLToolManager.sharedInstance()?.zlDBModule.insertOrUpdateViewerInfo(userModel)
            }
            
            ZLMainThreadDispatch {
                if result == true {
                    self?.postNotification(ZLUpdateUserPublicProfileInfoResult_Notification, withParams: responseObject)
                }
                if completeHandle != nil {
                    completeHandle!(resultModel)
                }
            }
            
        }
        
        ZLGithubHttpClient.default().updateUserPublicProfile(githubResponse,
                                                             name: nil,
                                                             email: nil,
                                                             blog: blog,
                                                             company: company,
                                                             location: location,
                                                             hireable: nil,
                                                             bio: bio,
                                                             serialNumber: serialNumber)
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
    
    
    
    func getMyTopRepos(after: String?,
                       serialNumber : String,
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
        
        ZLGithubHttpClient.default().getMyTopRepo(after: after,
                                                  serialNumber: serialNumber,
                                                  block: githubResponse)
        
    }
    
    //MARK: config
    var fixedRepos: [Any]{
        set{
            if self.currentUserModel?.loginName == nil {
                return
            }
            ZLBaseServiceModel.dispatchSync() {
                ZLSharedDataManager.sharedInstance().setFixRepos(newValue, forLoginUser: self.currentUserModel!.loginName!)
            }
        }
        get{
            if self.currentUserModel?.loginName == nil {
                return []
            }
            var result:[Any]? = nil
            ZLBaseServiceModel.dispatchSync() {
                result = ZLSharedDataManager.sharedInstance().fixRepos(forLoginUser: self.currentUserModel!.loginName!)
            }
            return result ?? []
        }
    }
    
}

