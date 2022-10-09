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

class ZLRepoInfoPresenter: NSObject {
    // Entry Params
    private let repoFullName: String
    
    // Obserable
    let repoInfoObservable = BehaviorRelay<ZLGithubRepositoryModel?>(value:nil)
    
    let viewerIsWatchObservable = BehaviorRelay<Bool>(value:false)
    
    let viewerIsStarObservable = BehaviorRelay<Bool>(value:false)
    
    let currentBranchObservable = BehaviorRelay<String?>(value: nil)
    
    init(repoFullName: String) {
        self.repoFullName = repoFullName
        super.init()
    }
}

extension ZLRepoInfoPresenter {
    
    // value
    var repoModel: ZLGithubRepositoryModel? {
        repoInfoObservable.value
    }
    
    var viewerIsWatch: Bool {
        viewerIsWatchObservable.value
    }
    
    var viewerIsStar: Bool {
        viewerIsStarObservable.value
    }
    
    var currentBranch: String? {
        currentBranchObservable.value
    }
}

// MARK: - Action
extension ZLRepoInfoPresenter {
    
    func loadRepoRequest() -> Observable<ZLPresenterMessageModel>{
        
        return Observable<ZLPresenterMessageModel>.create { [weak self] obserable in
            
            guard let self = self else {
                obserable.onNext(ZLPresenterMessageModel())
                return Disposables.create()
            }
            
            // 从服务器查询
            let tmpRepoInfo = ZLRepoServiceShared()?
                .getRepoInfo(withFullName: self.repoFullName,
                             serialNumber: NSString.generateSerialNumber())
            { [weak self] (resultModel) in
                
                guard let self = self else { return }
                
                if resultModel.result == true, let repoInfoModel = resultModel.data as? ZLGithubRepositoryModel {
                    
                    self.repoInfoObservable.accept(repoInfoModel)
                    if self.currentBranchObservable.value == nil {
                        self.currentBranchObservable.accept(repoInfoModel.default_branch)
                    }
                    
                    let message = ZLPresenterMessageModel()
                    message.result = true
                    obserable.onNext(message)
                
                } else if resultModel.result == false, let errorModel = resultModel.data as? ZLGithubRequestErrorModel {

                    let message = ZLPresenterMessageModel()
                    message.result = false
                    message.error = "get repo info failed [\(errorModel.statusCode)](\(errorModel.message)"
                    obserable.onNext(message)
   
                } else {

                    let message = ZLPresenterMessageModel()
                    message.result = false
                    message.error = "invalid repo info format"
                    obserable.onNext(message)
                }
            }
            
            if let repoInfoModel = tmpRepoInfo {
                
                self.repoInfoObservable.accept(repoInfoModel)
                let message = ZLPresenterMessageModel()
                message.result = true
                obserable.onNext(message)
            }
            
            return Disposables.create()
            
        }.asObservable()
        
    }
    
    
    func changeBranch(newBranch: String) {
        currentBranchObservable.accept(newBranch)
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
                self.viewerIsWatchObservable.accept(data["isWatch"] ?? false)
            }
        }
    }

    func watchRepo() -> Observable<ZLPresenterMessageModel> {
        
        Observable<ZLPresenterMessageModel>.create { [weak self] observer in
           
            guard let self = self else {
                observer.onNext(ZLPresenterMessageModel())
                return Disposables.create()
            }
            
            if self.viewerIsWatch == false {
                
                ZLRepoServiceShared()?.watchRepo(withFullName: self.repoFullName,
                                                 serialNumber: NSString.generateSerialNumber())
                {[weak self](resultModel: ZLOperationResultModel) in
                    guard let self = self else { return }
                    if resultModel.result {
                        self.viewerIsWatchObservable.accept(true)
                        let message = ZLPresenterMessageModel()
                        message.result = true
                        observer.onNext(message)
                    } else {
                        let message = ZLPresenterMessageModel()
                        message.result = false
                        message.error = ZLLocalizedString(string: "Watch Fail", comment: "")
                        observer.onNext(message)
                    }
                }
                
            } else {
                
                ZLRepoServiceShared()?.unwatchRepo(withFullName: self.repoFullName,
                                                   serialNumber: NSString.generateSerialNumber())
                {[weak self](resultModel: ZLOperationResultModel) in
                    guard let self = self else { return }
                    if resultModel.result {
                        self.viewerIsWatchObservable.accept(false)
                        let message = ZLPresenterMessageModel()
                        message.result = true
                        observer.onNext(message)
                    } else {
                        let message = ZLPresenterMessageModel()
                        message.result = false
                        message.error = ZLLocalizedString(string: "Unwatch Fail", comment: "")
                        observer.onNext(message)
                    }
                }
            }
            
            return Disposables.create()
        }.asObservable()
    
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
                   self.viewerIsStarObservable.accept(data["isStar"] ?? false)
               }
           }
       }

       func starRepo() -> Observable<ZLPresenterMessageModel> {
           
           Observable<ZLPresenterMessageModel>.create { [weak self] observer in
              
               guard let self = self else {
                   observer.onNext(ZLPresenterMessageModel())
                   return Disposables.create()
               }
               
               if self.viewerIsStar == false {
                   
                   ZLRepoServiceShared()?.starRepo(withFullName: self.repoFullName,
                                                    serialNumber: NSString.generateSerialNumber())
                   {[weak self](resultModel: ZLOperationResultModel) in
                       guard let self = self else { return }
                       if resultModel.result {
                           self.viewerIsStarObservable.accept(true)
                           let message = ZLPresenterMessageModel()
                           message.result = true
                           observer.onNext(message)
                       } else {
                           let message = ZLPresenterMessageModel()
                           message.result = false
                           message.error = ZLLocalizedString(string: "Star Fail", comment: "")
                           observer.onNext(message)
                       }
                   }
                   
               } else {
                   
                   ZLRepoServiceShared()?.unstarRepo(withFullName: self.repoFullName,
                                                      serialNumber: NSString.generateSerialNumber())
                   {[weak self](resultModel: ZLOperationResultModel) in
                       guard let self = self else { return }
                       if resultModel.result {
                           self.viewerIsStarObservable.accept(false)
                           let message = ZLPresenterMessageModel()
                           message.result = true
                           observer.onNext(message)
                       } else {
                           let message = ZLPresenterMessageModel()
                           message.result = false
                           message.error = ZLLocalizedString(string: "Unstar Fail", comment: "")
                           observer.onNext(message)
                       }
                   }
               }
               return Disposables.create()
               
           }.asObservable()
       }

       func forkRepo() -> Observable<ZLPresenterMessageModel>  {
           
           Observable<ZLPresenterMessageModel>.create { [weak self] observer in
              
               guard let self = self else {
                   observer.onNext(ZLPresenterMessageModel())
                   return Disposables.create()
               }
             
               ZLRepoServiceShared()?.forkRepository(withFullName: self.repoFullName,
                                                     org: nil,
                                                     serialNumber: NSString.generateSerialNumber())
               {(resultModel: ZLOperationResultModel) in
                   
                   let message = ZLPresenterMessageModel()
                   message.result = resultModel.result
                   observer.onNext(message)
               }
               
               return Disposables.create()
               
           }.asObservable()
       }

}
