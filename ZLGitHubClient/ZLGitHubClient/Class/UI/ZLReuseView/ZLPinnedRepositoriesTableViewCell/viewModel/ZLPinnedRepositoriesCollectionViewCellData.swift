//
//  ZLPinnedRepositoriesCollectionViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/11.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZMMVVM

class ZLPinnedRepositoriesCollectionViewCellData: ZMBaseViewModel {

    private var repo: ZLGithubRepositoryBriefModel

    init(repo: ZLGithubRepositoryBriefModel) {
        self.repo = repo
        super.init()
    }
}

extension ZLPinnedRepositoriesCollectionViewCellData: ZLPinnedRepositoryCollectionViewCellDataSourceAndDelegate {
    
    func getCellReuseIdentifier() -> String {
        return "ZLPinnedRepositoryCollectionViewCell"
    }

    func onCellSingleTap() {
        guard let fullName = repo.full_name,
              let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: fullName) else {
            return
        }
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }

    var avatarUrl: String {
        repo.owner?.avatar_url ?? ""
    }
    var repoName: String {
        repo.name ?? ""
    }
    var ownerName: String {
        repo.owner?.loginName ?? ""
    }
    var language: String {
        repo.language ?? ""
    }
    var desc: String {
        repo.desc_Repo ?? ""
    }
    var forkNum: Int {
        repo.forks_count
    }
    var starNum: Int {
        repo.stargazers_count
    }

    var isPrivate: Bool {
        repo.isPriva
    }
}
