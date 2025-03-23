//
//  ZLSearchFixedRepoTableViewCellModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/3/23.
//  Copyright © 2025 ZM. All rights reserved.
//

import Foundation
import ZMMVVM
import ZLGitRemoteService

class ZLSearchFixedRepoTableViewCellModel: ZMBaseTableViewCellViewModel, ZLSimpleRepoTableViewCellDelegate {

    private let repo: ZLGithubRepositoryModel
    
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
        guard let vc = (zm_superViewModel as? ZLEditFixedRepoSearchController) else { return }
        vc.navigationController?.popViewController(animated: false)
        vc.delegate?.onSelectResult(repo: repo)
    }
    
    var owner_login: String {
        repo.owner?.loginName ?? ""
    }
    var owner_avatarURL: String {
        repo.owner?.avatar_url ?? ""
    }
    var full_name: String {
        repo.full_name ?? ""
    }
    var showSingleLineView: Bool {
        true
    }
}

