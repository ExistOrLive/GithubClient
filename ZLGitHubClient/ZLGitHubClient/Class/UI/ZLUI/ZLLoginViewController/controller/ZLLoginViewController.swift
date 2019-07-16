//
//  ZLLoginViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZTE. All rights reserved.
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
            self.viewModel = ZLLoginViewModel(viewController: self);
            self.viewModel.bindModel(nil, andView: loginView!);
        }
        else
        {
            NSLog("ZLLoginView load failed");
        }
    }
    
}
