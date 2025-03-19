//
//  ZLAboutViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/8.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZMMVVM
import ZLUtilities

class ZLAboutViewModel: ZMBaseViewModel, ZLAboutContentViewDelegate {

    var version: String {
        ZLDeviceInfo.getAppVersion()
    }
    
    func onContributorsButtonClicked() {
        
        let contributorsVC = ZLRepoContributorsController(repoFullName: "ExistOrLive/GithubClient")
        zm_viewController?.navigationController?.pushViewController(contributorsVC, animated: true)
    }
    
    func onRepoButtonClicked() {
        
        if let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: "ExistOrLive/GithubClient") {
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func onAppStoreButtonClicked() {
        
        if  let url = URL.init(string: "https://apps.apple.com/cn/app/zlgithubclient/id1498787032"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func onICPButtonCliked() {
        if  let url = URL.init(string: "https://beian.miit.gov.cn"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
