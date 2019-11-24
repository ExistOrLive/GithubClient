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
        tableView.register(UINib.init(nibName: "ZLNewsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ZLNewsTableViewCell")
    }

}
