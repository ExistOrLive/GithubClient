//
//  ZLExploreBaseView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objcMembers class ZLExploreBaseView: UIView {

    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.topViewHeightConstraint.constant = self.topViewHeightConstraint.constant + ZLStatusBarHeight
        self.searchButton.layer.cornerRadius = 3.0;
        self.justReloadView()
    }
    
    @objc func addMainView(mainView : UIView)
    {
        self.addSubview(mainView)
        
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp_bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func justReloadView()
    {
        self.searchButton.setTitle(ZLLocalizedString(string: "Search", comment: "搜索"), for: .normal)
    }
    
    
    
}
