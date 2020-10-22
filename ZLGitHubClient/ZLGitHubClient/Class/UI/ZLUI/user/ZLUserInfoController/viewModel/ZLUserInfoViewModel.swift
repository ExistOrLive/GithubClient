//
//  ZLUserInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/11.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLUserInfoViewModel: ZLBaseViewModel {
    
    // view
    private weak var userInfoView: ZLUserInfoView?
    
    //
    private var userInfoModel : ZLGithubUserModel?              //
    
    private var serialNumber : String = ""
    
    
    deinit {
        // 注销监听
        ZLUserServiceModel.shared().unRegisterObserver(self, name: ZLGetSpecifiedUserInfoResult_Notification)
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if !(targetView is ZLUserInfoView)
        {
            ZLLog_Warn("targetView is not ZLUserInfoView");
            return
        }
        
        guard let model : ZLGithubUserModel = targetModel as? ZLGithubUserModel else
        {
            ZLLog_Warn("model is not ZLGithubUserModel");
            return
        }
        self.userInfoView = targetView as? ZLUserInfoView
        
        // 设置UI
        self.setViewDataForUserInfoView(model: model, view: targetView as! ZLUserInfoView)
        
        // 注册监听
        ZLUserServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLGetSpecifiedUserInfoResult_Notification)
        
        self.serialNumber = NSString.generateSerialNumber()
        ZLUserServiceModel.shared().getUserInfo(withLoginName: model.loginName, userType: model.type, serialNumber: self.serialNumber)
        
        self.getFollowStatus()
        self.getBlockStatus()
        
        SVProgressHUD.show()
        
    }
    

    @IBAction func onRepoButtonClicked(_ sender: Any) {
        let vc = ZLUserAdditionInfoController.init()
        vc.userInfo = self.userInfoModel
        vc.type = .repositories
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onGistsButtonClicked(_ sender: Any) {
        let vc = ZLUserAdditionInfoController.init()
        vc.userInfo = self.userInfoModel
        vc.type = .gists
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onFollowsButtonClicked(_ sender: Any) {
        let vc = ZLUserAdditionInfoController.init()
        vc.userInfo = self.userInfoModel
        vc.type = .followers
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onFollowingsButtonClicked(_ sender: Any) {
        let vc = ZLUserAdditionInfoController.init()
        vc.userInfo = self.userInfoModel
        vc.type = .following
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onBlogButtonClicked(_ sender: Any) {
        
        if self.userInfoModel?.blog == nil
        {
            return
        }
        
        let url:URL? = URL.init(string:self.userInfoModel!.blog)
        if url == nil
        {
            return;
        }
        
        let vc = ZLWebContentController.init()
        vc.requestURL = url
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onFollowButtonClicked(_ sender: UIButton) {
        if(sender.isSelected){
            self.unfollowUser()
        } else {
            self.followUser()
        }
    }
    
    @IBAction func onBlockButtonClicked(_ sender: UIButton) {
        if(sender.isSelected){
            self.unBlockUser();
        } else {
            self.BlockUser();
        }
    }
    
}


extension ZLUserInfoViewModel
{
    func setViewDataForUserInfoView(model:ZLGithubUserModel, view:ZLUserInfoView)
    {
        self.userInfoModel = model;
        
        self.viewController?.title = model.loginName
        
        view.headImageView.sd_setImage(with: URL.init(string: model.avatar_url), placeholderImage: UIImage.init(named: "default_avatar"));
        view.nameLabel.text = String("\(model.name)(\(model.loginName))")
        
        var dateStr = model.created_at
        if let date: Date = model.createdDate()
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 8 * 60 * 60) // 北京时区
            dateStr = dateFormatter.string(from: date)
        }
        let createdAtStr = ZLLocalizedString(string:"created at", comment: "创建于")
        view.createTimeLabel.text = String("\(createdAtStr) \(dateStr)")
        view.repositoryNum.text = String("\(model.public_repos + model.total_private_repos)")
        view.gistNumLabel.text = String("\(model.public_gists + model.private_gists)")
        view.followersNumLabel.text = String("\(model.followers)")
        view.followingNumLabel.text = String("\(model.following)")
        
        view.addressInfoLabel.text = model.location
        view.companyInfoLabel.text = model.company
        view.blogInfoLabel.text = model.blog
        view.emailInfoLabel.text = model.email
    }
}


extension ZLUserInfoViewModel
{
    @objc func onNotificationArrived(notification: Notification)
    {
        let operationResultModel : ZLOperationResultModel = notification.params as! ZLOperationResultModel
        
        if operationResultModel.serialNumber != self.serialNumber {
            return
        }
        
        SVProgressHUD.dismiss()
        
        if operationResultModel.result == true {
            guard let userInfo : ZLGithubUserModel = operationResultModel.data as? ZLGithubUserModel else
            {
                ZLLog_Warn("data of operationResultModel is not ZLGithubUserModel,so return")
                return
            }
            self.setViewDataForUserInfoView(model: userInfo, view: self.userInfoView!)
            
        } else {
            guard let errorModel : ZLGithubRequestErrorModel = operationResultModel.data as? ZLGithubRequestErrorModel else {
                ZLToastView.showMessage("Query User Info Failed")
                return
            }
            ZLToastView.showMessage("Query User Info Failed statusCode[\(errorModel.statusCode)] message[\(errorModel.message)]")
        }
    }
    
    
    func getFollowStatus() {
        weak var weakSelf = self
        ZLUserServiceModel.shared().getUserFollowStatus(withLoginName: self.userInfoModel!.loginName, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
            if(resultModel.result == true) {
                guard let data : [String:Bool] = resultModel.data as? [String:Bool] else {
                    return
                }
                weakSelf?.userInfoView?.followButton.isSelected = data["isFollow"] ?? false
            } else {
                
            }
        })
    }
    
    func followUser() {
        weak var weakSelf = self
        SVProgressHUD.show()
        ZLUserServiceModel.shared().followUser(withLoginName: self.userInfoModel!.loginName, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
            SVProgressHUD.dismiss()
            if(resultModel.result == true){
                weakSelf?.userInfoView?.followButton.isSelected = true
                ZLToastView.showMessage(ZLLocalizedString(string: "Follow Success", comment: ""))
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Follow Fail", comment: ""))
            }
        })
        
    }
    
    func unfollowUser() {
        weak var weakSelf = self
        SVProgressHUD.show()
        ZLUserServiceModel.shared().unfollowUser(withLoginName: self.userInfoModel!.loginName, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
            SVProgressHUD.dismiss()
            if(resultModel.result == true){
                weakSelf?.userInfoView?.followButton.isSelected = false
                ZLToastView.showMessage(ZLLocalizedString(string: "Unfollow Success", comment: ""))
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Unfollow Fail", comment: ""))
            }
        })
    }
    
    
    func getBlockStatus() {
        weak var weakSelf = self
        ZLUserServiceModel.shared().getUserBlockStatus(withLoginName: self.userInfoModel!.loginName, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
            if(resultModel.result == true) {
                guard let data : [String:Bool] = resultModel.data as? [String:Bool] else {
                    return
                }
                weakSelf?.userInfoView?.blockButton.isSelected = data["isBlock"] ?? false
            } else {
                
            }
        })
    }
    
    func BlockUser() {
        weak var weakSelf = self
        SVProgressHUD.show()
        ZLUserServiceModel.shared().blockUser(withLoginName: self.userInfoModel!.loginName, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
            SVProgressHUD.dismiss()
            if(resultModel.result == true){
                weakSelf?.userInfoView?.blockButton.isSelected = true
                ZLToastView.showMessage(ZLLocalizedString(string: "Block Success", comment: ""))
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Block Fail", comment: ""))
            }
        })
        
    }
    
    func unBlockUser() {
        weak var weakSelf = self
        SVProgressHUD.show()
        ZLUserServiceModel.shared().unBlockUser(withLoginName: self.userInfoModel!.loginName, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
            SVProgressHUD.dismiss()
            if(resultModel.result == true){
                weakSelf?.userInfoView?.blockButton.isSelected = false
                ZLToastView.showMessage(ZLLocalizedString(string: "Unblock Success", comment: ""))
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Unblock Fail", comment: ""))
            }
        })
    }
    
    
}
