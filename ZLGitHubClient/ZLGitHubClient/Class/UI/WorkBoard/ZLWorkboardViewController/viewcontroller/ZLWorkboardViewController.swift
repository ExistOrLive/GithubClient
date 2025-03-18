//
//  ZLWorkboardViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/20.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities

class ZLWorkboardViewController: ZMViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ZLLocalizedString(string: "Workboard", comment: "")

        let baseView = ZLWorkboardBaseView()
        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints({make in
            make.edges.equalToSuperview()
        })

        let viewModel = ZLWorkboardBaseViewModel()
        self.zm_addSubViewModel(viewModel)
        
        baseView.zm_fillWithData(data: viewModel)
    }

}
