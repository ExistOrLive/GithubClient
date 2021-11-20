//
//  ZLNotificationController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

@objcMembers class ZLNotificationController: ZLBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ZLLocalizedString(string: "Notification", comment: "通知")
        
        let viewModel = ZLNotificationViewModel.init()
        
        let baseView : ZLNotificationView = ZLNotificationView()
        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.addSubViewModel(viewModel)
        // bind view and viewModel
        viewModel.bindModel(nil, andView: baseView)
        
    }
    
}
