//
//  ZLIssueTableViewCellDataForViewerIssue.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/23.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZMMVVM

class ZLIssueTableViewCellDataForViewerIssue: ZMBaseTableViewCellViewModel {

    typealias Data = SearchItemQuery.Data.Search.Node.AsIssue

    let data: Data

    private var labels: [(String, String)]?

    init(data: Data) {
        self.data = data
        super.init()
    }

    override var zm_cellReuseIdentifier: String {
        return "ZLIssueTableViewCell"
    }


    override func zm_onCellSingleTap() {
        ZLUIRouter.navigateVC(key: .IssueInfoController,
                              params: ["login": String(data.repository.nameWithOwner.split(separator: "/").first ?? ""),
                                       "repoName": data.repository.name,
                                       "number": data.number])
        
    }
}

extension ZLIssueTableViewCellDataForViewerIssue: ZLIssueTableViewCellDelegate {

    func getIssueRepoFullName() -> String? {
        return data.repository.nameWithOwner
    }

    func getIssueTitleStr() -> String? {
        return data.title
    }

    func isIssueClosed() -> Bool {
        return data.issueState == .closed
    }

    func getIssueAssistStr() -> String? {
        if self.isIssueClosed() {
            return "#\(data.number) \(data.author?.login ?? "") \(ZLLocalizedString(string: "closed at", comment: "")) \(NSDate.getLocalStrSinceCurrentTime(withGithubTime: data.closedAt ?? ""))"
        } else {

             return "#\(data.number) \(data.author?.login ?? "")  \(ZLLocalizedString(string: "opened at", comment: "")) \(NSDate.getLocalStrSinceCurrentTime(withGithubTime: data.createdAt))"
        }
    }

    func getIssueLabels() -> [(String, String)] {
        if self.labels == nil {
            if let nodes = data.labels?.nodes {
                self.labels = []
                for label in nodes {
                    self.labels?.append((label?.name ?? "", label?.color ?? ""))
                }
            }
        }
        return self.labels ?? []
    }

    func onClickIssueRepoFullName() {
        if let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: data.repository.nameWithOwner) {
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func hasLongPressAction() -> Bool {
        if let _ = URL(string: data.url) {
            return true
        } else {
            return false
        }
    }

    func longPressAction(view: UIView) {
        guard let sourceViewController = zm_viewController,
              let url = URL(string: data.url) else { return }
        
        view.showShareMenu(title: url.absoluteString, url: url, sourceViewController: sourceViewController)
    }

}
