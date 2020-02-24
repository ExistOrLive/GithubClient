//
//  ZLRepoInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLRepoInfoView: ZLBaseView {

    @IBOutlet weak var tableView: UITableView!
    
    var headerView : ZLRepoHeaderInfoView?
    var footerView : ZLRepoFooterInfoView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.register(UINib.init(nibName: "ZLRepoInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLRepoInfoTableViewCell")
        
        let headerView: ZLRepoHeaderInfoView? = Bundle.main.loadNibNamed("ZLRepoHeaderInfoView", owner: nil, options: nil)?.first as? ZLRepoHeaderInfoView
        
        if headerView != nil
        {
            headerView?.autoresizingMask = UIViewAutoresizing.init(rawValue: 0)
            headerView?.frame = CGRect.init(x: 0, y: 0, width: ZLScreenWidth, height: 240)
            self.tableView.tableHeaderView = headerView
            self.headerView = headerView
        }
        
        let footerView:ZLRepoFooterInfoView? = Bundle.main.loadNibNamed("ZLRepoFooterInfoView", owner: nil, options: nil)?.first as? ZLRepoFooterInfoView
        if footerView != nil
        {
            footerView?.autoresizingMask = UIViewAutoresizing.init(rawValue: 0)
            footerView?.frame = CGRect.init(x: 0, y: 0, width: ZLScreenWidth, height: 300)
            self.tableView.tableFooterView = footerView
            self.footerView = footerView
        }
        
        
    }
    
}
