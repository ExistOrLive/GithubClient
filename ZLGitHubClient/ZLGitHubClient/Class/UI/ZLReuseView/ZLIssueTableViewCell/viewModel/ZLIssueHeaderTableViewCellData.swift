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

class ZLIssueHeaderTableViewCellData: ZMBaseTableViewCellViewModel {

    var data: IssueInfoQuery.Data

    init(data: IssueInfoQuery.Data) {
        self.data = data
        super.init()
    }
    
//    func update(data: IssueInfoQuery.Data) {
//        self.data = data
//    }

    override var zm_cellReuseIdentifier: String {
        return "ZLIssueHeaderTableViewCell"
    }
}

extension ZLIssueHeaderTableViewCellData: ZLIssueHeaderTableViewCellDelegate {

    func getIssueAuthorLogin() -> String {
        data.repository?.owner.login ?? ""
    }
    
    func getIssueAuthorAvatarURL() -> String {
        return data.repository?.owner.avatarUrl ?? ""
    }

    func getIssueRepoFullName() -> NSAttributedString {
        let text = NSMutableAttributedString(string: data.repository?.nameWithOwner ?? "",
                                             attributes: [.foregroundColor: ZLRawLabelColor(name: "ZLLabelColor1"),
                                                          .font: UIFont.zlMediumFont(withSize: 14)])

        text.yy_setTextHighlight(NSRange(location: 0,
                                         length: data.repository?.nameWithOwner.count ?? 0),
                                 color: ZLRawLabelColor(name: "ZLLabelColor1"),
                                 backgroundColor: ZLRawLabelColor(name: "ZLLabelColor1")) { [weak self](_, _, _, _) in

            if let fullName = self?.data.repository?.nameWithOwner, let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: fullName) {
                self?.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return text
    }

    func getIssueNumber() -> Int {
        return data.repository?.issue?.number ?? 0
    }

    func getIssueState() -> String {
        return data.repository?.issue?.state.rawValue ?? ""
    }

    func getIssueTitle() -> String {
        return data.repository?.issue?.title ?? ""
    }

    func onIssueAvatarClicked() {
        if let name = data.repository?.owner.login, let vc = ZLUIRouter.getUserInfoViewController(loginName: name) {
            self.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
