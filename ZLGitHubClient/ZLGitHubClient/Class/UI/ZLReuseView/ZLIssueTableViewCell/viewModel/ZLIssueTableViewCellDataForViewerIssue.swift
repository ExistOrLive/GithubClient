//
//  ZLIssueTableViewCellDataForViewerIssue.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/23.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLIssueTableViewCellDataForViewerIssue: ZLGithubItemTableViewCellData {

    typealias Data = SearchItemQuery.Data.Search.Node.AsIssue

    let data: Data

    private var labels: [(String, String)]?

    init(data: Data) {
        self.data = data
        super.init()
    }

    override func getCellReuseIdentifier() -> String {
        return "ZLIssueTableViewCell"
    }

    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }

    override func onCellSingleTap() {
        ZLUIRouter.navigateVC(key: ZLUIRouter.IssueInfoController,
                              params: ["login": String(data.repository.nameWithOwner.split(separator: "/").first ?? ""),
                                       "repoName": data.repository.name,
                                       "number": data.number])

    }

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let cell: ZLIssueTableViewCell = targetView as? ZLIssueTableViewCell else {
            return
        }
        cell.fillWithData(cellData: self)
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
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
