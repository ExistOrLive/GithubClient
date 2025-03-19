//
//  ZLPinnedRepositoriesTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/11.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZMMVVM
import ZLUIUtilities

class ZLPinnedRepositoriesTableViewCellData: ZMBaseTableViewCellViewModel {

    private var repos: [ZLGithubRepositoryBriefModel]

    private var subCellDatas: [ZLPinnedRepositoriesCollectionViewCellData]

    init(repos: [ZLGithubRepositoryBriefModel]) {
        self.repos = repos
        subCellDatas = repos.map({ item in
            let cellData = ZLPinnedRepositoriesCollectionViewCellData(repo: item)
            return cellData
        })
        super.init()
        self.zm_addSubViewModels(subCellDatas)
    }
    
    
    override var zm_cellReuseIdentifier: String {
        return "ZLPinnedRepositoriesTableViewCell"
    }
}

extension ZLPinnedRepositoriesTableViewCellData: ZLPinnedRepositoriesTableViewCellDelegateAndDataSource {
    var cellDatas: [ZLPinnedRepositoryCollectionViewCellDataSourceAndDelegate] {
        subCellDatas
    }
}
