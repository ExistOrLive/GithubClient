//
//  ZLUserInfoStateModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2024/4/6.
//  Copyright © 2024 ZM. All rights reserved.
//

import Foundation
import ZLGitRemoteService
import ZLUIUtilities
import ZLUtilities

protocol ZLUserInfoStateModelDelegate: AnyObject {
   
    func onUserInfoLoad(result: Bool, msg: String)
    
    func onPinnedRepoLoad(result: Bool, msg: String)
    
    func onOrgRepoInfoLoad()
    
    func onFollowStatusChanged()
    
    func onBlockStatusChanged()
}

class ZLUserInfoStateModel: NSObject {
    
    // Input Params
    let login: String
    
    
    // Model
    private(set) var infoModel: ZLGithubUserBriefModel?            //
    private(set) var pinnedRepositories: [ZLGithubRepositoryBriefModel] = []
    private(set) var isOrg: Bool = false
    
    private(set) var followStatus: Bool?
    private(set) var blockStatus: Bool?
    
    var delegate: ZLUserInfoStateModelDelegate? 
    
    var firstLoad: Bool = true
    
    init(login: String) {
        self.login = login
        super.init()
    }
    
    
    var hasBlockFunction: Bool {
        var showBlockButton = ZLRCM().configAsBool(for: "BlockFunction")
        let currentLoginName = ZLServiceManager.sharedInstance.viewerServiceModel?.currentUserLoginName
        if currentLoginName == "ExistOrLive1" ||
            currentLoginName == "existorlive3" ||
            currentLoginName == "existorlive11"{
            showBlockButton = true
        }
        if currentLoginName == login {
            showBlockButton = false
        }
        return showBlockButton
    }

    var hasFollowFunction: Bool {
        let currentLoginName = ZLServiceManager.sharedInstance.viewerServiceModel?.currentUserLoginName
        return currentLoginName != login
    }
    
    
}

// MARK: - Outer Method
extension ZLUserInfoStateModel {
    var userModel: ZLGithubUserModel? {
        return (infoModel as? ZLGithubUserModel)
    }
    
    var orgModel: ZLGithubOrgModel? {
        return (infoModel as? ZLGithubOrgModel)
    }
    
    var html_url: String? {
        return infoModel?.html_url
    }
}

// MARK: - Request
extension ZLUserInfoStateModel {
    
    func getUserOrOrgInfo() {

        guard !login.isEmpty else {
            self.delegate?.onUserInfoLoad(result: false, msg: "login name is nil")
            return
        }

        let userOrOrgInfo = ZLUserServiceShared()?.getUserOrOrgInfo(withLoginName: login,
                                                               serialNumber: NSString.generateSerialNumber())
        { [weak self] model in

            guard let self = self else { return }

            if model.result {
                if let model = model.data as? ZLGithubUserModel {
                    self.infoModel = model
                    self.isOrg = false
                    self.getUserPinnedRepos()
                    self.getFollowStatus()
                    self.getBlockStatus()
                    self.delegate?.onUserInfoLoad(result: true, msg: "")
                } else if let model = model.data as? ZLGithubOrgModel {
                    model.repositories = self.orgModel?.repositories ?? 0
                    self.infoModel = model
                    self.isOrg = true
                    self.getOrgPinnedRepos()
                    self.getOrgReposInfo() 
                    self.delegate?.onUserInfoLoad(result: true, msg: "")
                } else {
                    self.delegate?.onUserInfoLoad(result: false, msg: "Get User Info Failed ")
                }
            } else {

                if let model = model.data as? ZLGithubRequestErrorModel {
                    self.delegate?.onUserInfoLoad(result: false, msg: "Get User Info Failed \(model.message)")
                } else {
                    self.delegate?.onUserInfoLoad(result: false, msg: "Get User Info Failed ")
                }
            }
        }
        
        if firstLoad {
            if let model = userOrOrgInfo as? ZLGithubUserModel {
                self.infoModel = model
                self.isOrg = false
                self.delegate?.onUserInfoLoad(result: true, msg: "")
            } else if let model = userOrOrgInfo as? ZLGithubOrgModel {
                self.infoModel = model
                self.isOrg = true
                self.delegate?.onUserInfoLoad(result: true, msg: "")
            }
            firstLoad = false
        }
    }

    private func getUserPinnedRepos() {
        
        guard !login.isEmpty else {
            return
        }
        
        ZLUserServiceShared()?.getUserPinnedRepositories(login,
                                                         serialNumber: NSString.generateSerialNumber())
        { [weak self] model in
            
            guard let self = self else { return }
            
            if model.result {
                if let data = model.data as? [ZLGithubRepositoryBriefModel] {
                    self.pinnedRepositories = data
                    self.delegate?.onPinnedRepoLoad(result: true, msg: "")
                }
            } else {
                if let model = model.data as? ZLGithubRequestErrorModel {
                    ZLLog_Info(model.message)
                }
            }
        }
    }
    
    private func getOrgPinnedRepos() {
        
        guard !login.isEmpty else {
            return
        }

        ZLUserServiceShared()?.getOrgPinnedRepositories(login,
                                                        serialNumber: NSString.generateSerialNumber())
        { [weak self] model in

            guard let self = self else { return }

            if model.result {
                if let data = model.data as? [ZLGithubRepositoryBriefModel] {
                    self.pinnedRepositories = data
                    self.delegate?.onPinnedRepoLoad(result: true, msg: "")
                }
            } else {
                if let model = model.data as? ZLGithubRequestErrorModel {
                    ZLLog_Info(model.message)
                }
            }
        }
    }
    
    /// 更新组织的仓库数量
    /** https://docs.github.com/en/organizations/managing-programmatic-access-to-your-organization/limiting-oauth-app-and-github-app-access-requests
         * 如果组织的所有者没有授权，oauth app 不能通过 graphql api 访问组织的私有数据，因此这里通过rest api 获取
     **/
    func getOrgReposInfo() {
        ZLUserServiceShared()?.getOrgInfo(withLoginName: login, serialNumber: NSString.generateSerialNumber())
        { [weak self] model in

            guard let self = self else { return }

            if model.result,let model = model.data as? ZLGithubOrgModel {
                self.orgModel?.repositories = model.repositories
                self.delegate?.onOrgRepoInfoLoad()
            }
        }
    }
    
    
    func getFollowStatus() {

        guard !login.isEmpty, hasFollowFunction else { return } 
        ZLServiceManager.sharedInstance.userServiceModel?.getUserFollowStatus(withLoginName: login,
                                                                              serialNumber: NSString.generateSerialNumber()) {[weak self](resultModel: ZLOperationResultModel) in
            guard let self = self else { return }
            if resultModel.result,
                let data: [String: Bool] = resultModel.data as? [String: Bool] {
                self.followStatus = data["isFollow"] ?? false
                self.delegate?.onFollowStatusChanged()
            }
        }
    }

    func followUser(callBack: @escaping (Bool, String) -> Void) {
        guard hasFollowFunction else { return }
        ZLServiceManager.sharedInstance.userServiceModel?.followUser(withLoginName: login,
                                                                     serialNumber: NSString.generateSerialNumber()) {[weak self](resultModel: ZLOperationResultModel) in
            guard let self = self else { return }
            if resultModel.result == true {
                self.followStatus = true
                self.delegate?.onFollowStatusChanged()
            }
            callBack(resultModel.result, 
                     ZLLocalizedString(string: resultModel.result ? "Follow Success" : "Follow Fail", comment: ""))
        }

    }

    func unfollowUser(callBack: @escaping (Bool, String) -> Void) {
        guard hasFollowFunction else { return }
        ZLServiceManager.sharedInstance.userServiceModel?.unfollowUser(withLoginName: login,
                                                                       serialNumber: NSString.generateSerialNumber()) {[weak self](resultModel: ZLOperationResultModel) in
            guard let self = self else { return }
            if resultModel.result {
                self.followStatus = false
                self.delegate?.onFollowStatusChanged()
            }
            callBack(resultModel.result,
                     ZLLocalizedString(string: resultModel.result ? "Unfollow Success" : "Unfollow Fail", comment: ""))
        }
    }

    func getBlockStatus() {

        guard !login.isEmpty, hasBlockFunction else { return }
        ZLServiceManager.sharedInstance.userServiceModel?.getUserBlockStatus(withLoginName: login,
                                                                             serialNumber: NSString.generateSerialNumber()) {[weak self](resultModel: ZLOperationResultModel) in

            guard let self = self else { return }
            if resultModel.result == true {
                guard let data: [String: Bool] = resultModel.data as? [String: Bool] else {
                    return
                }
                self.blockStatus = data["isBlock"] ?? false
                self.delegate?.onBlockStatusChanged()
            }
        }
    }

    func BlockUser(callBack: @escaping (Bool, String) -> Void) {
        guard hasBlockFunction else { return }
        ZLServiceManager.sharedInstance.userServiceModel?.blockUser(withLoginName: login,
                                                                    serialNumber: NSString.generateSerialNumber()) {[weak self](resultModel: ZLOperationResultModel) in

            guard let self = self else { return }
            if resultModel.result == true {
                self.blockStatus = true
                self.delegate?.onBlockStatusChanged()
            }
            callBack(resultModel.result,
                     ZLLocalizedString(string: resultModel.result ? "Block Success" : "Block Fail", comment: ""))
        }
    }

    func unBlockUser(callBack: @escaping (Bool, String) -> Void) {
        guard hasBlockFunction else { return }
        ZLServiceManager.sharedInstance.userServiceModel?.unBlockUser(withLoginName: login,
                                                                      serialNumber: NSString.generateSerialNumber()) {[weak self](resultModel: ZLOperationResultModel) in
            guard let self = self else { return }
            if resultModel.result {
                self.blockStatus = false
                self.delegate?.onBlockStatusChanged()
            }
            callBack(resultModel.result,
                     ZLLocalizedString(string: resultModel.result ? "Unblock Success" : "Unblock Fail", comment: ""))
        }
    }
}
