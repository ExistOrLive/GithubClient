//
//  ZLPullRequestTableViewCellDataForViewerPR.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/12/11.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZMMVVM

class ZLPullRequestTableViewCellDataForViewerPR: ZMBaseTableViewCellViewModel {

    let data: SearchItemQuery.Data.Search.Node.AsPullRequest

    init(data: SearchItemQuery.Data.Search.Node.AsPullRequest) {
        self.data = data
        super.init()
    }

    override var zm_cellReuseIdentifier: String {
        return "ZLPullRequestTableViewCell"
    }
    

    override func zm_onCellSingleTap() {

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
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
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
