//
//  ZLProfileBaseViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/16.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import Foundation

class ZLProfileBaseViewModel: ZLBaseViewModel {
    
    private var serailNumberDic : [String:String] = [:]
    
    // view
    private weak var profileBaseView: ZLProfileBaseView?

    // model
    private var currentUserInfo: ZLGithubUserModel?
    private var myEventModel:[ZLGithubEventModel] = []
    
    deinit {
        self.removeObservers()
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
        self.profileBaseView?.tableHeaderView?.delegate = self;
        
        // 注册监听
        self.addObservers()
    }
    
    override func vcLifeCycle_viewWillAppear() {
        
        super.vcLifeCycle_viewWillAppear()
        
        // 每次界面将要展示时，更新数据
        guard let currentUserInfo:ZLGithubUserModel =  ZLUserServiceModel.shared().currentUserInfo() else
        {
            return;
        }
        
        // 设置data
        self.setViewDataForProfileBaseView(model: currentUserInfo, view: self.profileBaseView!)
        
        self.queryMyEventRequest()
    }
}

extension ZLProfileBaseViewModel
{
    func setViewDataForProfileBaseView(model:ZLGithubUserModel, view:ZLProfileBaseView)
    {
        self.currentUserInfo = model;
        
        view.tableHeaderView?.headImageView.sd_setImage(with: URL.init(string: model.avatar_url), placeholderImage: UIImage.init(named: "default_avatar"));
        view.tableHeaderView?.nameLabel.text = String("\(model.name)(\(model.loginName))")
        
        var dateStr = model.created_at
        if let date: Date = model.createdDate()
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 8 * 60 * 60) // 北京时区
            dateStr = dateFormatter.string(from: date)
        }
        let createdAtStr = ZLLocalizedString(string:"created at", comment: "创建于")
        view.tableHeaderView?.createTimeLabel.text = String("\(createdAtStr) \(dateStr)")
        view.tableHeaderView?.repositoryNum.text = String("\(model.public_repos + model.total_private_repos)")
        view.tableHeaderView?.gistNumLabel.text = String("\(model.public_gists + model.private_gists)")
        view.tableHeaderView?.followersNumLabel.text = String("\(model.followers)")
        view.tableHeaderView?.followingNumLabel.text = String("\(model.following)")
        
        view.tableView.reloadData();
    }
}

// MARK: UITableViewDataSource UITableViewDelegate

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
        tableViewCell.itemContentLabel.text = ""
        tableViewCell.nextImageView.isHidden = true
        
        switch  ZLProfileBaseView.profileItemsArray[indexPath.section][indexPath.row]{
        case ZLProfileItemType.company:do {
            tableViewCell.itemTitleLabel.text = ZLLocalizedString(string:"company", comment: "公司")
            tableViewCell.itemContentLabel.text = self.currentUserInfo?.company
            }
        case ZLProfileItemType.location:do {
            tableViewCell.itemTitleLabel.text = ZLLocalizedString(string:"location", comment: "地址")
            tableViewCell.itemContentLabel.text = self.currentUserInfo?.location
            }
        case ZLProfileItemType.email:do {
            tableViewCell.itemTitleLabel.text = ZLLocalizedString(string:"email", comment: "邮箱")
            tableViewCell.itemContentLabel.text = self.currentUserInfo?.email
            tableViewCell.nextImageView.isHidden = false
            }
        case ZLProfileItemType.blog:do {
            tableViewCell.itemTitleLabel.text = ZLLocalizedString(string:"blog", comment: "博客")
            tableViewCell.itemContentLabel.text = self.currentUserInfo?.blog
            tableViewCell.nextImageView.isHidden = false
            }
        case ZLProfileItemType.setting:do {
            tableViewCell.itemTitleLabel.text = ZLLocalizedString(string:"setting", comment: "设置")
            tableViewCell.nextImageView.isHidden = false
            }
        case ZLProfileItemType.aboutMe:do {
            tableViewCell.itemTitleLabel.text = ZLLocalizedString(string:"about", comment: "关于")
            tableViewCell.nextImageView.isHidden = false
            }
        case ZLProfileItemType.feedback:do {
            tableViewCell.itemTitleLabel.text = ZLLocalizedString(string:"feedback", comment: "反馈")
            tableViewCell.nextImageView.isHidden = false
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch  ZLProfileBaseView.profileItemsArray[indexPath.section][indexPath.row]{
        case ZLProfileItemType.company:
            break;
        case ZLProfileItemType.location:
            break;
        case ZLProfileItemType.email:
            break;
        case ZLProfileItemType.blog:do{
            
            if self.currentUserInfo?.blog == nil
            {
                return
            }
            
            let url:URL? = URL.init(string:self.currentUserInfo!.blog)
            if url == nil
            {
                return;
            }
            
            let vc = ZLWebContentController.init()
            vc.requestURL = url
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        case ZLProfileItemType.setting:do{
            let vc = ZLSettingController.init()
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        case ZLProfileItemType.aboutMe:
            let vc = SYDCentralPivotUIAdapter.getZLAboutViewController()
            if vc != nil{
                vc!.hidesBottomBarWhenPushed = true
                self.viewController?.navigationController?.pushViewController(vc!, animated: true)
            }
            
            break;
        case ZLProfileItemType.feedback: do{
            let vc = ZLFeedbackController.init()
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
            break;
        }
        
    }
}

// MARK: ZLProfileHeaderViewDelegate
extension ZLProfileBaseViewModel : ZLProfileHeaderViewDelegate
{
    func numberOfEvent() -> Int {
        return self.myEventModel.count
    }
    
    func cellDataForEventAtIndex(index: Int) -> ZLProfileEventCollectionViewCellData {
        let eventModel = self.myEventModel[index]
        return ZLProfileEventCollectionViewCellData(data:eventModel)
    }
    
    func onProfileHeaderViewButtonClicked(button: UIButton) {
       
        let type = ZLProfileHeaderViewButtonType.init(rawValue: button.tag)
        
        switch type!
        {
        case .repositories:do{
            let vc = ZLUserAdditionInfoController.init()
            vc.userInfo = self.currentUserInfo
            vc.type = .repositories
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true);
            }
        case .followers:do
        {
            let vc = ZLUserAdditionInfoController.init()
            vc.userInfo = self.currentUserInfo
            vc.type = .followers
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true);
            }
        case .following:do{
            let vc = ZLUserAdditionInfoController.init()
            vc.userInfo = self.currentUserInfo
            vc.type = .following
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true);
            }
        case .gists:do{
            let vc = ZLUserAdditionInfoController.init()
            vc.userInfo = self.currentUserInfo
            vc.type = .gists
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true);
            }
        case .editProfile:do{
            let vc = ZLEditProfileController.init()
            vc.userInfoModel = self.currentUserInfo
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true);
        }
        case .allUpdate:do{
            let vc = ZLMyEventController.init()
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        }
    }
}

// MARK: request

extension ZLProfileBaseViewModel
{
    static let queryMyEventRequestKey = "queryMyEventRequestKey"
    
    func queryMyEventRequest()
    {
        let serialNumber = NSString.generateSerialNumber()
        self.serailNumberDic[ZLProfileBaseViewModel.queryMyEventRequestKey] = serialNumber
        
        ZLEventServiceModel.shareInstance()?.getMyEventsWithpage(1, per_page: 10, serialNumber: serialNumber)
    }
}

// MARK: onNotificationArrived
extension ZLProfileBaseViewModel
{
    func addObservers()
    {
        ZLUserServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notication:)), name: ZLGetCurrentUserInfoResult_Notification)
        ZLEventServiceModel.shareInstance()?.registerObserver(self, selector: #selector(onNotificationArrived(notication:)), name: ZLGetMyEventResult_Notification)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notication:)), name: ZLLanguageTypeChange_Notificaiton, object: nil)
    }
    
    func removeObservers()
    {
        // 注销监听
        ZLUserServiceModel.shared().unRegisterObserver(self, name: ZLGetCurrentUserInfoResult_Notification)
        ZLEventServiceModel.shareInstance()?.unRegisterObserver(self, name: ZLGetMyEventResult_Notification)
        NotificationCenter.default.removeObserver(self, name: ZLLanguageTypeChange_Notificaiton, object: nil)
    }
    
    
    @objc func onNotificationArrived(notication: Notification)
    {
        ZLLog_Info("notificaition[\(notication) arrived]")
        
        switch notication.name
        {
        case ZLGetCurrentUserInfoResult_Notification: do{
            
            guard let resultModel: ZLOperationResultModel = notication.params as? ZLOperationResultModel else
            {
                ZLLog_Info("notificaition.params is nil]")
                return;
            }
            
            guard let model: ZLGithubUserModel = resultModel.data as? ZLGithubUserModel else
            {
                ZLLog_Info("the data of ZLOperationResultModel is ZLGithubUserModel")
                return;
            }
            
            // 更新UI
            self.setViewDataForProfileBaseView(model: model, view: self.profileBaseView!);
            
            }
        case ZLGetMyEventResult_Notification: do
        {
            guard let resultModel: ZLOperationResultModel = notication.params as? ZLOperationResultModel else
            {
                ZLLog_Info("notificaition.params is nil]")
                return;
            }
            
            let serailNumber = self.serailNumberDic[ZLProfileBaseViewModel.queryMyEventRequestKey]
            if serailNumber != resultModel.serialNumber
            {
                return;
            }
            self.serailNumberDic.removeValue(forKey: ZLProfileBaseViewModel.queryMyEventRequestKey)
            
            self.myEventModel.append(contentsOf: resultModel.data as? [ZLGithubEventModel] ?? [])
            
            self.profileBaseView?.tableHeaderView?.reloadViewWithData()
        
            }
        case ZLLanguageTypeChange_Notificaiton:do
        {
            self.profileBaseView?.tableHeaderView?.justReloadView()
            self.profileBaseView?.tableView.reloadData()
            }
        default:
            break;
        }
        
    }
}



