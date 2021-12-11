//
//  ZLPinnedRepositoriesCollectionViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/11.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLPinnedRepositoriesCollectionViewCellData: ZLGithubItemCollectionViewCellData {

    private var repo: ZLGithubRepositoryBriefModel
    
    init(repo: ZLGithubRepositoryBriefModel) {
        self.repo = repo
        super.init()
    }
    
    override func getCellReuseIdentifier() -> String{
        return "ZLPinnedRepositoryCollectionViewCell"
    }

    override func onCellSingleTap() {
        guard let fullName = repo.full_name,
              let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: fullName) else {
            return
        }
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ZLPinnedRepositoriesCollectionViewCellData: ZLPinnedRepositoryCollectionViewCellDataSourceAndDelegate {
    
    var avatarUrl: String {
        repo.owner?.avatar_url ?? ""
    }
    var repoName: String {
        repo.full_name ?? ""
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
}
