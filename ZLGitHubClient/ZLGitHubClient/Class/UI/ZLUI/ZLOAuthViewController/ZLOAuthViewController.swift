//
//  ZLOAuthViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZTE. All rights reserved.
//

import UIKit

class ZLOAuthViewController: ZLBaseViewController {
    
    var request: URLRequest?

    override func viewDidLoad() {
        super.viewDidLoad();
        
        let baseView: ZLOAuthBaseView? = Bundle.main.loadNibNamed("ZLOAuthBaseView", owner: nil, options: nil)?.first as? ZLOAuthBaseView;
     
        
        if baseView != nil
        {
            baseView!.frame = ZLScreenBounds;
            self.view.addSubview(baseView!);
            
            self.viewModel = ZLOAuthBaseViewModel.init(viewController: self);
            self.viewModel.bindModel(self.request, andView: baseView!);
        }
        else
        {
            NSLog("ZLOAuthBaseView load failed");
        }
        
    }
}
