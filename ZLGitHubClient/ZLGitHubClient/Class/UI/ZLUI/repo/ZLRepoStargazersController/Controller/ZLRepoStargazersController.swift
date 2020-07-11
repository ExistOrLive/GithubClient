//
//  ZLRepoStargazersController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/23.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoStargazersController: ZLBaseViewController {
    
    var repoFullName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ZLLocalizedString(string: "star", comment: "")
        
        let itemListView = ZLGithubItemListView.init()
        itemListView.setTableViewHeader()
        itemListView.setTableViewFooter()
        self.contentView.addSubview(itemListView)
        itemListView.snp.makeConstraints ({ (make) in
            make.edges.equalToSuperview()
        })
        
        self.viewModel = ZLRepoStargazersViewModel.init(viewController: self)
        viewModel.bindModel(repoFullName, andView: itemListView)
    }
}
