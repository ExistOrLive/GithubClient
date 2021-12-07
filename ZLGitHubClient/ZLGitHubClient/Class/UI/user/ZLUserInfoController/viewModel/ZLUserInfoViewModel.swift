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
    private weak var userInfoView: ZLUserInfoView?
    
    // model
    private var userInfoModel : ZLGithubUserModel?            //
    
    // subViewModel
    private var subViewModelArray: [[ZLGithubItemTableViewCellData]] = []
    
    // viewCallBack
    private var viewCallback: (() -> Void)?
    
    
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
        
        generateSubViewModel()
        
        userInfoView?.fillWithData(delegateAndDataSource: self)
        
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
    }
    
    override func update(_ targetModel: Any?) {
        
        guard let model : ZLGithubUserModel = targetModel as? ZLGithubUserModel else{
            ZLLog_Warn("model is not ZLGithubUserModel");
            return
        }
        userInfoModel = model
        
        generateSubViewModel()
        
        viewCallback?()
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
        
        
        // twitter
//        if let twitter = model.twitter_username,
//           !twitter.isEmpty {
//
//            let cellData = ZLCommonTableViewCellData(canClick: true,
//                                                     title: ZLLocalizedString(string: "twitter", comment: ""),
//                                                     info: twitter,
//                                                     cellHeight: 50)
//           itemCellDatas.append(cellData)
//        }
        
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
        
        self.addSubViewModels(itemCellDatas)
        
        self.subViewModelArray.append(itemCellDatas)
        
        
    }
    
    
    @objc func onMoreButtonClick(button : UIButton) {
        
        if self.userInfoModel?.html_url == nil {
            return
        }
        
        let alertVC = UIAlertController.init(title: self.userInfoModel?.loginName, message: nil, preferredStyle: .actionSheet)
        alertVC.popoverPresentationController?.sourceView = button
        let alertAction1 = UIAlertAction.init(title: ZLLocalizedString(string: "View in Github", comment: ""), style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            if let url = URL.init(string: self.userInfoModel?.html_url ?? "") {
                ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,params: ["requestURL":url])
            }
        }
        let alertAction2 = UIAlertAction.init(title: ZLLocalizedString(string: "Open in Safari", comment: ""), style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            if let url =  URL.init(string: self.userInfoModel?.html_url ?? "") {
                UIApplication.shared.open(url, options: [:], completionHandler: {(result : Bool) in})
            }
        }
        
        let alertAction3 = UIAlertAction.init(title: ZLLocalizedString(string: "Share", comment: ""), style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            if let url =  URL.init(string: self.userInfoModel?.html_url ?? "") {
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
    
}

extension ZLUserInfoViewModel: ZLUserInfoViewDelegateAndDataSource {
    
    var cellDatas: [[ZLGithubItemTableViewCellDataProtocol]] {
        return self.subViewModelArray
    }
    
    func setCallBack(callback: @escaping () -> Void){
        viewCallback = callback
    }
    
    func loadNewData() {
        
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
                    self.userInfoModel = model
                }
            } else {
                
                if let model = model.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage("Get User Info Failed \(model.message)")
                }
            }

            self.viewCallback?()
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

extension ZLUserInfoViewModel {
    
    
    // MARK: ZLReadmeViewDelegate
    
//    func onLinkClicked(url : URL?) -> Void {
//        if let realurl = url {
//            ZLUIRouter.openURL(url: realurl)
//        }
//    }
//
//    func getReadMeContent(result: Bool) {
//        if result == true {
//            self.userInfoView.readMeView?.isHidden = false
//        }
//    }
}
