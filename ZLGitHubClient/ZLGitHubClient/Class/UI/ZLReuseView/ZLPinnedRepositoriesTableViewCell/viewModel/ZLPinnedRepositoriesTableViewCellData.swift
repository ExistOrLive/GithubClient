//
//  ZLPinnedRepositoriesTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/11.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZLBaseUI
import ZLUIUtilities

class ZLPinnedRepositoriesTableViewCellData: ZLTableViewBaseCellData {

    private var repos: [ZLGithubRepositoryBriefModel]

    private var subCellDatas: [ZLPinnedRepositoriesCollectionViewCellData]

    init(repos: [ZLGithubRepositoryBriefModel]) {
        self.repos = repos
        subCellDatas = repos.map({ item in
            let cellData = ZLPinnedRepositoriesCollectionViewCellData(repo: item)
            return cellData
        })
        super.init()
        self.addSubViewModels(subCellDatas)
        cellReuseIdentifier = "ZLPinnedRepositoriesTableViewCell"
    }
}

extension ZLPinnedRepositoriesTableViewCellData: ZLPinnedRepositoriesTableViewCellDelegateAndDataSource {
    var cellDatas: [ZLPinnedRepositoryCollectionViewCellDataSourceAndDelegate] {
        subCellDatas
    }
}
