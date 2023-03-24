//
//  ZLRepoContributorsController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/8.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI

class ZLRepoContributorsController: ZLBaseViewController {

    var repoFullName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ZLLocalizedString(string: "contributor", comment: "贡献者")

        let itemListView = ZLGithubItemListView.init()
        itemListView.setTableViewHeader()
        self.contentView.addSubview(itemListView)
        itemListView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })

        let viewModel = ZLRepoContributorsViewModel()
        self.addSubViewModel(viewModel)
        viewModel.bindModel(repoFullName, andView: itemListView)

    }

}
