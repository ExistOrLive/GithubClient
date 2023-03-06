//
//  ZLLoginViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import WebKit
import ZLBaseUI

class ZLLoginViewController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.addSubview(loginView)
        loginView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let viewModel = ZLLoginViewModel()
        self.addSubViewModel(viewModel)
        viewModel.bindModel(nil, andView: loginView)
    }
    
    lazy var loginView: ZLLoginBaseView = {
       return ZLLoginBaseView()
    }()

}
