//
//  ZLSettingView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit



class ZLSettingView: ZLBaseView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet private weak var topViewHeightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib()
    {
        self.topViewHeightConstraint.constant = self.topViewHeightConstraint.constant + ZLStatusBarHeight
       // self.tableView.sectionFooterHeight = 10.0
        self.tableView.register(UINib.init(nibName: "ZLSettingItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLSettingItemTableViewCell")
        self.tableView.register(UINib.init(nibName: "ZLSettingLogoutTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLSettingLogoutTableViewCell")
        
        self.titleLabel.text = ZLLocalizedString(string: "setting", comment: "设置")
    }
    
    func justReloadView()
    {
        self.titleLabel.text = ZLLocalizedString(string: "setting", comment: "设置")
        self.tableView.reloadData()
    }
    

    
}
