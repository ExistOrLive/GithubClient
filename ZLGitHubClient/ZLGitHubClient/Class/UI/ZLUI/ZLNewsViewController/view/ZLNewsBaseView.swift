//
//  ZLNewsBaseView.swift
//  ZLGitHubClient
//
//  Created by LongMac on 2019/8/30.
//  Copyright © 2019年 ZM. All rights reserved.
//

import UIKit

class ZLNewsBaseView: ZLBaseView {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        bottomViewHeightConstraint.constant = ZLTabBarHeight + AreaInsetHeightBottom
        
        tableView.register(UINib.init(nibName: "ZLNewsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ZLNewsTableViewCell")
//        tableView.register(ZLNewsTableViewCell.self, forCellReuseIdentifier: "ZLNewsTableViewCell")

    }

}
