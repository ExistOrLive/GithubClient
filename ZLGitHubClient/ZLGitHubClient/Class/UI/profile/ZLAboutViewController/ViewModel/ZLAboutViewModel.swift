//
//  ZLAboutViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/8.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZLBaseUI

class ZLAboutViewModel: ZLBaseViewModel, ZLAboutContentViewDelegate {

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let aboutView = targetView as? ZLAboutContentView else {
            return
        }
        aboutView.fillWithData(delegate: self)
    }

    var version: String {
        ZLDeviceInfo.getAppVersion()
    }

   func onContributorsButtonClicked() {

        let contributorsVC = ZLRepoContributorsController.init()
        contributorsVC.repoFullName = "ExistOrLive/GithubClient"
        self.viewController?.navigationController?.pushViewController(contributorsVC, animated: true)
    }

   func onRepoButtonClicked() {

        if let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: "ExistOrLive/GithubClient") {
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }

   func onAppStoreButtonClicked() {

        if  let url = URL.init(string: "https://apps.apple.com/cn/app/zlgithubclient/id1498787032"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
