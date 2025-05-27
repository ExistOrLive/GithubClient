//
//  ZLUIRouter.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/1/4.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import SYDCentralPivot
import ZLGitRemoteService

typealias ZLRouterKey = String

// MARK: - 创建VC，VC跳转逻辑
@objcMembers class ZLUIRouter: NSObject {

    static func getVC(key: ZLRouterKey, params: [AnyHashable: Any] = [:]) -> UIViewController? {
        return SYDCentralFactory.sharedInstance().getOneUIViewController(key, withInjectParam: params)
    }

    static func openVC(key: ZLRouterKey, params: [AnyHashable: Any] = [:], enterConfig: SYDCentralRouterViewControllerConfig) {
        SYDCentralRouter.sharedInstance().enterViewController(key, withViewControllerConfig: enterConfig, withParam: params)
    }

    static func openVC(key: ZLRouterKey, params: [AnyHashable: Any] = [:]) {
        if let vc = UIViewController.getTop() {
            let config = SYDCentralRouterViewControllerConfig()
            config.sourceViewController = vc
            config.isNavigated = ( vc.navigationController != nil )
            config.hidesBottomBarWhenPushed = true
            config.animated = true
            SYDCentralRouter.sharedInstance().enterViewController(key, withViewControllerConfig: config, withParam: params)
        }
    }

    static func navigateVC(key: ZLRouterKey, params: [AnyHashable: Any] = [:], animated: Bool = true) {
        if let topVC = UIViewController.getTop() {
            if topVC.navigationController == nil {
                if topVC.presentingViewController == nil {
                    return
                }
                topVC.dismiss(animated: true, completion: { [self] in
                    navigateVC(key: key, params: params)
                })
                return
            }

            let config = SYDCentralRouterViewControllerConfig()
            config.sourceViewController = topVC
            config.isNavigated = true
            config.hidesBottomBarWhenPushed = true
            config.animated = animated
            SYDCentralRouter.sharedInstance().enterViewController(key, withViewControllerConfig: config, withParam: params)
        }
    }
}

// MARK: - VC Key
extension ZLRouterKey {
    static let MainViewController: ZLRouterKey = "ZLMainViewController"

    static let WorkboardViewController: ZLRouterKey = "ZLWorkboardViewController"
    static let NotificationViewController: ZLRouterKey = "ZLNotificationController"
    static let ExploreViewController: ZLRouterKey = "ZLExploreViewController"
    static let ProfileViewController: ZLRouterKey = "ZLProfileViewController"

    static let NewsViewController: ZLRouterKey = "ZLNewsViewController"
    static let StarRepoViewController: ZLRouterKey = "ZLStarRepoViewController"
    static let OrgsViewController: ZLRouterKey = "ZLOrgsViewController"
    static let MyPullRequestsController: ZLRouterKey = "ZLMyPullRequestsController"
    static let EditFixedRepoController: ZLRouterKey = "ZLEditFixedRepoController"
    static let MyRepoesController: ZLRouterKey = "ZLMyRepoesController"
    static let MyIssuesController: ZLRouterKey = "ZLMyIssuesController"

    static let SearchController: ZLRouterKey = "ZLSearchController"

    static let SettingController: ZLRouterKey = "ZLSettingController"
    static let AppearanceController: ZLRouterKey = "ZLAppearanceController"
    static let AboutViewController: ZLRouterKey = "ZLAboutViewController"

   // static let UserInfoController : ZLRouterKey = "ZLUserInfoController"
    static let RepoInfoController: ZLRouterKey = "ZLRepoInfoController"
    static let UserOrOrgInfoController: ZLRouterKey = "ZLUserOrOrgInfoController"
   // static let OrgInfoController : ZLRouterKey = "ZLOrgInfoController"
    static let IssueInfoController: ZLRouterKey = "ZLIssueInfoController"
    static let PRInfoController: ZLRouterKey = "ZLPRInfoController"
    static let DiscussionInfoController: ZLRouterKey = "ZLDiscussionInfoController"
    static let ReleaseInfoController: ZLRouterKey = "ZLReleaseInfoController"
    static let CommitInfoController: ZLRouterKey = "ZLCommitInfoController"
    static let CompareInfoController: ZLRouterKey = "ZLRepoCompareCommitController"
    
    static let WebContentController: ZLRouterKey = "ZLWebContentController"

    static let UserAdditionInfoController: ZLRouterKey = "ZLUserAdditionInfoController"
}

// MARK: 获取指定Vc
extension ZLUIRouter {

    static func getMainViewController() -> UIViewController? {
        self.getVC(key: .MainViewController)
    }

    static func getWorkboardViewController() -> UIViewController? {
        self.getVC(key: .WorkboardViewController)
    }

    static func getNotificationViewController() -> UIViewController? {
        self.getVC(key: .NotificationViewController)
    }

    static func getExploreViewController() -> UIViewController? {
        self.getVC(key: .ExploreViewController)
    }

    static func getProfileViewController() -> UIViewController? {
        self.getVC(key: .ProfileViewController)
    }

    static func getZLNewsViewController() -> UIViewController? {
        self.getVC(key: .NewsViewController)
    }

    static func getStarRepoViewController() -> UIViewController? {
        self.getVC(key: .StarRepoViewController)
    }

    static func getOrgsViewController() -> UIViewController? {
        self.getVC(key: .OrgsViewController)
    }

    static func getZLAboutViewController() -> UIViewController? {
        self.getVC(key: .AboutViewController)
    }

    static func getMyIssuesController() -> UIViewController? {
        self.getVC(key: .MyIssuesController)
    }

    static func getMyReposController() -> UIViewController? {
        self.getVC(key: .MyRepoesController)
    }

    static func getEditFixedRepoController() -> UIViewController? {
        self.getVC(key: .EditFixedRepoController)
    }

    static func getMyPullRequestsController() -> UIViewController? {
        self.getVC(key: .MyPullRequestsController)
    }

    static func getUserInfoViewController(loginName: String) -> UIViewController? {
        self.getVC(key: .UserOrOrgInfoController, params: ["loginName": loginName])
    }

    static func getRepoInfoViewController(repoFullName: String) -> UIViewController? {
        let params = ["fullName": repoFullName]
        return self.getVC(key: .RepoInfoController, params: params)
    }

}

// MARK: 解析URL
extension ZLUIRouter {

    static func isParsedGithubURL(url: URL) -> Bool {

        if let githubPathType = parseGithubURL(url: url) {
            return true
        } else {
            return false
        }
        
    }

    static func openURL(url: URL, animated: Bool = true) {

       
        if let githubPathType = parseGithubURL(url: url) {
            
            // github url
            
            let (routerType, routerKey, routerParams) = githubPathType.routerParams()
            
            switch(routerType) {
            case .uiViewController:
                self.navigateVC(key: routerKey, params: routerParams, animated: animated)
            default:
                break
            }
        
        } else {
            self.navigateVC(key: .WebContentController, params: ["requestURL": url], animated: animated)
        }
    }
}
