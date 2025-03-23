//
//  ZLSimpleRepoTableViewCellModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/3/23.
//  Copyright © 2025 ZM. All rights reserved.
//

import Foundation
import ZMMVVM
import ZLGitRemoteService

class ZLSimpleRepoTableViewCellModel: ZMBaseTableViewCellViewModel {
    
    let repo: ZLGithubRepositoryModel
    
    init(repo: ZLGithubRepositoryModel) {
        self.repo = repo
        super.init()
    }
    
    
    override var zm_cellReuseIdentifier: String {
        return "ZLSimpleRepoTableViewCell"
    }
    
    override var zm_cellHeight: CGFloat {
        60
    }
       
    override func zm_onCellSingleTap() {
        
    }
}
