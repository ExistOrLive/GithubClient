//
//  ZLRepoTableViewCellDataForTopRepoQuery.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/24.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService

class ZLRepoTableViewCellDataForTopRepoQuery: ZLGithubItemTableViewCellData {

    var data: ViewerTopRepositoriesQuery.Data.Viewer.TopRepository.Node

    // view
    weak var cell: ZLRepositoryTableViewCell?

    init(data: ViewerTopRepositoriesQuery.Data.Viewer.TopRepository.Node) {
        self.data = data
        super.init()
    }

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let cell: ZLRepositoryTableViewCell = targetView as? ZLRepositoryTableViewCell else {
            return
        }
        cell.fillWithData(data: self)
        self.cell = cell
    }

    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }

    override func getCellReuseIdentifier() -> String {
        return "ZLRepositoryTableViewCell"
    }

    override func onCellSingleTap() {
        if let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: data.nameWithOwner) {
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ZLRepoTableViewCellDataForTopRepoQuery: ZLRepositoryTableViewCellDelegate {

    func onRepoAvaterClicked() {
        if let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName: data.owner.login) {
            userInfoVC.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
        }
    }

    func getOwnerAvatarURL() -> String? {
        return self.data.owner.avatarUrl
    }

    func getRepoFullName() -> String? {
        return self.data.nameWithOwner
    }

    func getRepoName() -> String? {
        return self.data.name
    }

    func getOwnerName() -> String? {
        return self.data.owner.login
    }

    func getRepoMainLanguage() -> String? {
        return self.data.primaryLanguage?.name
    }

    func getRepoDesc() -> String? {
        return self.data.description
    }

    func isPriva() -> Bool {
        return self.data.isPrivate
    }
    func starNum() -> Int {
        return self.data.stargazerCount
    }

    func forkNum() -> Int {
        return self.data.forkCount
    }

    func hasLongPressAction() -> Bool {
        true
    }

    func longPressAction(view: UIView) {
        guard let url = URL(string: data.url),
              let vc = viewController else {
                  return
              }

        view.showShareMenu(title: data.url, url: url, sourceViewController: vc)
    }

}
