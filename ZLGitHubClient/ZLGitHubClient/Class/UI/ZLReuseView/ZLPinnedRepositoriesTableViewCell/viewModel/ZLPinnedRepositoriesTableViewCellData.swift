//
//  ZLPinnedRepositoriesTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/11.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLPinnedRepositoriesTableViewCellData: ZLGithubItemTableViewCellData {

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
    }

    override func update(_ targetModel: Any?) {
        guard let repos = targetModel as? [ZLGithubRepositoryBriefModel] else {
            return
        }
        for subViewModel in self.subViewModels {
            subViewModel.removeFromSuperViewModel()
        }

        self.repos = repos
        subCellDatas = repos.map({ item in
            let cellData = ZLPinnedRepositoriesCollectionViewCellData(repo: item)
            return cellData
        })
        self.addSubViewModels(subCellDatas)
    }

    override func getCellReuseIdentifier() -> String {
        return "ZLPinnedRepositoriesTableViewCell"
    }

    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ZLPinnedRepositoriesTableViewCellData: ZLPinnedRepositoriesTableViewCellDelegateAndDataSource {
    var cellDatas: [ZLPinnedRepositoryCollectionViewCellDataSourceAndDelegate] {
        subCellDatas
    }

}
