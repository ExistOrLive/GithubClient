//
//  ZLRepoWorkflowRunsController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/11.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoWorkflowRunsController: ZLBaseViewController {

    var fullName : String = ""
    var workflow_id : String = ""
    var workflowTitle : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = workflowTitle
        
        let githubItemListView : ZLGithubItemListView = ZLGithubItemListView.init()
        githubItemListView.setTableViewHeader()
        githubItemListView.setTableViewFooter()
        self.contentView.addSubview(githubItemListView)
        githubItemListView.snp.makeConstraints { (make) in
             make.edges.equalToSuperview()
        }
        
        let viewModel = ZLRepoWorkflowRunsViewModel()
        self.addSubViewModel(viewModel)
        
        viewModel.bindModel(["fullName":fullName,"workflow_id":workflow_id,"workflowTitle":workflowTitle], andView: githubItemListView)
    }
}
