//
//  ZLAboutViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/23.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objcMembers class ZLAboutViewController: ZLBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ZLLocalizedString(string: "about", comment: "关于")
        
        self.viewModel = ZLAboutViewModel(viewController: self)
        
        guard let contentView : ZLAboutContentView = Bundle.main.loadNibNamed("ZLAboutContentView", owner: self.viewModel, options: nil)?.first as? ZLAboutContentView else{
            return
        }
        self.contentView.addSubview(contentView);
        contentView.snp_makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        self.viewModel.bindModel(nil, andView: self.contentView)
    }
}
