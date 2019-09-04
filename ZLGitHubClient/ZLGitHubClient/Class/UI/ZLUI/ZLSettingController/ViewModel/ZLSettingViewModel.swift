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
}

class ZLSettingViewModel: ZLBaseViewModel {
    
    // view
    var settingView : ZLSettingView?
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let settingView = targetView as? ZLSettingView else {
            ZLLog_Error("targetView is not ZLSettingView,so return")
            return
        }
        
        self.settingView = settingView
        
        self.settingView?.tableView.dataSource = self
        self.settingView?.tableView.delegate = self
        
    }
    
    
    func onLogout()
    {
        let alertController = UIAlertController.init(title: "您确定要退出吗？", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.default, handler:nil)
        let confirmAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.destructive, handler:{ (action : UIAlertAction) in
            
            ZLLoginServiceModel.shared().logout(NSString.generateSerialNumber())
            let appDelegate:AppDelegate  = UIApplication.shared.delegate! as! AppDelegate;
            appDelegate.switchToLoginController();
            
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        self.viewController?.present(alertController, animated: true, completion: nil)
        
    }

    @IBAction func onBackButtonClicked(_ sender: Any) {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
}


// MARK: UITableViewDelegate

extension ZLSettingViewModel: UITableViewDataSource,UITableViewDelegate
{
    
    static let settingItemTypes : [[ZLSettingItemType]] = [[.language],[.logout]]
    
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
     
            return tableViewCell
            
            }
        case .logout:do{
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSettingLogoutTableViewCell", for: indexPath)
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
            
            
            }
        case .logout:do{
            self.onLogout()
            }
        }
        
    }
}
