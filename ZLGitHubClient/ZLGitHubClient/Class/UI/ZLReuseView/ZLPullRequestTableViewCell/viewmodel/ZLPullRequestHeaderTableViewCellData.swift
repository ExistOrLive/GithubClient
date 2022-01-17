//
//  ZLPullRequestHeaderTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/24.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLPullRequestHeaderTableViewCellData: ZLGithubItemTableViewCellData {

    typealias Data = PrInfoQuery.Data

    let data: Data

    init(data: Data) {
        self.data = data
        super.init()
    }

    override func getCellReuseIdentifier() -> String {
        return "ZLPullRequestHeaderTableViewCell"
    }

    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }

    override func clearCache() {

    }

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        super.bindModel(targetModel, andView: targetView)
        if let cell: ZLPullRequestHeaderTableViewCell = targetView as? ZLPullRequestHeaderTableViewCell {
            cell.fillWithData(data: self)
        }
    }
}

extension ZLPullRequestHeaderTableViewCellData: ZLPullRequestHeaderTableViewCellDelegate {

    func getPRAuthorAvatarURL() -> String {
        data.repository?.owner.avatarUrl ?? ""
    }

    func getPRRepoFullName() -> NSAttributedString {
        let text = NSMutableAttributedString(string: data.repository?.nameWithOwner ?? "",
                                             attributes: [.foregroundColor: ZLRawLabelColor(name: "ZLLabelColor1"),
                                                          .font: UIFont.zlMediumFont(withSize: 14)])

        text.yy_setTextHighlight(NSRange(location: 0, length: data.repository?.nameWithOwner.count ?? 0),
                                 color: ZLRawLabelColor(name: "ZLLabelColor1"),
                                 backgroundColor: ZLRawLabelColor(name: "ZLLabelColor1")) { [weak self](_, _, _, _) in

            if let fullName = self?.data.repository?.nameWithOwner, let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: fullName) {
                self?.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return text
    }
    func getPRNumber() -> Int {
        data.repository?.pullRequest?.number ?? 0
    }

    func getPRState() -> String {
        data.repository?.pullRequest?.state.rawValue ?? ""
    }

    func getPRTitle() -> String {
        data.repository?.pullRequest?.title ?? ""
    }

    func getCommitNumber() -> Int {
        data.repository?.pullRequest?.commits.totalCount ?? 0
    }

    func getFileChangedNumber() -> Int {
        data.repository?.pullRequest?.changedFiles ?? 0
    }

    func getAdditionFileNumber() -> Int {
        data.repository?.pullRequest?.additions ?? 0
    }
    func getDeletedFileNumber() -> Int {
        data.repository?.pullRequest?.deletions ?? 0
    }

    func getHeaderRef() -> String {
        " \(data.repository?.pullRequest?.headRepositoryOwner?.login ?? "") : \(data.repository?.pullRequest?.headRefName ?? "") "
    }
    func getBaseRef() -> String {
        " \(data.repository?.pullRequest?.baseRepository?.owner.login ?? "") : \(data.repository?.pullRequest?.baseRefName ?? "") "
    }

    func onAvatarButtonClicked() {
        if let name = data.repository?.owner.login, let vc = ZLUIRouter.getUserInfoViewController(loginName: name) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func onFileButtonClicked() {

        if let url = URL(string: "\(data.repository?.pullRequest?.url ?? "")/files"), let vc = ZLUIRouter.getVC(key: ZLUIRouter.WebContentController, params: ["requestURL": url]) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func onCommitButtonClicked() {

        if let url = URL(string: "\(data.repository?.pullRequest?.url ?? "")/commits"), let vc = ZLUIRouter.getVC(key: ZLUIRouter.WebContentController, params: ["requestURL": url]) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
