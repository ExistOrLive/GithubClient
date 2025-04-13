//
//  ZLIssueHeaderTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/16.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLBaseExtension
import ZLGitRemoteService
import ZMMVVM

class ZLDiscussionHeaderTableViewCellData: ZMBaseTableViewCellViewModel {

    var data: DiscussionInfoQuery.Data.Repository.Discussion

    init(data: DiscussionInfoQuery.Data.Repository.Discussion) {
        self.data = data
        super.init()
    }
    

    override var zm_cellReuseIdentifier: String {
        return "ZLDiscussionHeaderTableViewCell"
    }
}

extension ZLDiscussionHeaderTableViewCellData: ZLDiscussionHeaderTableViewCellDelegate {
   
    var title: String {
        data.title
    }
    
    var category: String {
        data.category.name
    }
    
    var categoryEmoji: String {
        data.category.emoji
    }
    
    func getAuthorLogin() -> String {
        data.repository.owner.login
    }
    
    func getAuthorAvatarURL() -> String {
        data.repository.owner.avatarUrl
    }
    
    func getRepoFullName() -> NSAttributedString {
        let text = NSMutableAttributedString(string: data.repository.nameWithOwner,
                                             attributes: [.foregroundColor: ZLRawLabelColor(name: "ZLLabelColor1"),
                                                          .font: UIFont.zlMediumFont(withSize: 14)])

        text.yy_setTextHighlight(NSRange(location: 0,
                                         length: data.repository.nameWithOwner.count ?? 0),
                                 color: ZLRawLabelColor(name: "ZLLabelColor1"),
                                 backgroundColor: ZLRawLabelColor(name: "ZLLabelColor1")) { [weak self](_, _, _, _) in

            if let fullName = self?.data.repository.nameWithOwner, let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: fullName) {
                self?.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return text
    }
    
    func getDiscussionNumber() -> Int {
        data.number
    }
    
    func onAvatarClicked() {
        let name = data.repository.owner.login
        if let vc = ZLUIRouter.getUserInfoViewController(loginName: name) {
            self.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
