//
//  ZLLoginViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import WebKit

class ZLLoginViewController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginView: ZLLoginBaseView? = Bundle.main.loadNibNamed("ZLLoginBaseView", owner: nil, options: nil)?.first as? ZLLoginBaseView;
        loginView?.frame = ZLScreenBounds;

        if loginView != nil
        {
            self.view.addSubview(loginView!);
            let viewModel = ZLLoginViewModel()
            self.addSubViewModel(viewModel)
            viewModel.bindModel(nil, andView: loginView!);
        }
        else
        {
            NSLog("ZLLoginView load failed");
        }
    }
    
}
