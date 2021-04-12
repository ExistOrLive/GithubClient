//
//  ZLRepoHeaderInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/2.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoHeaderInfoViewModel: ZLBaseViewModel {
    
    // model
    private var repoInfoModel : ZLGithubRepositoryModel!
    
    // view
    private var repoHeaderInfoView : ZLRepoHeaderInfoView!
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: ZLLanguageTypeChange_Notificaiton, object: nil)
        NotificationCenter.default.removeObserver(self, name: ZLUserInterfaceStyleChange_Notification, object: nil)
    }

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ZLRepoHeaderInfoViewModel.onNotificaitonArrived(notification:)), name: ZLLanguageTypeChange_Notificaiton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ZLRepoHeaderInfoViewModel.onNotificaitonArrived(notification:)), name: ZLUserInterfaceStyleChange_Notification, object: nil)
        
        guard let repoInfoModel : ZLGithubRepositoryModel = targetModel as? ZLGithubRepositoryModel else {
            return
        }
        self.repoInfoModel = repoInfoModel
        
        guard let repoHeaderInfoView : ZLRepoHeaderInfoView = targetView as? ZLRepoHeaderInfoView else
        {
            return
        }
        self.repoHeaderInfoView = repoHeaderInfoView

        
    
        self.setViewDataForRepoHeaderInfoView()
        
        self.getRepoWatchStatus()
        self.getRepoStarStatus()
    }
    
    override func update(_ targetModel: Any?) {
        
        guard let repoInfoModel : ZLGithubRepositoryModel = targetModel as? ZLGithubRepositoryModel else {
            return
        }
        self.repoInfoModel = repoInfoModel
        
        self.repoHeaderInfoView.reloadData()
    }
    
    
     func setViewDataForRepoHeaderInfoView(){
        self.repoHeaderInfoView.fillWithData(delegate: self)
     }
}

extension ZLRepoHeaderInfoViewModel {
    @objc func onNotificaitonArrived(notification:Notification) {
        switch notification.name{
        case .ZLLanguageTypeChange_Notificaiton:do{
            self.repoHeaderInfoView?.justUpdate()
        }
        case ZLUserInterfaceStyleChange_Notification:do{
            self.repoHeaderInfoView.reloadData()
        }
        default:
            break
        }
    }
}



extension ZLRepoHeaderInfoViewModel : ZLRepoHeaderInfoViewDelegate
{
    var avatarUrl: String? {
        repoInfoModel.owner?.avatar_url
    }
    
    var repoName: NSAttributedString? {
        
        var tmpColor1 = ZLRGBValue_H(colorValue: 0x333333)
        var tmpColor2 = ZLRGBValue_H(colorValue: 0x666666)
        if #available(iOS 12.0, *){
            tmpColor1 = (getRealUserInterfaceStyle() == .light) ? ZLRGBValue_H(colorValue: 0x333333) : ZLRGBValue_H(colorValue: 0xCCCCCC)
            tmpColor2 = (getRealUserInterfaceStyle() == .light) ? ZLRGBValue_H(colorValue: 0x666666) : ZLRGBValue_H(colorValue: 0x999999)
        }
        
        
        if self.repoInfoModel.sourceRepoFullName?.count ?? 0 != 0 {
            
            let attributedStr = NSMutableAttributedString.init(string: self.repoInfoModel?.full_name ?? "",
                                                               attributes: [NSAttributedString.Key.foregroundColor:tmpColor1,NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCMedium, size: 16)!])
            
            let forkStr = NSMutableAttributedString.init(string: "\nforked from ",
                                                         attributes: [NSAttributedString.Key.foregroundColor:tmpColor2,NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCMedium, size: 13)!])
            
            attributedStr.append(forkStr)
            
            let sourceRepoStr = NSMutableAttributedString.init(string: self.repoInfoModel?.sourceRepoFullName ?? "", attributes: [NSAttributedString.Key.foregroundColor:tmpColor1,NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCMedium, size: 13)!])
            
            sourceRepoStr.yy_setTextHighlight(NSRange.init(location: 0, length: self.repoInfoModel?.sourceRepoFullName?.count ?? 0),
                                              color: ZLRawColor(name: "ZLLinkLabelColor1"),
                                              backgroundColor: ZLRawColor(name: "ZLLinkLabelColor1"))
            {[weak weakSelf = self](containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
                
                if let repoFullName = weakSelf?.repoInfoModel?.sourceRepoFullName,let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                    vc.hidesBottomBarWhenPushed = true
                    weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            attributedStr.append(sourceRepoStr)
            
            return attributedStr
            
        } else {
            let attributedStr = NSMutableAttributedString.init(string: self.repoInfoModel?.full_name ?? "", attributes: [NSAttributedString.Key.foregroundColor:tmpColor1,NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCMedium, size: 16) ?? UIFont.systemFont(ofSize: 16)])
            return attributedStr
        }
    }
    
    var updatedTime: String? {
        guard let date : NSDate = self.repoInfoModel.updated_at as NSDate? else{
            return nil
        }
        return "\(ZLLocalizedString(string: "update at", comment: "更新于"))\(date.dateLocalStrSinceCurrentTime())"
    }
    
    var desc: String? {
        repoInfoModel.desc_Repo
    }
    
    var issueNum: Int {
        repoInfoModel.open_issues_count
    }
    
    var starsNum: Int {
        repoInfoModel.stargazers_count
    }
    
    var forksNum: Int {
        repoInfoModel.forks_count
    }
    
    var watchersNum: Int {
        repoInfoModel.subscribers_count
    }
    
    func onZLRepoHeaderInfoViewEvent(event: ZLRepoHeaderInfoViewEvent){
        switch event{
        case .copy: do {
            let vc : ZLRepoForkedReposController = ZLRepoForkedReposController.init()
            vc.repoFullName = self.repoInfoModel?.full_name
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        case .issue: do {
            let vc : ZLRepoIssuesController = ZLRepoIssuesController.init()
            vc.repoFullName = self.repoInfoModel?.full_name
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        case .star: do {
            let vc : ZLRepoStargazersController = ZLRepoStargazersController.init()
            vc.repoFullName = self.repoInfoModel?.full_name
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        case .watch: do {
            let vc : ZLRepoWatchedUsersController = ZLRepoWatchedUsersController.init()
            vc.repoFullName = self.repoInfoModel?.full_name
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        case .watchAction:do{
            if self.repoHeaderInfoView?.watchButton.isSelected == true {
                self.watchRepo(watch: false)
            } else {
                self.watchRepo(watch: true)
            }
            }
        case .starAction:do {
            if self.repoHeaderInfoView?.starButton.isSelected == true {
                self.starRepo(star: false)
            } else {
                self.starRepo(star: true)
            }
        }
        case .forkAction:do {
            self.forkRepo()
        }
        case .imageAction:do{
            if self.repoInfoModel.owner?.loginName != nil {
                if let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName:self.repoInfoModel.owner!.loginName!) {
                    userInfoVC.hidesBottomBarWhenPushed = true
                    self.viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
                }
            }
        }
            
        }
    }
}

extension ZLRepoHeaderInfoViewModel{
    
    func getRepoWatchStatus() -> Void {
     
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoWatchStatus(withFullName: self.repoInfoModel.full_name!,
                                                                             serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel : ZLOperationResultModel) in
            
            if(resultModel.result) {
                guard let data : [String:Bool] = resultModel.data as? [String:Bool] else {
                    return
                }
                self?.repoHeaderInfoView?.watchButton.isSelected = data["isWatch"] ?? false
            }
        }
    }
    
    
    func watchRepo(watch:Bool) -> Void {
        
        if watch == true {
            
            SVProgressHUD.show()
            ZLServiceManager.sharedInstance.repoServiceModel?.watchRepo(withFullName: self.repoInfoModel.full_name!,
                                                                        serialNumber: NSString.generateSerialNumber())
            {[weak self](resultModel : ZLOperationResultModel) in
                SVProgressHUD.dismiss()
                if resultModel.result {
                    self?.repoHeaderInfoView?.watchButton.isSelected = true
                    ZLToastView.showMessage(ZLLocalizedString(string: "Watch Success", comment: ""))
                } else {
                    ZLToastView.showMessage(ZLLocalizedString(string: "Watch Fail", comment: ""))
                }
            }
            
        } else {
            SVProgressHUD.show()
            ZLServiceManager.sharedInstance.repoServiceModel?.unwatchRepo(withFullName: self.repoInfoModel.full_name!,
                                                                          serialNumber: NSString.generateSerialNumber())
            {[weak self](resultModel : ZLOperationResultModel) in
                SVProgressHUD.dismiss()
                if resultModel.result {
                    self?.repoHeaderInfoView?.watchButton.isSelected = false
                    ZLToastView.showMessage(ZLLocalizedString(string: "Unwatch Success", comment: ""))
                } else {
                    ZLToastView.showMessage(ZLLocalizedString(string: "Unwatch Fail", comment: ""))
                }
            }
        }
    }
    
    
    func getRepoStarStatus() -> Void {
     
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoStarStatus(withFullName: self.repoInfoModel.full_name!,
                                                                            serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel : ZLOperationResultModel) in
            
            if(resultModel.result) {
                guard let data : [String:Bool] = resultModel.data as? [String:Bool] else {
                    return
                }
                self?.repoHeaderInfoView?.starButton.isSelected = data["isStar"] ?? false
            }
        }
    }
    
    
    func starRepo(star:Bool) -> Void {
        
        if star == true {
            SVProgressHUD.show()
            
            ZLServiceManager.sharedInstance.repoServiceModel?.starRepo(withFullName: self.repoInfoModel.full_name!,
                                                                       serialNumber: NSString.generateSerialNumber())
            {[weak self](resultModel : ZLOperationResultModel) in
                SVProgressHUD.dismiss()
                
                if resultModel.result {
                    self?.repoHeaderInfoView?.starButton.isSelected = true
                    ZLToastView.showMessage(ZLLocalizedString(string: "Star Success", comment: ""))
                } else {
                    ZLToastView.showMessage(ZLLocalizedString(string: "Star Fail", comment: ""))
                }
            }
            
        } else {
            SVProgressHUD.show()
            ZLServiceManager.sharedInstance.repoServiceModel?.unstarRepo(withFullName: self.repoInfoModel.full_name!,
                                                                         serialNumber: NSString.generateSerialNumber())
            {[weak self](resultModel : ZLOperationResultModel) in
                SVProgressHUD.dismiss()
                if resultModel.result {
                    self?.repoHeaderInfoView?.starButton.isSelected = false
                    ZLToastView.showMessage(ZLLocalizedString(string: "Unstar Success", comment: ""))
                } else {
                    ZLToastView.showMessage(ZLLocalizedString(string: "Unstar Fail", comment: ""))
                }
            }
            
        }
    }
    
    
    func forkRepo() {
        
        SVProgressHUD.show()
        
        ZLServiceManager.sharedInstance.repoServiceModel?.forkRepository(withFullName: self.repoInfoModel.full_name!,
                                                                         org: nil,
                                                                         serialNumber: NSString.generateSerialNumber())
        {(resultModel : ZLOperationResultModel) in
            SVProgressHUD.dismiss()
            
            if(resultModel.result) {
                ZLToastView.showMessage(ZLLocalizedString(string: "Fork Success", comment: "拷贝成功"))
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Fork Fail", comment: "拷贝失败"))
            }
        }
    }
    
}
