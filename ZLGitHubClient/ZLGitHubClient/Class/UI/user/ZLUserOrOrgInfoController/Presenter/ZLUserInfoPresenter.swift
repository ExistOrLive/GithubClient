//
//  ZLUserInfoPresenter.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/4/1.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService


class ZLUserInfoViewData {
    let userInfoModel: ZLGithubUserModel
    var pinnedRepositories: [ZLGithubRepositoryBriefModel]
    
    init(userInfoModel: ZLGithubUserModel, pinnedRepositories: [ZLGithubRepositoryBriefModel]) {
        self.userInfoModel = userInfoModel
        self.pinnedRepositories = pinnedRepositories
    }
}

class ZLOrgInfoViewData {
    let orgInfoModel: ZLGithubOrgModel
    var pinnedRepositories: [ZLGithubRepositoryBriefModel]
    init(orgInfoModel: ZLGithubOrgModel, pinnedRepositories: [ZLGithubRepositoryBriefModel]) {
        self.orgInfoModel = orgInfoModel
        self.pinnedRepositories = pinnedRepositories
    }
}

class ZLUserInfoPresenter: NSObject {
    
    // Input Params
    private let login: String
    
    // Model
    private var infoModel: ZLGithubUserBriefModel?            //
    private var pinnedRepositories: [ZLGithubRepositoryBriefModel] = []
    
    //
    private var callBack: ((ZLPresenterMessageModel) -> Void)?
    
    init(login: String, callBack: ((ZLPresenterMessageModel) -> Void)? = nil  ) {
        self.login = login
        self.callBack = callBack
        super.init()
    }
    
    func loadData(firstLoad: Bool) {
        getUserInfo(firstLoad: firstLoad)
    }
}

// MARK: Outer Property
extension ZLUserInfoPresenter {
    
    var model: ZLGithubUserBriefModel? {
        infoModel
    }
    
    var loginName: String? {
        infoModel?.loginName
    }
    
    var htmlUrl: String? {
        infoModel?.html_url
    }
}

extension ZLUserInfoPresenter {
    
    func onError(errorMessage: String) {
        let model = ZLPresenterMessageModel()
         model.result = false
         model.error = errorMessage
         callBack?(model)
    }
    
    func onNext(data: Any) {
       let model = ZLPresenterMessageModel()
        model.result = true
        model.data = data
        callBack?(model)
    }
    
    func on(data: ZLPresenterMessageModel) {
        callBack?(data)
    }
    
    private func onNextUserData() {
        guard let userInfoModel = infoModel as? ZLGithubUserModel else {
            return
        }
        self.onNext(data: ZLUserInfoViewData(userInfoModel: userInfoModel, pinnedRepositories: pinnedRepositories))
    }
    
    private func onNextOrgData() {
        guard let orgInfoModel = infoModel as? ZLGithubOrgModel else {
            return
        }
        self.onNext(data: ZLOrgInfoViewData(orgInfoModel: orgInfoModel, pinnedRepositories: pinnedRepositories))
    }
}

// MARK: Request

extension ZLUserInfoPresenter {
    
    private func getUserInfo(firstLoad: Bool) {

        guard !login.isEmpty else {
            onError(errorMessage: "login name is nil")
            return
        }

        let userOrOrgInfo = ZLUserServiceShared()?.getUserInfo(withLoginName: login,
                                                               serialNumber: NSString.generateSerialNumber())
        { [weak self] model in

            guard let self = self else { return }

            if model.result {
                if let model = model.data as? ZLGithubUserModel {
                    self.infoModel = model
                    self.getUserPinnedRepos()
                    self.onNextUserData()
                } else if let model = model.data as? ZLGithubOrgModel {
                    self.infoModel = model
                    self.getOrgPinnedRepos()
                    self.onNextOrgData()
                } else {
                    self.onError(errorMessage: "Get User Info Failed ")
                }
            } else {

                if let model = model.data as? ZLGithubRequestErrorModel {
                    self.onError(errorMessage:"Get User Info Failed \(model.message)" )
                } else {
                    self.onError(errorMessage: "Get User Info Failed ")
                }
            }
        }
        
        if firstLoad {
            if let model = userOrOrgInfo as? ZLGithubUserModel {
                self.infoModel = model
                self.onNextUserData()
            } else if let model = userOrOrgInfo as? ZLGithubOrgModel {
                self.infoModel = model
                self.onNextOrgData()
            }
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
                    self.onNextUserData()
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
                    self.onNextOrgData()
                }
            } else {
                if let model = model.data as? ZLGithubRequestErrorModel {
                    ZLLog_Info(model.message)
                }
            }
        }
    }
}
