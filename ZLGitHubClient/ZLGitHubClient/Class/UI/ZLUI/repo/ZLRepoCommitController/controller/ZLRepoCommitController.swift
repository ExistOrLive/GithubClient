//
//  ZLRepoCommitController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoCommitController: ZLBaseViewController {
    
    var fullName : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemListView = ZLGithubItemListView.init()
        self.contentView.addSubview(itemListView)
        itemListView.snp.makeConstraints ({ (make) in
            make.edges.equalToSuperview()
        })
        
        self.viewModel = ZLRepoCommitViewModel.init(viewController: self)
        viewModel.bindModel(fullName, andView: itemListView)
        
    }
}
