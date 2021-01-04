//
//  ZLSettingViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import MJRefresh

enum ZLSettingItemType: Int
{
    case language
    case logout
    case monitor
    case blockedUser
    case interfaceStyle
}

class ZLSettingViewModel: ZLBaseViewModel {
    
    static var settingItemTypes : [[ZLSettingItemType]] = [[.language,.blockedUser],[.logout]]
    
    
    // view
    var tableView : UITableView?
    
    // Model
    var logoutSerialNumber : String?
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: ZLLanguageTypeChange_Notificaiton, object: nil)
        ZLServiceManager.sharedInstance.loginServiceModel?.unRegisterObserver(self, name: ZLLogoutResult_Notification)
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let tableView = targetView as? UITableView else {
            ZLLog_Error("targetView is not ZLSettingView,so return")
            return
        }
        self.tableView = tableView
        
        var settingItemForFirstSection : [ZLSettingItemType] = [.language]
        
        #if debug
        settingItemForFirstSection.append(monitor)
        #endif
        if ZLSharedDataManager.sharedInstance().configModel?.BlockFunction ?? true ||
            ZLServiceManager.sharedInstance.userServiceModel?.currentUserLoginName() == "ExistOrLive1" {
            settingItemForFirstSection.append(.blockedUser)
        }
        if #available(iOS 13.0, *) {
            settingItemForFirstSection.append(.interfaceStyle)
        }
        
        ZLSettingViewModel.settingItemTypes = [settingItemForFirstSection,[.logout]]
        
        
        
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector:#selector(onNotificationArrived(notication:)) , name: ZLLanguageTypeChange_Notificaiton, object: nil)
        ZLServiceManager.sharedInstance.loginServiceModel?.registerObserver(self, selector:#selector(onNotificationArrived(notication:)), name:ZLLogoutResult_Notification)
    }
    
    
    func onLogout()
    {
        let alertController = UIAlertController.init(title: ZLLocalizedString(string: "AreYouSureToLogout", comment: "您确定要退出吗？"), message: nil, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction.init(title: ZLLocalizedString(string: "Cancel", comment: "取消"), style: UIAlertAction.Style.default, handler:nil)
        let confirmAction = UIAlertAction.init(title: ZLLocalizedString(string: "Confirm", comment: "确认"), style: UIAlertAction.Style.destructive, handler:{ (action : UIAlertAction) in
            
            self.logoutSerialNumber = NSString.generateSerialNumber()
            ZLServiceManager.sharedInstance.loginServiceModel?.logout(self.logoutSerialNumber ?? "")
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        self.viewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    func onChangeLanguage(){
        
        var titles : [String] = []
        for rawValue in [0,ZLLanguageType.simpleChinese.rawValue]
        {
            var title = ""
            switch ZLLanguageType.init(rawValue: rawValue)!
            {
            case .english:do{
                title = ZLLocalizedString(string: "English", comment: "英文")
                }
            case .simpleChinese:do{
                title = ZLLocalizedString(string: "SimpleChinese", comment: "简体中文")
                }
            @unknown default:do {
            }
            }
            
            titles.append(title)
        }
        
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: ZLLocalizedString(string: "Language", comment: ""), withInitIndex: UInt(ZLLANMODULE?.currentLanguageType().rawValue ?? 0), withDataArray: titles) { (index : UInt) in
            
            if let languaeType = ZLLanguageType.init(rawValue: UInt(index)) {
                
                ZLLANMODULE?.setLanguageType(languaeType, error: nil)
        
                switch languaeType
                {
                case .english:do{
                    MJRefreshConfig.default().languageCode = "en"
                    }
                case .simpleChinese:do{
                    MJRefreshConfig.default().languageCode = "zh-Hans"
                    }
                @unknown default:do {
                    }
                }
            }
        }
    }
    
    func onMonitor()
    {
        
    }
    

    @IBAction func onBackButtonClicked(_ sender: Any) {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
}


// MARK:onNotificationArrived
extension ZLSettingViewModel
{
    @objc func onNotificationArrived(notication: Notification)
    {
        ZLLog_Info("notificaition[\(notication) arrived]")
        
        switch notication.name
        {
        case ZLLanguageTypeChange_Notificaiton:do
        {
            self.viewController?.title = ZLLocalizedString(string: "setting", comment: "")
            self.tableView?.reloadData()
            }
        case ZLLogoutResult_Notification:do
        {
            let appDelegate:AppDelegate  = UIApplication.shared.delegate! as! AppDelegate;
            appDelegate.switch(toLoginController: true);
            }
        default:
            break;
        }
        
    }
}


// MARK: UITableViewDelegate

extension ZLSettingViewModel: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ZLSettingViewModel.settingItemTypes[section].count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let settingItemType = ZLSettingViewModel.settingItemTypes[indexPath.section][indexPath.row]
        
        var cell : UITableViewCell = UITableViewCell.init()
        
        switch settingItemType
        {
        case .language:do{
            
            guard let tableViewCell: ZLSettingItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSettingItemTableViewCell", for: indexPath) as? ZLSettingItemTableViewCell else
            {
                let cell = UITableViewCell.init()
                return cell
            }
            
            tableViewCell.itemTypeLabel.text = ZLLocalizedString(string: "Language", comment: "语言")
            switch ZLLANMODULE?.currentLanguageType() ?? ZLLanguageType.english
            {
            case .english:do{
                tableViewCell.itemValueLabel.text = ZLLocalizedString(string: "English", comment: "英文")
                }
            case .simpleChinese:do{
                tableViewCell.itemValueLabel.text = ZLLocalizedString(string: "SimpleChinese", comment: "简体中文")
                }
            @unknown default:do {
            }
            }
            
            cell = tableViewCell
            
            }
        case .monitor:do{
            
            guard let tableViewCell: ZLSettingItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSettingItemTableViewCell", for: indexPath) as? ZLSettingItemTableViewCell else
                     {
                         let cell = UITableViewCell.init()
                         return cell
                     }
                     
                     tableViewCell.itemTypeLabel.text = ZLLocalizedString(string: "Monitor", comment: "监控")
                     cell = tableViewCell
                      
                  }
        case .logout:do{
            
            guard let tableViewCell: ZLSettingLogoutTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSettingLogoutTableViewCell", for: indexPath) as? ZLSettingLogoutTableViewCell else
            {
                let cell = UITableViewCell.init()
                return cell
            }
            tableViewCell.titleLabel.text = ZLLocalizedString(string: "logout", comment: "注销")
            cell = tableViewCell
            }
        case .blockedUser:do{
            guard let tableViewCell: ZLSettingItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSettingItemTableViewCell", for: indexPath) as? ZLSettingItemTableViewCell else{
                let cell = UITableViewCell.init();
                return cell
            }
            tableViewCell.itemTypeLabel.text = ZLLocalizedString(string: "Blocked User", comment: "屏蔽的用户")
            cell = tableViewCell
        }
        case .interfaceStyle:do{
            guard let tableViewCell: ZLSettingItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSettingItemTableViewCell", for: indexPath) as? ZLSettingItemTableViewCell else{
                let cell = UITableViewCell.init();
                return cell
            }
            tableViewCell.itemTypeLabel.text = ZLLocalizedString(string: "Appearance", comment: "外观")
            cell = tableViewCell
        }
        }
        
        if cell is ZLSettingItemTableViewCell {
            let tmpCell = cell as! ZLSettingItemTableViewCell
            tmpCell.singleIineView.isHidden = (indexPath.row == ZLSettingViewModel.settingItemTypes[indexPath.section].count - 1)
        }
    
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return ZLSettingViewModel.settingItemTypes.count
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let settingItemType = ZLSettingViewModel.settingItemTypes[indexPath.section][indexPath.row]
        
        switch settingItemType
        {
        case .language:do{
            self.onChangeLanguage()
            }
        case .logout:do{
            self.onLogout()
            }
        case .monitor:do{
            self.onMonitor()
            }
        case .blockedUser:do{
            let vc = ZLBlockedUserController()
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        case .interfaceStyle:do{
            let vc = ZLAppearanceController()
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        }
        
    }
}
