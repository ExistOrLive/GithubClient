//
//  ZLOAuthViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLOAuthViewController: ZLBaseViewController {
    
    var loginProcessModel : ZLLoginProcessModel?

    override func viewDidLoad() {
        super.viewDidLoad();
        
        let baseView: ZLWebContentView? = Bundle.main.loadNibNamed("ZLWebContentView", owner: nil, options: nil)?.first as? ZLWebContentView;
        baseView?.title = ZLLocalizedString(string: "login", comment: "登陆")
        baseView?.additionButton.isHidden = true
        
        if baseView != nil
        {
            baseView!.frame = ZLScreenBounds;
            self.view.addSubview(baseView!);
            
            self.viewModel = ZLOAuthBaseViewModel.init(viewController: self);
            self.viewModel.bindModel(self.loginProcessModel, andView: baseView!);
        }
        else
        {
            NSLog("ZLOAuthBaseView load failed");
        }
        
    }
}
