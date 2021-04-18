//
//  ZLOrgInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/4/9.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLOrgInfoViewModel: ZLBaseViewModel {
    
    var orgInfoView: ZLOrgInfoView!
    var orgInfoModel: ZLGithubOrgModel!
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        super.bindModel(targetModel, andView: targetView)
        
        guard let view = targetView as? ZLOrgInfoView else {
            return
        }
        orgInfoView = view
        
        guard let model = targetModel as? ZLGithubOrgModel else {
            return
        }
        orgInfoModel = model
        
        if let vc = self.viewController {
            vc.zlNavigationBar.backButton.isHidden = false
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage.init(named: "run_more"), for: .normal)
            button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
            button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)
            
            vc.zlNavigationBar.rightButton = button
        }
        
        self.setViewDataForOrgInfoView()
    }
    
    
    override func update(_ targetModel: Any?) {
        guard let model = targetModel as? ZLGithubOrgModel else {
            return
        }
        orgInfoModel = model
        
        self.orgInfoView.reloadData()
    }
    
    func setViewDataForOrgInfoView() {
        
        // MARK
        self.viewController?.title = orgInfoModel.loginName
        
        self.orgInfoView.readMeView?.isHidden = true
        orgInfoView.fillWithData(delegateAndDatasource: self)
    }
    
    
    @objc func onMoreButtonClick(button : UIButton) {
        
        if self.orgInfoModel.html_url == nil {
            return
        }
        
        let alertVC = UIAlertController.init(title: self.orgInfoModel?.loginName, message: nil, preferredStyle: .actionSheet)
        alertVC.popoverPresentationController?.sourceView = button
        let alertAction1 = UIAlertAction.init(title: ZLLocalizedString(string: "View in Github", comment: ""), style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            let webContentVC = ZLWebContentController.init()
            webContentVC.requestURL = URL.init(string: self.orgInfoModel.html_url ?? "")
            self.viewController?.navigationController?.pushViewController(webContentVC, animated: true)
        }
        let alertAction2 = UIAlertAction.init(title: ZLLocalizedString(string: "Open in Safari", comment: ""), style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            let url =  URL.init(string: self.orgInfoModel.html_url ?? "")
            if url != nil {
                UIApplication.shared.open(url!, options: [:], completionHandler: {(result : Bool) in})
            }
        }
        
        let alertAction3 = UIAlertAction.init(title: ZLLocalizedString(string: "Share", comment: ""), style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            let url =  URL.init(string: self.orgInfoModel.html_url ?? "")
            if url != nil {
                let activityVC = UIActivityViewController.init(activityItems: [url!], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = button
                activityVC.excludedActivityTypes = [.message,.mail,.openInIBooks,.markupAsPDF]
                self.viewController?.present(activityVC, animated: true, completion: nil)
            }
        }
        
        let alertAction4 = UIAlertAction.init(title: ZLLocalizedString(string: "Cancel", comment: ""), style: UIAlertAction.Style.cancel, handler: nil)
        
        alertVC.addAction(alertAction1)
        alertVC.addAction(alertAction2)
        alertVC.addAction(alertAction3)
        alertVC.addAction(alertAction4)
        
        self.viewController?.present(alertVC, animated: true, completion: nil)
        
    }
    

}

extension ZLOrgInfoViewModel: ZLOrgInfoViewDelegateAndDataSource{
    var login: String? {
        orgInfoModel.loginName
    }
    
    var name: String? {
        orgInfoModel.name
    }
    
    var avatarURL: String? {
        orgInfoModel.avatar_url
    }
    
    var createTimeStr: String? {
        let createdAtStr = ZLLocalizedString(string:"created at", comment: "创建于")
        return "\(createdAtStr) \((orgInfoModel.created_at as NSDate?)?.dateStrForYYYYMMdd() ?? "")"
    }
    
    var bio: String? {
        orgInfoModel.bio
    }
    
    var repositoryNum: Int {
        orgInfoModel.repositories
    }
    
    var membersNum: Int {
        orgInfoModel.members
    }
    
    var address: String? {
        orgInfoModel.location
    }
    
    var email: String? {
        orgInfoModel.email
    }
    
    var website: String? {
        orgInfoModel.blog
    }
    
    func onRepositoriesButtonClicked() {
        
        
        if let login = self.orgInfoModel.loginName,
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController, params: ["login":login,"type":ZLUserAdditionInfoType.repositories.rawValue]) {
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func onMembersButtonClicked() {
        
    }
    
    func onEmailButtonClicked() {
        if let email = self.orgInfoModel.email,
           let url = URL.init(string: "mailto:\(email)") {
            UIApplication.shared.open(url,
                                      options: [:],
                                      completionHandler: nil)
        }

    }
    
    func onWebsiteButtonClicked() {
        if let blog = orgInfoModel.blog, let url = URL.init(string:blog) {
            ZLUIRouter.navigateVC(key:ZLUIRouter.WebContentController,
                                  params: ["requestURL":url],
                                  animated: true)
        }
    }
    
    
    // MARK: ZLReadmeViewDelegate
    
    func onLinkClicked(url : URL?) -> Void {
        if let realurl = url {
            ZLUIRouter.openURL(url: realurl)
        }
    }
        
    func getReadMeContent(result: Bool) {
        if result == true {
            self.orgInfoView.readMeView?.isHidden = false
        }
    }
    
}
