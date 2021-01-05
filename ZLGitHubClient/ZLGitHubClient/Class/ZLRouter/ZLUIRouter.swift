//
//  ZLUIRouter.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/1/4.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

@objcMembers class ZLUIRouter: NSObject {
    
    typealias ZLUIKey = String

    static func getVC(key: ZLUIKey, params: [AnyHashable : Any] = [:]) -> UIViewController?{
        SYDCentralFactory.sharedInstance().getOneUIViewController(key, withInjectParam: params)
    }
    
    static func openVC(key: ZLUIKey, params: [AnyHashable : Any] = [:], enterConfig: SYDCentralRouterViewControllerConfig){
        SYDCentralRouter.sharedInstance().enterViewController(key, withViewControllerConfig: enterConfig, withParam: params)
    }
    
    static func openVC(key: ZLUIKey, params: [AnyHashable : Any] = [:]) {
        if let vc = UIViewController.getTop(){
            let config = SYDCentralRouterViewControllerConfig()
            config.sourceViewController = vc
            config.isNavigated = ( vc.navigationController != nil )
            config.hidesBottomBarWhenPushed = true
            SYDCentralRouter.sharedInstance()?.enterViewController(key, withViewControllerConfig: config, withParam: params)
        }
    }
}

extension ZLUIRouter{
    
    static let MainViewController : ZLUIKey = "ZLMainViewController"
    
    static let WorkboardViewController : ZLUIKey = "ZLWorkboardViewController"
    static let NotificationViewController : ZLUIKey = "ZLNotificationController"
    static let ExploreViewController : ZLUIKey = "ZLExploreViewController"
    static let ProfileViewController : ZLUIKey = "ZLProfileViewController"
    
    static let NewsViewController : ZLUIKey = "ZLNewsViewController"
    static let StarRepoViewController : ZLUIKey = "ZLStarRepoViewController"
    static let OrgsViewController : ZLUIKey = "ZLOrgsViewController"
    static let MyPullRequestsController : ZLUIKey = "ZLMyPullRequestsController"
    static let EditFixedRepoController : ZLUIKey = "ZLEditFixedRepoController"
    static let MyRepoesController : ZLUIKey = "ZLMyRepoesController"
    static let MyIssuesController : ZLUIKey = "ZLMyIssuesController"
    
    static let AboutViewController : ZLUIKey = "ZLAboutViewController"
    
    static let UserInfoController : ZLUIKey = "ZLUserInfoController"
    static let RepoInfoController : ZLUIKey = "ZLRepoInfoController"
    
}

extension ZLUIRouter{
    
    static func getMainViewController() -> UIViewController?{
        self.getVC(key: MainViewController)
    }
    
    static func getWorkboardViewController() -> UIViewController?{
        self.getVC(key: WorkboardViewController)
    }
    
    static func getNotificationViewController() -> UIViewController?{
        self.getVC(key: NotificationViewController)
    }
    
    static func getExploreViewController() -> UIViewController?{
        self.getVC(key: ExploreViewController)
    }
    
    static func getProfileViewController() -> UIViewController?{
        self.getVC(key: ProfileViewController)
    }
    
    static func getZLNewsViewController() -> UIViewController?{
        self.getVC(key: NewsViewController)
    }
    
    static func getStarRepoViewController() -> UIViewController?{
        self.getVC(key: StarRepoViewController)
    }

    static func getOrgsViewController() -> UIViewController?{
        self.getVC(key: OrgsViewController)
    }

    static func getZLAboutViewController() -> UIViewController?{
        self.getVC(key: AboutViewController)
    }

    static func getMyIssuesController() -> UIViewController?{
        self.getVC(key: MyIssuesController)
    }
    
    static func getMyReposController() -> UIViewController?{
        self.getVC(key: MyRepoesController)
    }

    static func getEditFixedRepoController() -> UIViewController?{
        self.getVC(key: EditFixedRepoController)
    }

    static func getMyPullRequestsController() -> UIViewController?{
        self.getVC(key: MyPullRequestsController)
    }

    
    static func getUserInfoViewController(_ userInfo: ZLGithubUserModel) -> UIViewController?{
        let params = ["userInfoModel":userInfo]
        return self.getVC(key: UserInfoController, params: params)
    }
    
    static func getUserInfoViewController(_ loginName: String, type: ZLGithubUserType)  -> UIViewController?{
        let userModel = ZLGithubUserModel()
        userModel.loginName = loginName
        userModel.type = type
        return  self.getUserInfoViewController(userModel)
    }
    
    
    static func getRepoInfoViewController(_ repoInfo: ZLGithubRepositoryModel) -> UIViewController?{
        let params = ["repoInfoModel":repoInfo]
        return self.getVC(key: RepoInfoController, params: params)
    }
    
    static func getRepoInfoViewController(repoFullName: String)  -> UIViewController?{
        let repoModel = ZLGithubRepositoryModel()
        repoModel.full_name = repoFullName
        return  self.getRepoInfoViewController(repoModel)
    }
    
}


extension ZLUIRouter{
    static func openURL(url:URL){
        // github url
        if url.host == "github.com" ||
            url.host == "www.github.com" {
            let pathComponents = url.pathComponents
            if pathComponents.count == 2 {
                let userModel = ZLGithubUserModel()
                userModel.loginName = pathComponents[1]
                self.openVC(key: UserInfoController, params: ["userInfoModel":userModel])
                return
            } else if pathComponents.count > 2 {
                let repoModel = ZLGithubRepositoryModel()
                repoModel.full_name = "\(pathComponents[1])/\(pathComponents[2])"
                self.openVC(key: RepoInfoController, params: ["repoInfoModel":repoModel])
                return
            }
        }
    }
}
