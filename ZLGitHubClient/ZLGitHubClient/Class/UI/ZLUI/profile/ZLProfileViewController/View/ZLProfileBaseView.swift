//
//  ZLProfileBaseView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/15.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

enum ZLProfileItemType: Int{
    case company = 0
    case location
    case email
    case blog
    case setting
    case aboutMe
    case feedback
}

class ZLProfileBaseView: ZLBaseView {

    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var tableHeaderView: ZLProfileHeaderView?
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        self.topViewHeightConstraint.constant = ZLStatusBarHeight
        
        // 设置tableView
        self.tableView.register(UINib.init(nibName: "ZLProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLProfileTableViewCell");
        self.tableView.autoresizingMask = UIView.AutoresizingMask.init(rawValue: 0);
        
        // 设置tableViewHeader
        let tableViewHeader: ZLProfileHeaderView? = Bundle.main.loadNibNamed("ZLProfileHeaderView", owner: self, options: nil)?.first as? ZLProfileHeaderView;
        if tableViewHeader != nil
        {
            tableViewHeader!.autoresizingMask = UIView.AutoresizingMask.init(rawValue: 0);
            tableViewHeader!.frame = CGRect.init(x: 0, y: 0, width: ZLScreenWidth, height: 350);
            tableView.tableHeaderView = tableViewHeader;
            self.tableHeaderView = tableViewHeader;
        }
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0 - 4 * ZLScreenWidth, width:  4 * ZLScreenWidth, height: 4 * ZLScreenWidth))
        view.backgroundColor = UIColor.black
        self.tableView.addSubview(view)
    
    }
}

extension ZLProfileBaseView
{
    static let profileItemsArray = [[ZLProfileItemType.company,
                                     ZLProfileItemType.location,
                                     ZLProfileItemType.email,
                                     ZLProfileItemType.blog],
                                    [ZLProfileItemType.setting,
                                     ZLProfileItemType.aboutMe,
                                     ZLProfileItemType.feedback]]
    
  
}
