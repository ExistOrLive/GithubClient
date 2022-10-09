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

@objcMembers class ZLUIRouter: NSObject {

    typealias ZLUIKey = String

    static func getVC(key: ZLUIKey, params: [AnyHashable: Any] = [:]) -> UIViewController? {
        return SYDCentralFactory.sharedInstance().getOneUIViewController(key, withInjectParam: params)
    }

    static func openVC(key: ZLUIKey, params: [AnyHashable: Any] = [:], enterConfig: SYDCentralRouterViewControllerConfig) {
        SYDCentralRouter.sharedInstance().enterViewController(key, withViewControllerConfig: enterConfig, withParam: params)
    }

    static func openVC(key: ZLUIKey, params: [AnyHashable: Any] = [:]) {
        if let vc = UIViewController.getTop() {
            let config = SYDCentralRouterViewControllerConfig()
            config.sourceViewController = vc
            config.isNavigated = ( vc.navigationController != nil )
            config.hidesBottomBarWhenPushed = true
            config.animated = true
            SYDCentralRouter.sharedInstance().enterViewController(key, withViewControllerConfig: config, withParam: params)
        }
    }

    static func navigateVC(key: ZLUIKey, params: [AnyHashable: Any] = [:], animated: Bool = true) {
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

extension ZLUIRouter {
    static let MainViewController: ZLUIKey = "ZLMainViewController"

    static let WorkboardViewController: ZLUIKey = "ZLWorkboardViewController"
    static let NotificationViewController: ZLUIKey = "ZLNotificationController"
    static let ExploreViewController: ZLUIKey = "ZLExploreViewController"
    static let ProfileViewController: ZLUIKey = "ZLProfileViewController"

    static let NewsViewController: ZLUIKey = "ZLNewsViewController"
    static let StarRepoViewController: ZLUIKey = "ZLStarRepoViewController"
    static let OrgsViewController: ZLUIKey = "ZLOrgsViewController"
    static let MyPullRequestsController: ZLUIKey = "ZLMyPullRequestsController"
    static let EditFixedRepoController: ZLUIKey = "ZLEditFixedRepoController"
    static let MyRepoesController: ZLUIKey = "ZLMyRepoesController"
    static let MyIssuesController: ZLUIKey = "ZLMyIssuesController"

    static let SearchController: ZLUIKey = "ZLSearchController"

    static let SettingController: ZLUIKey = "ZLSettingController"
    static let AppearanceController: ZLUIKey = "ZLAppearanceController"
    static let AboutViewController: ZLUIKey = "ZLAboutViewController"

   // static let UserInfoController : ZLUIKey = "ZLUserInfoController"
    static let RepoInfoController: ZLUIKey = "ZLRepoInfoController"
    static let UserOrOrgInfoController: ZLUIKey = "ZLUserOrOrgInfoController"
   // static let OrgInfoController : ZLUIKey = "ZLOrgInfoController"
    static let IssueInfoController: ZLUIKey = "ZLIssueInfoController"
    static let PRInfoController: ZLUIKey = "ZLPRInfoController"
    static let WebContentController: ZLUIKey = "ZLWebContentController"

    static let UserAdditionInfoController: ZLUIKey = "ZLUserAdditionInfoController"
}

extension ZLUIRouter {

    static func getMainViewController() -> UIViewController? {
        self.getVC(key: MainViewController)
    }

    static func getWorkboardViewController() -> UIViewController? {
        self.getVC(key: WorkboardViewController)
    }

    static func getNotificationViewController() -> UIViewController? {
        self.getVC(key: NotificationViewController)
    }

    static func getExploreViewController() -> UIViewController? {
        self.getVC(key: ExploreViewController)
    }

    static func getProfileViewController() -> UIViewController? {
        self.getVC(key: ProfileViewController)
    }

    static func getZLNewsViewController() -> UIViewController? {
        self.getVC(key: NewsViewController)
    }

    static func getStarRepoViewController() -> UIViewController? {
        self.getVC(key: StarRepoViewController)
    }

    static func getOrgsViewController() -> UIViewController? {
        self.getVC(key: OrgsViewController)
    }

    static func getZLAboutViewController() -> UIViewController? {
        self.getVC(key: AboutViewController)
    }

    static func getMyIssuesController() -> UIViewController? {
        self.getVC(key: MyIssuesController)
    }

    static func getMyReposController() -> UIViewController? {
        self.getVC(key: MyRepoesController)
    }

    static func getEditFixedRepoController() -> UIViewController? {
        self.getVC(key: EditFixedRepoController)
    }

    static func getMyPullRequestsController() -> UIViewController? {
        self.getVC(key: MyPullRequestsController)
    }

    static func getUserInfoViewController(loginName: String) -> UIViewController? {
        self.getVC(key: UserOrOrgInfoController, params: ["loginName": loginName])
    }

    static func getRepoInfoViewController(repoFullName: String) -> UIViewController? {
        let params = ["fullName": repoFullName]
        return self.getVC(key: RepoInfoController, params: params)
    }

}

extension ZLUIRouter {

    static func isGithubURL(url: URL) -> Bool {
        if url.host == "github.com" ||
            url.host == "www.github.com" {
            return true
        }
        return false
    }

    static func isParsedGithubURL(url: URL) -> Bool {

        let pathComponents = url.pathComponents

        if (url.host == "github.com" ||
            url.host == "www.github.com") &&
            pathComponents.count >= 2 {

            let login = pathComponents[1]

            if "issues" == login ||
                "pulls" == login ||
                "marketplace" == login ||
                "explore" == login ||
                "topics" == login ||
                "trending" == login ||
                "collections" == login ||
                "events" == login ||
                "sponsors" == login {
                return false
            }

            if pathComponents.count == 2 ||
                pathComponents.count == 3 {
                return true
            }

            if pathComponents.count == 5 && pathComponents[3] == "pull" {
                return true
            }

            if pathComponents.count == 5 && pathComponents[3] == "issues" {
                return true
            }
        }

        return false
    }

    static func openURL(url: URL, animated: Bool = true) {

        // github url

        let pathComponents = url.pathComponents

        if (url.host == "github.com" ||
            url.host == "www.github.com") &&
            pathComponents.count >= 2 {
            
            let login = pathComponents[1]
            if "issues" == login ||
                "pulls" == login ||
                "marketplace" == login ||
                "explore" == login ||
                "topics" == login ||
                "trending" == login ||
                "collections" == login ||
                "events" == login ||
                "sponsors" == login {
                
                self.navigateVC(key: WebContentController, params: ["requestURL": url], animated: animated)
                return
            }
            
            if pathComponents.count == 2 {
                
                self.navigateVC(key: UserOrOrgInfoController, params: ["loginName": pathComponents[1]], animated: animated)
                return
                
            } else if pathComponents.count == 3 {
                
                let repoFullName = "\(pathComponents[1])/\(pathComponents[2])"
                self.navigateVC(key: RepoInfoController, params: ["fullName": repoFullName], animated: animated)
                return
                
            } else if pathComponents.count == 5 && pathComponents[3] == "pull" {
                
                self.navigateVC(key: PRInfoController, params: ["login": pathComponents[1],
                                                                "repoName": pathComponents[2],
                                                                "number": Int(pathComponents[4]) ?? 0], animated: animated)
                return
                
            } else if pathComponents.count == 5 && pathComponents[3] == "issues" {
                
                self.navigateVC(key: IssueInfoController, params: ["login": pathComponents[1],
                                                                   "repoName": pathComponents[2],
                                                                   "number": Int(pathComponents[4]) ?? 0], animated: animated)
                return
                
            }
        }

        self.navigateVC(key: WebContentController, params: ["requestURL": url], animated: animated)
    }
}
