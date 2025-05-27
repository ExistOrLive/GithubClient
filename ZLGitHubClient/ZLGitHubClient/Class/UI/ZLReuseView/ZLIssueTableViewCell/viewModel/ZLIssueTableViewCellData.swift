//
//  ZLIssueTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/14.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZMMVVM
import ZLGitRemoteService


class ZLIssueTableViewCellData: ZMBaseTableViewCellViewModel {

    let issueModel: ZLGithubIssueModel

    init(issueModel: ZLGithubIssueModel) {
        self.issueModel = issueModel
        super.init()
    }

    override var zm_cellReuseIdentifier: String {
        return "ZLIssueTableViewCell"
    }

    override func zm_onCellSingleTap() {
        // https://github.com/MengAndJie/GithubClient/issues/22
        if let url = URL(string: issueModel.html_url) {
            ZLUIRouter.openURL(url: url)
        }
    }
}

extension ZLIssueTableViewCellData: ZLIssueTableViewCellDelegate {

    func getIssueRepoFullName() -> String? {
        if let url = URL(string: issueModel.html_url) {
            if url.pathComponents.count >= 5 {
                return "\(url.pathComponents[1])/\(url.pathComponents[2])"
            }
        }
        return nil
    }

    func getIssueTitleStr() -> String? {
        return self.issueModel.title
    }

    func isIssueClosed() -> Bool {
        return self.issueModel.state == .closed
    }

    func getIssueAssistStr() -> String? {

        if self.isIssueClosed(),
           let closed_at = self.issueModel.closed_at {

            return "#\(self.issueModel.number) \(self.issueModel.user.loginName ?? "") \(ZLLocalizedString(string: "closed at", comment: "")) \((closed_at as NSDate).dateLocalStrSinceCurrentTime())"

        } else if let created_at = self.issueModel.created_at {

             return "#\(self.issueModel.number) \(self.issueModel.user.loginName ?? "")  \(ZLLocalizedString(string: "opened at", comment: "")) \(( created_at as NSDate).dateLocalStrSinceCurrentTime())"
        }

        return nil
    }

    func getIssueLabels() -> [(String, String)] {

        var labelArray: [(String, String)] = []

        for label in self.issueModel.labels {
            labelArray.append((label.name, label.color))
        }

        return labelArray
    }

    func onClickIssueRepoFullName() {
        if let url = URL(string: issueModel.html_url) {
            if url.pathComponents.count >= 5 {
                if let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: "\(url.pathComponents[1])/\(url.pathComponents[2])") {
                    zm_viewController?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func hasLongPressAction() -> Bool {
        if let _ = URL(string: issueModel.html_url) {
            return true
        } else {
            return false
        }
    }

    func longPressAction(view: UIView) {
        guard let sourceViewController = zm_viewController,
              let url = URL(string: issueModel.html_url) else { return }
        
        view.showShareMenu(title: url.absoluteString, url: url, sourceViewController: sourceViewController)
    }
}
