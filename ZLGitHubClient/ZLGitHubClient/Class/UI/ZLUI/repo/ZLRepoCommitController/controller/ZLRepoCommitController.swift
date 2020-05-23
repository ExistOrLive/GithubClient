//
//  ZLRepoCommitController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoCommitController: ZLBaseViewController {
    
    var repoFullName : String?
    
    var branch : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ZLLocalizedString(string: "commits", comment: "提交")
        
        let itemListView = ZLGithubItemListView.init()
        itemListView.setTableViewFooter()
        itemListView.setTableViewHeader()
        self.contentView.addSubview(itemListView)
        itemListView.snp.makeConstraints ({ (make) in
            make.edges.equalToSuperview()
        })
        
        self.viewModel = ZLRepoCommitViewModel.init(viewController: self)
        viewModel.bindModel(["fullName":repoFullName,"branch":branch], andView: itemListView)
        
    }
}
