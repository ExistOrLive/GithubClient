//
//  ZLSearchRecordView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSearchRecordView: ZLBaseView {
 
    @IBOutlet weak var tableView: UITableView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.register(UINib.init(nibName: "ZLSearchRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLSearchRecordTableViewCell")
    }
    
}
