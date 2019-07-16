//
//  ZLProfileBaseViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/16.
//  Copyright © 2019 ZTE. All rights reserved.
//

import UIKit

class ZLProfileBaseViewModel: ZLBaseViewModel {
    
    weak var profileBaseView: ZLProfileBaseView?

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if !(targetView is ZLProfileBaseView)
        {
            return;
        }
        
        self.profileBaseView = targetView as? ZLProfileBaseView;
        self.profileBaseView?.tableView.delegate = self;
        self.profileBaseView?.tableView.dataSource = self;

    }
    
}

extension ZLProfileBaseViewModel: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ZLProfileBaseView.profileItemsArray[section].count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ZLProfileBaseView.profileItemsArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let tableViewCell:ZLProfileTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "ZLProfileTableViewCell", for: indexPath) as! ZLProfileTableViewCell;
        
        switch  ZLProfileBaseView.profileItemsArray[indexPath.section][indexPath.row]{
        case ZLProfileItemType.company:do {
            tableViewCell.itemTitleLabel.text = "公司"
            }
        case ZLProfileItemType.location:do {
            tableViewCell.itemTitleLabel.text = "地址"
            }
        case ZLProfileItemType.email:do {
            tableViewCell.itemTitleLabel.text = "邮箱"
            }
        case ZLProfileItemType.blog:do {
            tableViewCell.itemTitleLabel.text = "博客"
            }
        case ZLProfileItemType.setting:do {
            tableViewCell.itemTitleLabel.text = "设置"
            }
        case ZLProfileItemType.aboutMe:do {
            tableViewCell.itemTitleLabel.text = "关于"
            }
        case ZLProfileItemType.feedback:do {
            tableViewCell.itemTitleLabel.text = "反馈"
            }
        }
        
        if indexPath.row == (ZLProfileBaseView.profileItemsArray[indexPath.section].count - 1)
        {
            tableViewCell.singleLineView.isHidden = true;
        }
        else
        {
            tableViewCell.singleLineView.isHidden = false;
        }
        
        return tableViewCell;
    }
}



