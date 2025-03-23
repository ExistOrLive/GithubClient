//
//  ZLLoginViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import WebKit
import ZLUIUtilities

class ZLLoginViewController: ZMViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.addSubview(loginView)
        loginView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        loginView.zm_fillWithData(data: loginViewModel)
    }
    
    lazy var loginView: ZLLoginBaseView = {
       return ZLLoginBaseView()
    }()
    
    lazy var loginViewModel: ZLLoginViewModel = {
       let viewModel = ZLLoginViewModel()
        self.zm_addSubViewModel(viewModel)
        return viewModel
    }()

}
