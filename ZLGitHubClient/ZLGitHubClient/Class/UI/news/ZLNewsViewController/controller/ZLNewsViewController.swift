//
//  ZLNewsViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/21.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI

class ZLNewsViewController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        title = ZLLocalizedString(string: "news", comment: "动态")
        contentView.addSubview(githubItemListView)
        githubItemListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubViewModel(viewModel)
        viewModel.bindModel(nil, andView: githubItemListView)
    }
    
    // MARK: Lazy View
    private var githubItemListView: ZLGithubItemListView = {
        let view = ZLGithubItemListView()
        view.setTableViewFooter()
        view.setTableViewHeader()
        return view 
    }()
    
    private var viewModel: ZLNewsViewModel = {
        ZLNewsViewModel()
    }()
}
