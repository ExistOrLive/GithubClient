//
//  ZLRepoWorkflowsController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoWorkflowsController: ZLBaseViewController {
    
    var repoFullName : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Workflow"
        
        self.viewModel = ZLRepoWorkflowsViewModel.init(viewController: self)
        
        let githubItemListView : ZLGithubItemListView = ZLGithubItemListView.init()
        githubItemListView.setTableViewFooter()
        githubItemListView.setTableViewHeader()
        self.contentView.addSubview(githubItemListView)
        githubItemListView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.viewModel.bindModel(repoFullName, andView: githubItemListView)
    }
}
