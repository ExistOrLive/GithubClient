//
//  ZLMainViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/1/13.
//  Copyright © 2019年 ZM. All rights reserved.
//

import Foundation
import UIKit
import ZLUIUtilities

@objc class ZLMainViewController: UITabBarController {
    
    private var assistManager: ZLAssistButtonManager?
    
    @objc class func shared() -> UIViewController {
        let mainViewController = ZLMainViewController()
        return mainViewController
    }
    
    deinit {
        ZLAssistButtonManager.sharedInstance().setHidden(true)
        NotificationCenter.default.removeObserver(self, name:ZLLanguageTypeChange_Notificaiton, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().isTranslucent = false
        setupAllChildViewController()
        setupTabBarItems()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(_:)), name: ZLLanguageTypeChange_Notificaiton, object: nil)
        
        ZLAssistButtonManager.sharedInstance().setHidden(ZLUISharedDataManager.isAssistButtonHidden)

    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // 外观模式切换
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
                justReloadView()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        ZLAssistButtonManager.sharedInstance().ajustAssistButtonPosition()
    }
    
    private func setupAllChildViewController() {
        if let workboardViewController = ZLUIRouter.getWorkboardViewController() {
            let workNavigationController = ZMNavigationController(rootViewController: workboardViewController)
            addChild(workNavigationController)
        }
        
        if let notificationViewController = ZLUIRouter.getNotificationViewController() {
            let notificationNavigationController = ZMNavigationController(rootViewController: notificationViewController)
            addChild(notificationNavigationController)
        }
        
        if let exploreViewController = ZLUIRouter.getExploreViewController() {
            let exploreNavigationController = ZMNavigationController(rootViewController: exploreViewController)
            addChild(exploreNavigationController)
        }
        
        if  let profileViewController = ZLUIRouter.getProfileViewController() {
            let profileNavigationController = ZMNavigationController(rootViewController: profileViewController)
            addChild(profileNavigationController)
        }
    }
    
    private func setupTabBarItems() {
        for i in 0..<children.count {
            let tabBarItem = children[i].tabBarItem
            
            switch i {
            case 0:
                tabBarItem?.title = ZLLocalizedString(string: "Workboard", comment: "工作台")
                tabBarItem?.image = UIImage(named: "tabBar_new_icon")
                tabBarItem?.selectedImage = UIImage(named: "tabBar_new_click_icon")
            case 1:
                tabBarItem?.title = ZLLocalizedString(string:"Notification", comment: "通知")
                tabBarItem?.image = UIImage(named: "tabBar_Notification")
                tabBarItem?.selectedImage = UIImage(named: "tabBar_Notification_click")
            case 2:
                tabBarItem?.title = ZLLocalizedString(string:"explore", comment: "搜索")
                tabBarItem?.image = UIImage(named: "tabBar_friendTrends_icon")
                tabBarItem?.selectedImage = UIImage(named: "tabBar_friendTrends_click_icon")
            case 3:
                tabBarItem?.title = ZLLocalizedString(string:"profile", comment: "我")
                tabBarItem?.image = UIImage(named: "tabBar_essence_icon")
                tabBarItem?.selectedImage = UIImage(named: "tabBar_essence_click_icon")
            default:
                break
            }
        }
        
        tabBar.tintColor = UIColor(named: "ZLTabBarTintColor")
        
        let backImage = UIImage(color: UIColor(named: "ZLTabBarBackColor") ?? UIColor.clear)
                 
        if #available(iOS 15.0, *) {
            // iOS 15.0 后设置tabbar背景颜色
            let appearance = UITabBarAppearance()
            appearance.backgroundImage = backImage
            appearance.shadowImage = backImage
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.backgroundImage = backImage
            tabBar.shadowImage = backImage
        }
    }
    
    private func justReloadView() {
        if let newsNavigationController = children[0] as? ZMNavigationController {
            newsNavigationController.tabBarItem.title = ZLLocalizedString(string:"Workboard", comment: "工作台")
        }
        
        if let notificaitonNavigationController = children[1] as? ZMNavigationController {
            notificaitonNavigationController.tabBarItem.title = ZLLocalizedString(string:"Notification", comment: "通知")
        }
        
        if let exploreNavigationController = children[2] as? ZMNavigationController {
            exploreNavigationController.tabBarItem.title = ZLLocalizedString(string:"explore", comment: "搜索")
        }
        
        if let profileNavigationController = children[3] as? ZMNavigationController {
            profileNavigationController.tabBarItem.title = ZLLocalizedString(string:"profile", comment: "我")
        }
        
        let backImage = UIImage(color: UIColor(named: "ZLTabBarBackColor") ?? UIColor.clear)
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundImage = backImage
            appearance.shadowImage = backImage
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.backgroundImage = backImage
            tabBar.shadowImage = backImage
        }
    }
    
    private func justReloadLanguage() {
        if let newsNavigationController = children[0] as? ZMNavigationController {
            newsNavigationController.tabBarItem.title = ZLLocalizedString(string:"Workboard", comment: "动态")
        }
        
        if let notificaitonNavigationController = children[1] as? ZMNavigationController {
            notificaitonNavigationController.tabBarItem.title = ZLLocalizedString(string:"Notification", comment: "通知")
        }
        
        if let exploreNavigationController = children[2] as? ZMNavigationController {
            exploreNavigationController.tabBarItem.title = ZLLocalizedString(string:"explore", comment: "搜索")
        }
        
        if let profileNavigationController = children[3] as? ZMNavigationController {
            profileNavigationController.tabBarItem.title = ZLLocalizedString(string:"profile", comment: "我")
        }
    }
    
    @objc private func onNotificationArrived(_ notification: Notification) {
        if notification.name == ZLLanguageTypeChange_Notificaiton {
            justReloadLanguage()
        }
    }
}
