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
        
        guard let contentView : ZLAboutContentView = Bundle.main.loadNibNamed("ZLAboutContentView", owner: nil, options: nil)?.first as? ZLAboutContentView else{
            return
        }
        self.contentView.addSubview(contentView);
    }
}
