//
//  ZLAboutViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/8.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLAboutViewModel: ZLBaseViewModel {
    
    var aboutView : ZLAboutContentView?
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let aboutView : ZLAboutContentView = targetView as? ZLAboutContentView else{
            return;
        }
        self.aboutView = aboutView
        
        let infoDic = Bundle.main.infoDictionary
        if infoDic != nil{
            let versionStr = "\(infoDic!["CFBundleShortVersionString"] ?? "0")(\(infoDic!["CFBundleVersion"] ?? "0"))"
            self.aboutView?.versionLabel.text = versionStr
        }
        
    }
    
    @IBAction func onContributorsButtonClicked(_ sender: Any) {
        let contributorsVC = ZLRepoContributorsController.init()
        contributorsVC.repoFullName = "MengAndJie/GithubClient"
        self.viewController?.navigationController?.pushViewController(contributorsVC, animated: true)
    }
    
    
    @IBAction func onRepoButtonClicked(_ sender: Any) {
        if let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: "MengAndJie/GithubClient") {
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onAppStoreButtonClicked(_ sender: Any) {
        let url = URL.init(string: "https://apps.apple.com/cn/app/zlgithubclient/id1498787032")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
        
    }
    
    
}
