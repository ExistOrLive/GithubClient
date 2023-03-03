//
//  ZLMyEventController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/8.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI

class ZLMyEventController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ZLLocalizedString(string: "My Events", comment: "")

        let baseView: ZLGithubItemListView = ZLGithubItemListView()
        baseView.setTableViewHeader()
        baseView.setTableViewFooter()
        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })

        let viewModel = ZLMyEventBaseViewModel()
        self.addSubViewModel(viewModel)
        viewModel.bindModel(nil, andView: baseView)
    }
}
