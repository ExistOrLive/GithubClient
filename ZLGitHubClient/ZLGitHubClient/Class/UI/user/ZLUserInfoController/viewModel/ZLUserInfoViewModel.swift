//
//  ZLUserInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/11.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService

class ZLUserInfoViewModel: ZLBaseViewModel {
    
    // view
    private weak var userInfoView: ZLUserInfoView!
    
    //
    private var userInfoModel : ZLGithubUserModel!              //
    
    
    deinit {
        // 注销监听
        NotificationCenter.default.removeObserver(self, name: ZLLanguageTypeChange_Notificaiton, object: nil)
        NotificationCenter.default.removeObserver(self, name: ZLUserInterfaceStyleChange_Notification, object: nil)
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        // 注册监听
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLLanguageTypeChange_Notificaiton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLUserInterfaceStyleChange_Notification, object: nil)
        
        guard let view = targetView as? ZLUserInfoView else {
            ZLLog_Warn("targetView is not ZLUserInfoView");
            return
        }
        userInfoView = view
        
        guard let model : ZLGithubUserModel = targetModel as? ZLGithubUserModel else{
            ZLLog_Warn("model is not ZLGithubUserModel");
            return
        }
        userInfoModel = model
        
        if let vc = self.viewController {
            vc.zlNavigationBar.backButton.isHidden = false
            let button = UIButton.init(type: .custom)
            button.setAttributedTitle(NSAttributedString(string: ZLIconFont.More.rawValue,
                                                         attributes: [.font:UIFont.zlIconFont(withSize: 30),
                                                                      .foregroundColor:UIColor.label(withName:"ICON_Common")]),
                                      for: .normal)
            button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
            button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)
            
            vc.zlNavigationBar.rightButton = button
        }
        
        self.setViewDataForUserInfoView()
    }
    
    
    override func update(_ targetModel: Any?) {
        
        guard let model : ZLGithubUserModel = targetModel as? ZLGithubUserModel else{
            ZLLog_Warn("model is not ZLGithubUserModel");
            return
        }
        userInfoModel = model
        
        self.userInfoView.reloadData()
        
    }
    
    @objc func onMoreButtonClick(button : UIButton) {
        
        if self.userInfoModel.html_url == nil {
            return
        }
        
        let alertVC = UIAlertController.init(title: self.userInfoModel?.loginName, message: nil, preferredStyle: .actionSheet)
        alertVC.popoverPresentationController?.sourceView = button
        let alertAction1 = UIAlertAction.init(title: ZLLocalizedString(string: "View in Github", comment: ""), style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            if let url = URL.init(string: self.userInfoModel.html_url ?? "") {
                ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,params: ["requestURL":url])
            }
        }
        let alertAction2 = UIAlertAction.init(title: ZLLocalizedString(string: "Open in Safari", comment: ""), style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            if let url =  URL.init(string: self.userInfoModel.html_url ?? "") {
                UIApplication.shared.open(url, options: [:], completionHandler: {(result : Bool) in})
            }
        }
        
        let alertAction3 = UIAlertAction.init(title: ZLLocalizedString(string: "Share", comment: ""), style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            if let url =  URL.init(string: self.userInfoModel.html_url ?? "") {
                let activityVC = UIActivityViewController.init(activityItems: [url], applicationActivities: nil)
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
    
    
    func setViewDataForUserInfoView() {
        
        self.viewController?.title = userInfoModel.loginName
        
        self.userInfoView?.readMeView?.isHidden = true
        var showBlockButton = ZLSharedDataManager.sharedInstance().configModel?.BlockFunction ?? true
        let currentLoginName = ZLServiceManager.sharedInstance.viewerServiceModel?.currentUserLoginName
        if currentLoginName == "ExistOrLive1" ||
            currentLoginName == "existorlive3" ||
            currentLoginName == "existorlive11"{
            showBlockButton = true
        }
        self.userInfoView.blockButton.isHidden = !showBlockButton
        
        userInfoView.fillWithData(delegateAndDataSource: self)

        self.getFollowStatus()
        if showBlockButton{
            self.getBlockStatus()
        }
        
        
//        ZLServiceManager.sharedInstance.userServiceModel?.getUserInfo(withLoginName: userInfoModel.loginName!,
//                                                                      serialNumber: NSString.generateSerialNumber())
//        {[weak self](resultModel) in
//            if resultModel.result == true, let userModel = resultModel.data as? ZLGithubUserModel {
//                self?.userInfoModel = userModel
//                self?.userInfoView.reloadData()
//            } else if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
//                ZLToastView.showMessage("get user info failed [\(errorModel.statusCode)](\(errorModel.message)")
//            } else {
//                ZLToastView.showMessage("invalid user info format")
//            }
//        }
    }
    
}


extension ZLUserInfoViewModel
{
    @objc func onNotificationArrived(notification: Notification)
    {
        switch notification.name {
        case ZLLanguageTypeChange_Notificaiton:do{
            self.userInfoView?.justUpdate()
        }
        case ZLUserInterfaceStyleChange_Notification:do{
            self.userInfoView?.readMeView?.reRender()
        }
        default:
            break
        }
    }
    
    
    func getFollowStatus() {
        ZLServiceManager.sharedInstance.userServiceModel?.getUserFollowStatus(withLoginName: userInfoModel.loginName ?? "",
                                                                              serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel : ZLOperationResultModel) in
            if(resultModel.result == true) {
                guard let data : [String:Bool] = resultModel.data as? [String:Bool] else {
                    return
                }
                self?.userInfoView?.followButton.isSelected = data["isFollow"] ?? false
            }
        }
    }
    
    func followUser() {
        
        SVProgressHUD.show()
        ZLServiceManager.sharedInstance.userServiceModel?.followUser(withLoginName: userInfoModel.loginName ?? "",
                                                                     serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel : ZLOperationResultModel) in
            SVProgressHUD.dismiss()
            if(resultModel.result == true){
                self?.userInfoView?.followButton.isSelected = true
                ZLToastView.showMessage(ZLLocalizedString(string: "Follow Success", comment: ""))
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Follow Fail", comment: ""))
            }
        }
        
    }
    
    func unfollowUser() {
        
        SVProgressHUD.show()
        ZLServiceManager.sharedInstance.userServiceModel?.unfollowUser(withLoginName:userInfoModel.loginName ?? "",
                                                                       serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel : ZLOperationResultModel) in
            SVProgressHUD.dismiss()
            if(resultModel.result == true){
                self?.userInfoView?.followButton.isSelected = false
                ZLToastView.showMessage(ZLLocalizedString(string: "Unfollow Success", comment: ""))
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Unfollow Fail", comment: ""))
            }
        }
    }
    
    
    func getBlockStatus() {
        ZLServiceManager.sharedInstance.userServiceModel?.getUserBlockStatus(withLoginName: userInfoModel.loginName ?? "",
                                                                             serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel : ZLOperationResultModel) in
            if(resultModel.result == true) {
                guard let data : [String:Bool] = resultModel.data as? [String:Bool] else {
                    return
                }
                self?.userInfoView.blockButton.isSelected = data["isBlock"] ?? false
            }
        }
    }
    
    func BlockUser() {
        SVProgressHUD.show()
        ZLServiceManager.sharedInstance.userServiceModel?.blockUser(withLoginName: userInfoModel.loginName ?? "",
                                                                    serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel : ZLOperationResultModel) in
            SVProgressHUD.dismiss()
            if(resultModel.result == true){
                self?.userInfoView?.blockButton.isSelected = true
                ZLToastView.showMessage(ZLLocalizedString(string: "Block Success", comment: ""))
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Block Fail", comment: ""))
            }
        }
    }
    
    func unBlockUser() {
        SVProgressHUD.show()
        ZLServiceManager.sharedInstance.userServiceModel?.unBlockUser(withLoginName: userInfoModel.loginName ?? "",
                                                                      serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel : ZLOperationResultModel) in
            SVProgressHUD.dismiss()
            if(resultModel.result == true){
                self?.userInfoView.blockButton.isSelected = false
                ZLToastView.showMessage(ZLLocalizedString(string: "Unblock Success", comment: ""))
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Unblock Fail", comment: ""))
            }
        }
    }
}

extension ZLUserInfoViewModel : ZLUserInfoViewDelegateAndDataSource{
    
    var login: String?{
        userInfoModel.loginName
    }
        
    var name: String? {
        userInfoModel.name
    }
    
    var avatarURL: String? {
        userInfoModel.avatar_url
    }
    
    var createTimeStr: String? {
        let createdAtStr = ZLLocalizedString(string:"created at", comment: "创建于")
        return "\(createdAtStr) \((userInfoModel.created_at as NSDate?)?.dateStrForYYYYMMdd() ?? "")"
    }
    
    var bio: String? {
        userInfoModel.bio
    }
    
    var repositoryNum: Int {
        userInfoModel.repositories
    }
    
    var gistsNum: Int {
        userInfoModel.gists
    }
    
    var followersNum: Int {
        userInfoModel.followers
    }
    
    var followingNum: Int {
        userInfoModel.following
    }
    
    var company: String? {
        userInfoModel.company
    }
    
    var address: String? {
        userInfoModel.location
    }
    
    var email: String? {
        userInfoModel.email
    }
    
    var blog: String? {
        userInfoModel.blog
    }
    
    func onRepositoriesButtonClicked() {
        if let login = self.userInfoModel.loginName,let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController, params: ["login":login,"type":ZLUserAdditionInfoType.repositories.rawValue]) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func onGistsButtonClicked() {
        if let login = self.userInfoModel.loginName,let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController, params: ["login":login,"type":ZLUserAdditionInfoType.gists.rawValue]) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func onFollowersButtonClicked() {
        if let login = self.userInfoModel.loginName,let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController, params: ["login":login,"type":ZLUserAdditionInfoType.followers.rawValue]) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func onFollowingsButtonClicked() {
        if let login = self.userInfoModel.loginName,let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController, params: ["login":login,"type":ZLUserAdditionInfoType.following.rawValue]) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func onFollowActionButtonClicked(button: UIButton) {
        if(button.isSelected){
            self.unfollowUser()
        } else {
            self.followUser()
        }
    }
    
    func onBlockButtonClicked(button: UIButton) {
        if(button.isSelected){
            self.unBlockUser();
        } else {
            self.BlockUser();
        }
    }
    
    func onEmailButtonClicked() {
        if let email = self.userInfoModel.email,
           let url = URL.init(string: "mailto:\(email)") {
            UIApplication.shared.open(url,
                                      options: [:],
                                      completionHandler: nil)
        }
    }
    
    func onBlogButtonClicked(){
        if let blog = userInfoModel.blog, let url = URL.init(string:blog) {
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
            self.userInfoView.readMeView?.isHidden = false
        }
    }
}
