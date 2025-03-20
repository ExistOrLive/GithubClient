//
//  ZLRepoInfoPresenter.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/6/4.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import ZLGitRemoteService

protocol ZLRepoInfoPresenterDelegate: AnyObject {
    func onRepoInfoLoad(success: Bool, msg: String)
    
    func onBranchChanged()
    
    func onWatchStatusLoaded()
    
    func onStarStatusLoaded()
}


class ZLRepoInfoPresenter: NSObject {
    
    // Entry Params
    let repoFullName: String
    
    // delegate
    weak var delegate: ZLRepoInfoPresenterDelegate?
    
    /// data
    private(set) var repoModel: ZLGithubRepositoryModel?
    
    private(set) var viewerIsWatch: Bool? = nil
    
    private(set) var viewerIsStar: Bool? = nil
    
    private(set) var currentBranch: String?  = nil
    
    init(repoFullName: String) {
        self.repoFullName = repoFullName
        super.init()
    }
}


// MARK: - Action
extension ZLRepoInfoPresenter {
    
    func loadRepoRequest() {
        
        // 从服务器查询
        let tmpRepoInfo = ZLRepoServiceShared()?
            .getRepoInfo(withFullName: self.repoFullName,
                         serialNumber: NSString.generateSerialNumber())
        { [weak self] (resultModel) in
            
            guard let self = self else { return }
            
            if resultModel.result,
               let repoInfoModel = resultModel.data as? ZLGithubRepositoryModel {
                
                self.repoModel = repoInfoModel
                if self.currentBranch == nil {
                    self.currentBranch = repoInfoModel.default_branch
                }
                self.delegate?.onRepoInfoLoad(success: true, msg: "")
                
            } else {
                var msg: String = ""
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    msg = errorModel.message
                }
                self.delegate?.onRepoInfoLoad(success: false, msg: msg)
            }
        }
        
        if let repoInfoModel = tmpRepoInfo {
            
            self.repoModel = repoInfoModel
            if self.currentBranch == nil {
                self.currentBranch = repoInfoModel.default_branch
            }
            
            self.delegate?.onRepoInfoLoad(success: true, msg: "")
            
        }
    }
    
    
    func changeBranch(newBranch: String) {
        self.currentBranch = newBranch
        delegate?.onBranchChanged()
    }
    
    
    func getRepoWatchStatus() {
        
        ZLRepoServiceShared()?.getRepoWatchStatus(withFullName: repoFullName,
                                                  serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel: ZLOperationResultModel) in
            guard let self = self else { return }
            if resultModel.result {
                guard let data: [String: Bool] = resultModel.data as? [String: Bool] else {
                    return
                }
                self.viewerIsWatch = data["isWatch"] ?? false
                self.delegate?.onWatchStatusLoaded()
            }
        }
    }
    
    func watchRepo(callBack: @escaping (Bool, String) -> Void ) {
        guard let viewerIsWatch = self.viewerIsWatch else { return }
        if self.viewerIsWatch == false {
            
            ZLRepoServiceShared()?.watchRepo(withFullName: self.repoFullName,
                                             serialNumber: NSString.generateSerialNumber())
            {[weak self](resultModel: ZLOperationResultModel) in
                guard let self = self else { return }
                if resultModel.result {
                    self.viewerIsWatch = true
                    callBack(true, "")
                    self.loadRepoRequest()
                    self.delegate?.onWatchStatusLoaded()
                } else {
                    callBack(false, ZLLocalizedString(string: "Watch Fail", comment: ""))
                }
            }
            
        } else {
            
            ZLRepoServiceShared()?.unwatchRepo(withFullName: self.repoFullName,
                                               serialNumber: NSString.generateSerialNumber())
            {[weak self](resultModel: ZLOperationResultModel) in
                guard let self = self else { return }
                if resultModel.result {
                    self.viewerIsWatch = false
                    callBack(true, "")
                    self.loadRepoRequest()
                    self.delegate?.onWatchStatusLoaded()
                } else {
                    callBack(false, ZLLocalizedString(string: "Unwatch Fail", comment: ""))
                }
            }
        }
    }
    
    func getRepoStarStatus() {
        
        ZLRepoServiceShared()?.getRepoStarStatus(withFullName: repoFullName,
                                                 serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel: ZLOperationResultModel) in
            guard let self = self else { return }
            if resultModel.result {
                guard let data: [String: Bool] = resultModel.data as? [String: Bool] else {
                    return
                }
                self.viewerIsStar = data["isStar"] ?? false
                self.delegate?.onStarStatusLoaded()
            }
        }
    }
    
    func starRepo(callBack: @escaping (Bool, String) -> Void )  {
        guard let viewerIsStar = self.viewerIsStar else { return }
        

        if self.viewerIsStar == false {
            
            ZLRepoServiceShared()?.starRepo(withFullName: self.repoFullName,
                                            serialNumber: NSString.generateSerialNumber())
            {[weak self](resultModel: ZLOperationResultModel) in
                guard let self = self else { return }
                if resultModel.result {
                    self.viewerIsStar = true
                    callBack(true, "")
                    self.loadRepoRequest()
                    self.delegate?.onStarStatusLoaded()
                } else {
                    callBack(false, ZLLocalizedString(string: "Star Fail", comment: ""))
                }
            }
            
        } else {
            
            ZLRepoServiceShared()?.unstarRepo(withFullName: self.repoFullName,
                                              serialNumber: NSString.generateSerialNumber())
            {[weak self](resultModel: ZLOperationResultModel) in
                guard let self = self else { return }
                if resultModel.result {
                    self.viewerIsStar = false
                    callBack(true, "")
                    self.loadRepoRequest()
                    self.delegate?.onStarStatusLoaded()
                } else {
                    callBack(false, ZLLocalizedString(string: "Unstar Fail", comment: ""))
                }
            }
        }
        
    }
    
    func forkRepo(callBack: @escaping (Bool, String) -> Void)  {
        
        ZLRepoServiceShared()?.forkRepository(withFullName: self.repoFullName,
                                              org: nil,
                                              serialNumber: NSString.generateSerialNumber())
        {(resultModel: ZLOperationResultModel) in
            var msg: String = ""
            if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                msg = errorModel.message
            }
            
            callBack(resultModel.result,msg)
        }
    }
    
}
