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
    
    // model
    private var userInfoModel: ZLGithubUserModel?            //
    private var pinnedRepositories: [ZLGithubRepositoryBriefModel] = []
    
    // subViewModel
    private var subViewModelArray: [[ZLGithubItemTableViewCellData]] = []
    
    // viewCallBack
    private var viewCallback: (() -> Void)?
    private var readMeCallback: (() -> Void)?
    
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
        
        guard let model : ZLGithubUserModel = targetModel as? ZLGithubUserModel else{
            ZLLog_Warn("model is not ZLGithubUserModel");
            return
        }
        userInfoModel = model
        
        generateSubViewModel()
        
        view.fillWithData(delegateAndDataSource: self)
        
        getUserPinnedRepos()
    }
    
    override func update(_ targetModel: Any?) {
        
        guard let model : ZLGithubUserModel = targetModel as? ZLGithubUserModel else{
            ZLLog_Warn("model is not ZLGithubUserModel");
            return
        }
        userInfoModel = model
        
        generateSubViewModel()
        
        viewCallback?()
        readMeCallback?()
        
        getUserPinnedRepos()
    }
    
    
    func generateSubViewModel() {
        
        guard let model = userInfoModel else { return }
        
        self.subViewModelArray.removeAll()
        
        for subViewModel in self.subViewModels {
            subViewModel.removeFromSuperViewModel()
        }
        
        // headerCellData
        let headerCellData = ZLUserInfoHeaderCellData(data: model)
        self.subViewModelArray.append([headerCellData])
        self.addSubViewModel(headerCellData)
        
        
        // contributionCellData
        let contributionCellData = ZLUserContributionsCellData(loginName: model.loginName ?? "")
        self.subViewModelArray.append([contributionCellData])
        self.addSubViewModel(contributionCellData)
        
        
        var itemCellDatas = [ZLGithubItemTableViewCellData]()
        
        // company
        if let company = model.company,
           !company.isEmpty {
             let cellData = ZLCommonTableViewCellData(canClick: false,
                                                      title: ZLLocalizedString(string: "company", comment: ""),
                                                      info: company,
                                                      cellHeight: 50)
            itemCellDatas.append(cellData)
        }
        
        // address
        if let location = model.location,
           !location.isEmpty {
            let cellData = ZLCommonTableViewCellData(canClick: false,
                                                     title: ZLLocalizedString(string: "location", comment: ""),
                                                     info: location,
                                                     cellHeight: 50)
           itemCellDatas.append(cellData)
        }
        
        // email
        if let email = model.email,
           !email.isEmpty {
            
            let cellData = ZLCommonTableViewCellData(canClick: true,
                                                     title: ZLLocalizedString(string: "email", comment: ""),
                                                     info: email,
                                                     cellHeight: 50) {
                
                if let url = URL(string: "mailto:\(email)"),
                   UIApplication.shared.canOpenURL(url){
                    
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
           itemCellDatas.append(cellData)
        }
        
        // blog
        if let blog = model.blog,
           !blog.isEmpty {
            
            let cellData = ZLCommonTableViewCellData(canClick: true,
                                                     title: ZLLocalizedString(string: "blog", comment: ""),
                                                     info: blog,
                                                     cellHeight: 50) {
                
                if let url = URL.init(string:blog) {
                    ZLUIRouter.navigateVC(key:ZLUIRouter.WebContentController,
                                          params: ["requestURL":url],
                                          animated: true)
                }
            }
           itemCellDatas.append(cellData)
        }
        
        if !itemCellDatas.isEmpty {
            self.addSubViewModels(itemCellDatas)
            self.subViewModelArray.append(itemCellDatas)
        }
        
        if !pinnedRepositories.isEmpty {
            let pinnedReposCellData = ZLPinnedRepositoriesTableViewCellData(repos: pinnedRepositories)
            self.addSubViewModel(pinnedReposCellData)
            self.subViewModelArray.append([pinnedReposCellData])
        }
    }
    
}

// MARK: ZLUserInfoViewDelegateAndDataSource
extension ZLUserInfoViewModel: ZLUserInfoViewDelegateAndDataSource {
    
    var html_url: String? {
        userInfoModel?.html_url
    }
    
    var loginName: String {
        userInfoModel?.loginName ?? ""
    }
    
    func onLinkClicked(url: URL?) {
        if let realurl = url {
            ZLUIRouter.openURL(url: realurl)
        }
    }
    
    
    var cellDatas: [[ZLGithubItemTableViewCellDataProtocol]] {
        return self.subViewModelArray
    }
    
    func setCallBack(callback: @escaping () -> Void){
        viewCallback = callback
    }
    
    func setReadMeCallBack(callback: @escaping () -> Void) {
        readMeCallback = callback
    }
    
    func loadNewData() {
        
        guard let _ = userInfoModel?.loginName else {
            ZLToastView.showMessage("login name is nil")
            viewCallback?()
            return
        }
        
        getUserInfo()
    }
}

// MARK: Request
extension ZLUserInfoViewModel {
    
    func getUserInfo() {
        
        guard let loginName = userInfoModel?.loginName else {
            ZLToastView.showMessage("login name is nil")
            viewCallback?()
            return
        }
        
        ZLServiceManager.sharedInstance.userServiceModel?.getUserInfo(withLoginName: loginName,
                                                                      serialNumber: NSString.generateSerialNumber())
        { [weak self] model in
            
            guard let self = self else { return }
            
            if model.result {
                
                if let model = model.data as? ZLGithubUserModel {
                    self.update(model)
                }
            } else {
                
                if let model = model.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage("Get User Info Failed \(model.message)")
                }
            }

            self.viewCallback?()
        }
    }
    
    
    func getUserPinnedRepos() {
        
        guard let loginName = userInfoModel?.loginName else {
            return
        }
        
        ZLServiceManager.sharedInstance.userServiceModel?.getUserPinnedRepositories(loginName,
                                                                                    serialNumber: NSString.generateSerialNumber())
        { [weak self] model in
            
            guard let self = self else  { return }
            
            if model.result {
                if let data = model.data as? [ZLGithubRepositoryBriefModel] {
                    self.pinnedRepositories = data
                    self.generateSubViewModel()
                    self.viewCallback?()
                }
            } else {
                if let model = model.data as? ZLGithubRequestErrorModel {
                    ZLLog_Info(model.message)
                }
            }
        }
    }
}


extension ZLUserInfoViewModel
{
    @objc func onNotificationArrived(notification: Notification)
    {
//        switch notification.name {
//        case ZLLanguageTypeChange_Notificaiton:do{
//            self.userInfoView?.justUpdate()
//        }
//        case ZLUserInterfaceStyleChange_Notification:do{
//            self.userInfoView?.readMeView?.reRender()
//        }
//        default:
//            break
//        }
    }
}
