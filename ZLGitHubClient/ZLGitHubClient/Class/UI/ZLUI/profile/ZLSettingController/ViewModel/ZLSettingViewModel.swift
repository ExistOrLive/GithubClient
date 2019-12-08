//
//  ZLSettingViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

enum ZLSettingItemType: Int
{
    case language
    case logout
    case monitor
}

class ZLSettingViewModel: ZLBaseViewModel {
    
    // view
    var settingView : ZLSettingView?
    
    // Model
    var logoutSerialNumber : String?
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: ZLLanguageTypeChange_Notificaiton, object: nil)
        ZLLoginServiceModel.shared().unRegisterObserver(self, name: ZLLogoutResult_Notification)
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let settingView = targetView as? ZLSettingView else {
            ZLLog_Error("targetView is not ZLSettingView,so return")
            return
        }
        
        self.settingView = settingView
        
        self.settingView?.tableView.dataSource = self
        self.settingView?.tableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector:#selector(onNotificationArrived(notication:)) , name: ZLLanguageTypeChange_Notificaiton, object: nil)
        ZLLoginServiceModel.shared().registerObserver(self, selector:#selector(onNotificationArrived(notication:)), name:ZLLogoutResult_Notification)
        
    }
    
    
    func onLogout()
    {
        let alertController = UIAlertController.init(title: ZLLocalizedString(string: "AreYouSureToLogout", comment: "您确定要退出吗？"), message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction.init(title: ZLLocalizedString(string: "Cancel", comment: "取消"), style: UIAlertActionStyle.default, handler:nil)
        let confirmAction = UIAlertAction.init(title: ZLLocalizedString(string: "Confirm", comment: "确认"), style: UIAlertActionStyle.destructive, handler:{ (action : UIAlertAction) in
            
            self.logoutSerialNumber = NSString.generateSerialNumber()
            ZLLoginServiceModel.shared().logout(self.logoutSerialNumber ?? "")
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        self.viewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    func onChangeLanguage()
    {
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
       
        for rawValue in [0,ZLLanguageType.simpleChinese.rawValue]
        {
            var title : String? = nil
            let handle : ((UIAlertAction) -> Void) = {(action: UIAlertAction) in ZLLANMODULE?.setLanguageType(ZLLanguageType.init(rawValue: rawValue)!, error: nil)
            }
            
            switch ZLLanguageType.init(rawValue: rawValue)!
            {
            case .english:do{
                title = ZLLocalizedString(string: "English", comment: "英文")
                }
            case .simpleChinese:do{
                title = ZLLocalizedString(string: "SimpleChinese", comment: "简体中文")
                }
            }
            
            let action = UIAlertAction.init(title: title, style: UIAlertActionStyle.default, handler:handle)
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction.init(title:ZLLocalizedString(string: "Cancel", comment: "取消") , style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.viewController?.present(alertController, animated: true, completion: nil)
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
            self.settingView?.justReloadView()
            }
        case ZLLogoutResult_Notification:do
        {
            let appDelegate:AppDelegate  = UIApplication.shared.delegate! as! AppDelegate;
            appDelegate.switchToLoginController();
            }
        default:
            break;
        }
        
    }
}


// MARK: UITableViewDelegate

extension ZLSettingViewModel: UITableViewDataSource,UITableViewDelegate
{
    #if debug
    static let settingItemTypes : [[ZLSettingItemType]] = [[.language,.monitor],[.logout]]
    #else
    static let settingItemTypes : [[ZLSettingItemType]] = [[.language],[.logout]]
    #endif
    
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
            }
            return tableViewCell
            
            }
        case .monitor:do{
            
            guard let tableViewCell: ZLSettingItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSettingItemTableViewCell", for: indexPath) as? ZLSettingItemTableViewCell else
                     {
                         let cell = UITableViewCell.init()
                         return cell
                     }
                     
                     tableViewCell.itemTypeLabel.text = ZLLocalizedString(string: "Monitor", comment: "监控")
                     return tableViewCell
                      
                  }
        case .logout:do{
            
            guard let tableViewCell: ZLSettingLogoutTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSettingLogoutTableViewCell", for: indexPath) as? ZLSettingLogoutTableViewCell else
            {
                let cell = UITableViewCell.init()
                return cell
            }
            tableViewCell.titleLabel.text = ZLLocalizedString(string: "logout", comment: "注销")
            return tableViewCell
            }
          
        }
        
        
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
        }
        
    }
}
