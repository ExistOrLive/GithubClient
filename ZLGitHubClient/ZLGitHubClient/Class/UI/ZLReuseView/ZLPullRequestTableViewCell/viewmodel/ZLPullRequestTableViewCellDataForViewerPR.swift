//
//  ZLPullRequestTableViewCellDataForViewerPR.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/12/11.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLPullRequestTableViewCellDataForViewerPR: ZLGithubItemTableViewCellData {

    let data: SearchItemQuery.Data.Search.Node.AsPullRequest

    init(data: SearchItemQuery.Data.Search.Node.AsPullRequest) {
        self.data = data
        super.init()
    }

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let cell: ZLPullRequestTableViewCell = targetView as? ZLPullRequestTableViewCell else {
            return
        }
        cell.fillWithData(data: self)
    }

    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }

    override func getCellReuseIdentifier() -> String {
        return "ZLPullRequestTableViewCell"
    }

    override func onCellSingleTap() {

        if let url = URL(string: self.data.url) {
            if url.pathComponents.count >= 5 && url.pathComponents[3] == "pull" {
                ZLUIRouter.navigateVC(key: ZLUIRouter.PRInfoController,
                                      params: ["login": url.pathComponents[1],
                                               "repoName": url.pathComponents[2],
                                               "number": Int(url.pathComponents[4]) ?? 0])
            } else {
                ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,
                                      params: ["requestURL": url])
            }
        }
    }
}

extension ZLPullRequestTableViewCellDataForViewerPR: ZLPullRequestTableViewCellDelegate {

    func onClickPullRequestRepoFullName() {
        if let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: data.repository.nameWithOwner) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func getPullRequestRepoFullName() -> String? {
        return data.repository.nameWithOwner
    }

    func getPullRequestTitle() -> String? {
        return self.data.title
    }

    func getPullRequestAssistInfo() -> String? {
        if self.data.prState == .open {
            let assitInfo = "#\(self.data.number) \(self.data.author?.login ?? "") \(ZLLocalizedString(string: "created at", comment: "创建于")) \(NSDate.getLocalStrSinceCurrentTime(withGithubTime: self.data.createdAt))"
            return assitInfo
        } else {
            if let mergedAt = self.data.mergedAt {
                let assitInfo = "#\(self.data.number) \(self.data.author?.login ?? "") \(ZLLocalizedString(string: "merged at", comment: "合并于")) \(NSDate.getLocalStrSinceCurrentTime(withGithubTime: mergedAt))"
                return assitInfo
            }

            if let closedAt = self.data.closedAt {
                let assitInfo = "#\(self.data.number) \(self.data.author?.login ?? "") \(ZLLocalizedString(string: "closed at", comment: "关闭于")) \(NSDate.getLocalStrSinceCurrentTime(withGithubTime: closedAt))"
                return assitInfo
            }

            return ""
        }
    }

    func getPullRequestState() -> ZLGithubPullRequestState {
        switch self.data.prState {
        case .closed:
            return .closed
        case .merged:
            return .merged
        case .open:
            return .open
        default:
            return .closed
        }
    }

    func isPullRequestMerged() -> Bool {
        return self.data.mergedAt != nil
    }
}
