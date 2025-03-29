//
//  ZLSettingViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import MJRefresh
import ZLGitRemoteService
import ZLUtilities
import ZMMVVM

enum ZLSettingItemType: Int {
    case language
    case logout
    case monitor
    case blockedUser
    case interfaceStyle
    case assistButton
}

class ZLSettingViewModel: ZMBaseViewModel {

    static var settingItemTypes: [[ZLSettingItemType]] = [[.language, .blockedUser], [.logout]]

    // view
    weak var tableView: UITableView?

    // Model
    var logoutSerialNumber: String?

    deinit {
        NotificationCenter.default.removeObserver(self, name: ZLLanguageTypeChange_Notificaiton, object: nil)
        NotificationCenter.default.removeObserver(self, name: ZLAssistButtonShowOrHiddenNotification, object: nil)
        ZLServiceManager.sharedInstance.loginServiceModel?.unRegisterObserver(self, name: ZLLogoutResult_Notification)
    }
    
   init(tableView: UITableView?) {
        super.init()
        
        self.tableView = tableView
        
        var settingItemForFirstSection: [ZLSettingItemType] = [.language]

#if DEBUG
        settingItemForFirstSection.append(.monitor)
#endif
#if DEBUG
        settingItemForFirstSection.append(.blockedUser)
#else
        let currentLoginName = ZLServiceManager.sharedInstance.viewerServiceModel?.currentUserLoginName
        let showBlockButton = ZLAGC().configAsBool(for: "Block_Function_Enabled")
        if showBlockButton ||
            currentLoginName == "ExistOrLive1" ||
            currentLoginName == "existorlive3" ||
            currentLoginName == "existorlive11" {
            settingItemForFirstSection.append(.blockedUser)
        }
#endif
        if #available(iOS 13.0, *) {
            settingItemForFirstSection.append(.interfaceStyle)
        }

        settingItemForFirstSection.append(.assistButton)

        ZLSettingViewModel.settingItemTypes = [settingItemForFirstSection, [.logout]]

        self.tableView?.dataSource = self
        self.tableView?.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notication:)), name: ZLLanguageTypeChange_Notificaiton, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notication:)), name: ZLAssistButtonShowOrHiddenNotification, object: nil)
        ZLServiceManager.sharedInstance.loginServiceModel?.registerObserver(self, selector: #selector(onNotificationArrived(notication:)), name: ZLLogoutResult_Notification)
    }

    override func zm_viewWillAppear() {
        super.zm_viewWillAppear()
        self.tableView?.reloadData()
    }

    func onLogout() {
        let alertController = UIAlertController.init(title: ZLLocalizedString(string: "AreYouSureToLogout", comment: "您确定要退出吗？"), message: nil, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction.init(title: ZLLocalizedString(string: "Cancel", comment: "取消"), style: UIAlertAction.Style.default, handler: nil)
        let confirmAction = UIAlertAction.init(title: ZLLocalizedString(string: "Confirm", comment: "确认"), style: UIAlertAction.Style.destructive, handler: { (_: UIAlertAction) in

            self.logoutSerialNumber = NSString.generateSerialNumber()
            ZLServiceManager.sharedInstance.loginServiceModel?.logout(self.logoutSerialNumber ?? "")
        })

        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)

        zm_viewController?.present(alertController, animated: true, completion: nil)

    }

    func onMonitor() {

    }

}

// MARK: onNotificationArrived
extension ZLSettingViewModel {
    @objc func onNotificationArrived(notication: Notification) {
        ZLLog_Info("notificaition[\(notication) arrived]")

        switch notication.name {
        case ZLLanguageTypeChange_Notificaiton:do {
             zm_viewController?.title = ZLLocalizedString(string: "setting", comment: "")
            self.tableView?.reloadData()
            }
        case ZLLogoutResult_Notification:do {
            let appDelegate  = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.switch(toLoginController: true)
            }
        case ZLAssistButtonShowOrHiddenNotification: do {
            self.tableView?.reloadData()
        }
        default:
            break
        }

    }
}

// MARK: UITableViewDelegate

extension ZLSettingViewModel: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ZLSettingViewModel.settingItemTypes[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingItemType = ZLSettingViewModel.settingItemTypes[indexPath.section][indexPath.row]

        var cell: UITableViewCell = UITableViewCell.init()

        switch settingItemType {
        case .language:do {

            guard let tableViewCell: ZLSettingItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSettingItemTableViewCell", for: indexPath) as? ZLSettingItemTableViewCell else {
                let cell = UITableViewCell.init()
                return cell
            }

            tableViewCell.itemTypeLabel.text = ZLLocalizedString(string: "Language", comment: "语言")
            switch LANMODULE?.currentLanguageType() ?? ZLLanguageType.auto {
            case .auto:do {
                tableViewCell.itemValueLabel.text = ZLLocalizedString(string: "FollowSystemSetting", comment: "跟随系统")
            }
            case .english:do {
                tableViewCell.itemValueLabel.text = ZLLocalizedString(string: "English", comment: "英文")
                }
            case .simpleChinese:do {
                tableViewCell.itemValueLabel.text = ZLLocalizedString(string: "SimpleChinese", comment: "简体中文")
                }
            @unknown default:do {
            }
            }

            cell = tableViewCell

            }
        case .monitor:do {

            guard let tableViewCell: ZLSettingItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSettingItemTableViewCell", for: indexPath) as? ZLSettingItemTableViewCell else {
                         let cell = UITableViewCell.init()
                         return cell
                     }

                     tableViewCell.itemTypeLabel.text = ZLLocalizedString(string: "Monitor", comment: "监控")
                     cell = tableViewCell

                  }
        case .logout:do {

            guard let tableViewCell: ZLSettingLogoutTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSettingLogoutTableViewCell", for: indexPath) as? ZLSettingLogoutTableViewCell else {
                let cell = UITableViewCell.init()
                return cell
            }
            tableViewCell.titleLabel.text = ZLLocalizedString(string: "logout", comment: "注销")
            cell = tableViewCell
            }
        case .blockedUser:do {
            guard let tableViewCell: ZLSettingItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSettingItemTableViewCell", for: indexPath) as? ZLSettingItemTableViewCell else {
                let cell = UITableViewCell.init()
                return cell
            }
            tableViewCell.itemTypeLabel.text = ZLLocalizedString(string: "Blocked User", comment: "屏蔽的用户")
            cell = tableViewCell
        }
        case .interfaceStyle:do {
            guard let tableViewCell: ZLSettingItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSettingItemTableViewCell", for: indexPath) as? ZLSettingItemTableViewCell else {
                let cell = UITableViewCell.init()
                return cell
            }
            tableViewCell.itemTypeLabel.text = ZLLocalizedString(string: "Appearance", comment: "外观")
            if #available(iOS 12.0, *) {
                switch ZLUISharedDataManager.currentUserInterfaceStyle {
                case .unspecified:
                    tableViewCell.itemValueLabel.text = ZLLocalizedString(string: "FollowSystemSetting", comment: "")
                case .dark:
                    tableViewCell.itemValueLabel.text = ZLLocalizedString(string: "Dark Mode", comment: "")
                case .light:
                    tableViewCell.itemValueLabel.text = ZLLocalizedString(string: "Light Mode", comment: "")
                @unknown default:do {
                }
                }
            }
            cell = tableViewCell
        }
        case .assistButton:do {
            guard let tableViewCell: ZLSettingItemTableViewCell1 = tableView.dequeueReusableCell(withIdentifier: "ZLSettingItemTableViewCell1", for: indexPath) as? ZLSettingItemTableViewCell1 else {
                let cell = UITableViewCell.init()
                return cell
            }
            tableViewCell.itemTypeLabel.text = ZLLocalizedString(string: "AssistButton", comment: "辅助按钮")
            tableViewCell.switchView.isOn = !ZLUISharedDataManager.isAssistButtonHidden
            if !tableViewCell.switchView.allTargets.contains(self) {
                tableViewCell.switchView.addTarget(self, action: #selector(ZLSettingViewModel.onAssistButtonSwitch(switchView:)), for: .touchUpInside)
            }
            cell = tableViewCell
        }
        }

        if cell is ZLSettingItemTableViewCell {
            let tmpCell = cell as! ZLSettingItemTableViewCell
            tmpCell.singleIineView.isHidden = (indexPath.row == ZLSettingViewModel.settingItemTypes[indexPath.section].count - 1)
        }

        if cell is ZLSettingItemTableViewCell1 {
            let tmpCell = cell as! ZLSettingItemTableViewCell1
            tmpCell.singleIineView.isHidden = (indexPath.row == ZLSettingViewModel.settingItemTypes[indexPath.section].count - 1)
        }

        return cell

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return ZLSettingViewModel.settingItemTypes.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let settingItemType = ZLSettingViewModel.settingItemTypes[indexPath.section][indexPath.row]

        switch settingItemType {
        case .language:do {
            let vc = ZLLanguageController()
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        case .logout:do {
            self.onLogout()
            }
        case .monitor:do {
            self.onMonitor()
            }
        case .blockedUser:do {
            let vc = ZLBlockedUserController()
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        case .interfaceStyle:do {
            if let vc = ZLUIRouter.getVC(key: ZLUIRouter.AppearanceController) {
                zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        case .assistButton:do {

        }
        }

    }

    @objc func onAssistButtonSwitch(switchView: UISwitch) {
        ZLUISharedDataManager.isAssistButtonHidden = !switchView.isOn
        ZLAssistButtonManager.shared.setHidden(!switchView.isOn)
    }

}
