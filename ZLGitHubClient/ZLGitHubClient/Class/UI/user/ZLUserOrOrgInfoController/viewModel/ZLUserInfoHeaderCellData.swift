//
//  ZLUserInfoHeaderCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/6.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLUserInfoHeaderCellData: ZLGithubItemTableViewCellData {
    
    // data
    private var data: ZLGithubUserModel
    private var _followStatus: Bool = false
    private var _blockStatus: Bool = false
    
    // block
    private var reloadViewBlock: (() -> Void)?

    init(data: ZLGithubUserModel){
        self.data = data
        super.init()
        
        setUp()
    }
    
    
    override func update(_ targetModel: Any?) {
        guard let data = targetModel as? ZLGithubUserModel else {
            return
        }
        self.data = data
        setUp()
    }
    
    private func setUp(){
        
        if showBlockButton {
            getBlockStatus()
        }
        if showFollowButton {
            getFollowStatus()
        }
    }
    
    override func getCellReuseIdentifier() -> String {
        "ZLUserInfoHeaderCell"
    }
    
    override func getCellHeight() -> CGFloat {
        UITableView.automaticDimension
    }
}

// request 
extension ZLUserInfoHeaderCellData {
    
    func getFollowStatus() {
        
        ZLServiceManager.sharedInstance.userServiceModel?.getUserFollowStatus(withLoginName: data.loginName ?? "",
                                                                              serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel : ZLOperationResultModel) in
            guard let self = self else { return }
            if resultModel.result,
                let data : [String:Bool] = resultModel.data as? [String:Bool] {
                self._followStatus = data["isFollow"] ?? false
                self.reloadViewBlock?()
            }
        }
    }
    
    func followUser() {
        
        SVProgressHUD.show()
        ZLServiceManager.sharedInstance.userServiceModel?.followUser(withLoginName: data.loginName ?? "",
                                                                     serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel : ZLOperationResultModel) in
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            if(resultModel.result == true){
                self._followStatus = true
                self.reloadViewBlock?()
                ZLToastView.showMessage(ZLLocalizedString(string: "Follow Success", comment: ""))
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Follow Fail", comment: ""))
            }
        }
        
    }
    
    func unfollowUser() {
        
        SVProgressHUD.show()
        ZLServiceManager.sharedInstance.userServiceModel?.unfollowUser(withLoginName:data.loginName ?? "",
                                                                       serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel : ZLOperationResultModel) in
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            if resultModel.result {
                self._followStatus = false
                self.reloadViewBlock?()
                ZLToastView.showMessage(ZLLocalizedString(string: "Unfollow Success", comment: ""))
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Unfollow Fail", comment: ""))
            }
        }
    }
    
    
    func getBlockStatus() {
        
        ZLServiceManager.sharedInstance.userServiceModel?.getUserBlockStatus(withLoginName: data.loginName ?? "",
                                                                             serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel : ZLOperationResultModel) in
            
            guard let self = self else { return }
            if(resultModel.result == true) {
                guard let data : [String:Bool] = resultModel.data as? [String:Bool] else {
                    return
                }
                self._blockStatus = data["isBlock"] ?? false
                self.reloadViewBlock?()
            }
        }
    }
    
    func BlockUser() {
        
        SVProgressHUD.show()
        ZLServiceManager.sharedInstance.userServiceModel?.blockUser(withLoginName: data.loginName ?? "",
                                                                    serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel : ZLOperationResultModel) in
            
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            if(resultModel.result == true){
                self._blockStatus = true
                self.reloadViewBlock?()
                ZLToastView.showMessage(ZLLocalizedString(string: "Block Success", comment: ""))
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Block Fail", comment: ""))
            }
        }
    }
    
    func unBlockUser() {
        
        SVProgressHUD.show()
        ZLServiceManager.sharedInstance.userServiceModel?.unBlockUser(withLoginName: data.loginName ?? "",
                                                                      serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel : ZLOperationResultModel) in
            
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            if resultModel.result {
                self._blockStatus = false
                self.reloadViewBlock?()
                ZLToastView.showMessage(ZLLocalizedString(string: "Unblock Success", comment: ""))
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Unblock Fail", comment: ""))
            }
        }
    }
    
}


extension ZLUserInfoHeaderCellData: ZLUserInfoHeaderCellDataSourceAndDelegate {
       
    var name: String{
        return "\(data.name ?? "")(\(data.loginName ?? ""))"
    }
    
    var time: String {
        let createdAtStr = ZLLocalizedString(string:"created at", comment: "创建于")
        return "\(createdAtStr) \((data.created_at as NSDate?)?.dateStrForYYYYMMdd() ?? "")"
    }
    
    var desc: String {
        data.bio ?? ""
    }
    
    var avatarUrl: String {
        data.avatar_url ?? ""
    }
    
    var reposNum: String {
        if data.repositories >= 1000 {
            return String(format: "%.1f",Double(data.repositories) / 1000.0) + "k"
        } else {
            return "\(data.repositories)"
        }
    }
    
    var gistsNum: String {
        if data.gists >= 1000 {
            return String(format: "%.1f",Double(data.gists) / 1000.0) + "k"
        } else {
            return "\(data.gists)"
        }
    }
    
    var followersNum: String {
        if data.followers >= 1000 {
            return String(format: "%.1f",Double(data.followers) / 1000.0) + "k"
        } else {
            return "\(data.followers)"
        }
    }
    
    var followingNum: String {
        if data.following >= 1000 {
            return String(format: "%.1f",Double(data.following) / 1000.0) + "k"
        } else {
            return "\(data.following)"
        }
    }
    
    var showBlockButton: Bool {
        var showBlockButton = ZLSharedDataManager.sharedInstance().configModel?.BlockFunction ?? true
        let currentLoginName = ZLServiceManager.sharedInstance.viewerServiceModel?.currentUserLoginName
        if currentLoginName == "ExistOrLive1" ||
            currentLoginName == "existorlive3" ||
            currentLoginName == "existorlive11"{
            showBlockButton = true
        }
        if currentLoginName == data.loginName {
            showBlockButton = false
        }
        return showBlockButton
    }
    
    var showFollowButton: Bool {
        let currentLoginName = ZLServiceManager.sharedInstance.viewerServiceModel?.currentUserLoginName
        return currentLoginName != data.loginName
    }
    
    var blockStatus: Bool {
        _blockStatus
    }
    var followStatus: Bool {
        _followStatus
    }
    
    func onFollowButtonClicked(){
        if self._followStatus {
            unfollowUser()
        } else {
            followUser()
        }
    }
    func onBlockButtonClicked(){
        if self._blockStatus {
            unBlockUser()
        } else {
            BlockUser()
        }
    }

    func onReposNumButtonClicked(){
        if let login = data.loginName,
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController,
                                     params: ["login":login,"type":ZLUserAdditionInfoType.repositories.rawValue]) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func onGistsNumButtonClicked(){
        if let login = data.loginName,
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController,
                                     params: ["login":login,"type":ZLUserAdditionInfoType.gists.rawValue]) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func onFollowsNumButtonClicked(){
        if let login = data.loginName,
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController, params: ["login":login,"type":ZLUserAdditionInfoType.followers.rawValue]) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func onFollowingNumButtonClicked(){
        if let login = data.loginName,
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController, params: ["login":login,"type":ZLUserAdditionInfoType.following.rawValue]) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setUserInfoHeaderCallback(callBack: @escaping () -> Void){
        self.reloadViewBlock = callBack
    }
    
}
