//
//  ZLReleaseInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/11.
//  Copyright © 2025 ZM. All rights reserved.
//

import ZMMVVM
import ZLGitRemoteService

class ZLReleaseInfoViewModel: ZMBaseViewModel {
    
    typealias ReleaseData = RepoReleaseInfoQuery.Data.Repository.Release
    
    let login: String
    let repoName: String
    let tagName: String
    
    var data: ReleaseData?
    
    init(login: String, repoName: String, tagName: String) {
        self.login = login
        self.repoName = repoName
        self.tagName = tagName
        super.init()
    }
    
    func requestReleaseInfoData(callBack: @escaping (Bool, String) -> Void) {
        
        ZLRepoServiceShared()?.getRepoReleaseInfo(withLogin: login,
                                                  repoName: repoName,
                                                  tagName: tagName,
                                                  serialNumber: NSString.generateSerialNumber(),
                                                  completeHandle: { [weak self] resultModel in
            guard let self else { return }
                        
            if resultModel.result,
               let data = resultModel.data as? RepoReleaseInfoQuery.Data {
                self.data = data.repository?.release
                
                callBack(true,"")
            
            } else {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    callBack(false,errorModel.message)
                } else {
                    callBack(false,"")
                }
            }
            
        })
    }
}
