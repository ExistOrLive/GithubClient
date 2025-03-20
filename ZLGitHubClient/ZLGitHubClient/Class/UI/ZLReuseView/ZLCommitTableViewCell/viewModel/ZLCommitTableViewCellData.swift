//
//  ZLCommitTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZMMVVM

class ZLCommitTableViewCellData: ZMBaseTableViewCellViewModel {

    let commitModel: ZLGithubCommitModel

     init(commitModel: ZLGithubCommitModel) {
         self.commitModel = commitModel
         super.init()
     }


     override var zm_cellReuseIdentifier: String {
         return "ZLCommitTableViewCell"
     }

    override func zm_onCellSingleTap() {
        if let url = URL(string: self.commitModel.html_url) {
            ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,
                                  params: ["requestURL": url])
        }
    }

}

extension ZLCommitTableViewCellData {
    func getCommiterAvaterURL() -> String? {
        return self.commitModel.committer?.avatar_url
    }

    func getCommiterLogin() -> String {
        return self.commitModel.committer?.loginName ?? ""
    }
    
    func getCommitTitle() -> String? {
        return self.commitModel.commit_message
    }

    func getCommitSha() -> String? {
        return String(self.commitModel.sha.prefix(7))
    }

    func getAssistInfo() -> String? {
        return "\(String(describing: self.commitModel.committer?.loginName ?? "") ) \(ZLLocalizedString(string: "committed", comment: "提交于")) \((self.commitModel.commit_at as NSDate? ?? NSDate()).dateLocalStrSinceCurrentTime() as String) "
    }

}

extension ZLCommitTableViewCellData: ZLCommitTableViewCellDelegate {
}
