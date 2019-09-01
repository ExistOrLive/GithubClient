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
    
    override func awakeFromNib() {
        
        tableView.autoresizingMask = UIViewAutoresizing.init(rawValue: 0)
//        tableView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)
    }

}
