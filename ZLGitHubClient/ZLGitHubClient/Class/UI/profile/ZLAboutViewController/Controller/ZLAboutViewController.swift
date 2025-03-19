//
//  ZLAboutViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/23.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities

@objcMembers class ZLAboutViewController: ZMViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ZLLocalizedString(string: "about", comment: "关于")

        let contentView = ZLAboutContentView()
        self.contentView.addSubview(contentView)
        contentView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })

        let viewModel = ZLAboutViewModel()
        self.zm_addSubViewModel(viewModel)
        
        contentView.zm_fillWithData(data: viewModel)
    }
}
