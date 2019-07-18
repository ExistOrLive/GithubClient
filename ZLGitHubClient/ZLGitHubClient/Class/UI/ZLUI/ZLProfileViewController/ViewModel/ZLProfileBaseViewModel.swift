//
//  ZLProfileBaseViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/16.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLProfileBaseViewModel: ZLBaseViewModel {
    
    // view
    weak var profileBaseView: ZLProfileBaseView?

    // model
    var currentUserInfo: ZLGithubUserModel?
    
    deinit {
        // 注销监听
        ZLUserServiceModel.shared().unRegisterObserver(self, name: ZLGetCurrentUserInfoResult_Notification)
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if !(targetView is ZLProfileBaseView)
        {
            ZLLog_Info("targetView is invalid")
            return;
        }
        
        self.profileBaseView = targetView as? ZLProfileBaseView;
        self.profileBaseView?.tableView.delegate = self;
        self.profileBaseView?.tableView.dataSource = self;
        
        // 注册监听
        ZLUserServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notication:)), name: ZLGetCurrentUserInfoResult_Notification)
        
        guard let currentUserInfo:ZLGithubUserModel =  ZLUserServiceModel.shared().currentUserInfo() else
        {
            return;
        }
        
        // 设置data
        self.setViewDataForProfileBaseView(model: currentUserInfo, view: self.profileBaseView!)
        
    }
    
    func setViewDataForProfileBaseView(model:ZLGithubUserModel, view:ZLProfileBaseView)
    {
        self.currentUserInfo = model;
        
        view.tableHeaderView?.nameLabel.text = String("\(model.name)(\(model.loginName))")
        view.tableHeaderView?.createTimeLabel.text = String("创建于 \(model.created_at)")
        view.tableHeaderView?.repositoryNum.text = String("\(model.public_repos)")
        view.tableHeaderView?.gistNumLabel.text = String("\(model.public_gists)")
        view.tableHeaderView?.followersNumLabel.text = String("\(model.followers)")
        view.tableHeaderView?.followingNumLabel.text = String("\(model.following)")
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


// MARK: onNotificationArrived
extension ZLProfileBaseViewModel
{
    @objc func onNotificationArrived(notication: Notification)
    {
        ZLLog_Info("notificaition[\(notication) arrived]")
        
        switch notication.name
        {
        case ZLGetCurrentUserInfoResult_Notification: do{
            
            guard let model: ZLGithubUserModel = notication.params as? ZLGithubUserModel else
            {
                ZLLog_Info("notificaition.params is nil]")
                return;
            }
            
            // 更新UI
            self.setViewDataForProfileBaseView(model: model, view: self.profileBaseView!);
            
            }
        default:
            break;
        }
        
    }
}



