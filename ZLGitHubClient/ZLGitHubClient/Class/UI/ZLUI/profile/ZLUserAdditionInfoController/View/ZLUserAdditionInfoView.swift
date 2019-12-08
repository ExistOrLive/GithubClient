//
//  ZLUserAdditionInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

enum ZLUserAdditionInfoViewType : Int
{
    case repositories
    case gists
    case users
}

class ZLUserAdditionInfoView: UIView {

    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var indicatorView: UIView!
    
    
    // 修改类型，同时修改tableviewcell类型
    var viewType : ZLUserAdditionInfoViewType = .repositories
    {
        didSet{
            switch(self.viewType)
            {
            case .repositories:do{
                self.tableView.register(UINib.init(nibName: "ZLRepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLRepositoryTableViewCell")
                }
            case .gists:do{
                self.tableView.register(UINib.init(nibName: "ZLRepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLRepositoryTableViewCell")
                }
            case .users:do{
                self.tableView.register(UINib.init(nibName: "ZLUserTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLUserTableViewCell")
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        self.topViewHeightConstraint.constant = self.topViewHeightConstraint.constant + ZLStatusBarHeight;
        self.headImageView.layer.cornerRadius = 30.0;
        self.headImageView.layer.masksToBounds = true;
        self.tableView.backgroundColor = UIColor.clear;
        
        switch(self.viewType)
        {
        case .repositories:do{
            self.tableView.register(UINib.init(nibName: "ZLRepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLRepositoryTableViewCell")
            }
        case .gists:do{
            self.tableView.register(UINib.init(nibName: "ZLRepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLRepositoryTableViewCell")
            }
        case .users:do{
            self.tableView.register(UINib.init(nibName: "ZLUserTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLUserTableViewCell")
            }
        }
        
    }
    
    
    
}
