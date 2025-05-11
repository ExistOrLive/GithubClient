//
//  Untitled.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/11.
//  Copyright © 2025 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService
import ZMMVVM

class ZLCommitInfoHeaderCellData: ZMBaseTableViewCellViewModel {
    
    let model: ZLGithubCommitModel
    
    init(model: ZLGithubCommitModel) {
        self.model = model
        super.init()
    }
    

    override var zm_cellReuseIdentifier: String {
        return "ZLCommitInfoHeaderCell"
    }
}

extension ZLCommitInfoHeaderCellData: ZLCommitInfoHeaderCellSourceAndDelegate {
    
    var title: String {
        model.commit_message
    }
    

    var authorLogin: String {
        return self.model.committer?.loginName ?? ""
    }
    
    var authorAvator: String {
        return self.model.committer?.avatar_url ?? ""
    }
    
    var commitTime: String {
        guard let date: NSDate = self.model.commit_at as NSDate? else {
            return ""
        }
        return date.dateLocalStrSinceCurrentTime()
    }
    
    var modifyStr: NSAttributedString {
        
        let str = "已修改\(model.files.count)个文件\n"
            .asMutableAttributedString()
            .font(.zlRegularFont(withSize: 13))
            .foregroundColor(.label(withName: "ZLLabelColor1"))
        
        if let additions = model.stats?.additions ,
           additions > 0 {
            str.append("\(additions)"
                .asMutableAttributedString()
                .font(.zlMediumFont(withSize: 13))
                .foregroundColor(.label(withName: "addColor")))
            str.append(" 个添加 "
                .asMutableAttributedString()
                .font(.zlRegularFont(withSize: 13))
                .foregroundColor(.label(withName: "ZLLabelColor1")))
        }
        
        if let deletions = model.stats?.deletions ,
           deletions > 0 {
            str.append("\(deletions)"
                .asMutableAttributedString()
                .font(.zlMediumFont(withSize: 13))
                .foregroundColor(.label(withName: "deleteColor")))
            str.append(" 个删除"
                .asMutableAttributedString()
                .font(.zlRegularFont(withSize: 13))
                .foregroundColor(.label(withName: "ZLLabelColor1")))
        }
        
        return str
    }
    
    func onAuthorAvatarAction() {
        if let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName: authorLogin) {
            zm_viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
        }
    }
    
    
}
