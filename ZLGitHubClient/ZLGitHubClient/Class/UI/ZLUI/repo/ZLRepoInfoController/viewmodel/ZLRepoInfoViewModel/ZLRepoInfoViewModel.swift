//
//  ZLRepoInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

enum ZLRepoInfoItemType : Int {
    case file                   // 仓库文件
    case pullRequest            // pullrequest
    case branch                 // 分支
}

class ZLRepoInfoViewModel: ZLBaseViewModel {
    
    // view
    private var repoInfoView : ZLRepoInfoView?
    
    // model
    private var repoInfoModel : ZLGithubRepositoryModel?
    
    
    // subViewModel
    private var repoHeaderInfoViewModel : ZLRepoHeaderInfoViewModel?
    private var repoItemInfoViewModel : ZLRepoItemInfoViewModel?
    
    // 当前repo请求流水号
    private var serialNumber: String?
    
    
    deinit {
        ZLServiceManager.sharedInstance.repoServiceModel?.unRegisterObserver(self, name: ZLGetSpecifiedRepoInfoResult_Notification)
        NotificationCenter.default.removeObserver(self, name: ZLLanguageTypeChange_Notificaiton, object: nil)
        NotificationCenter.default.removeObserver(self, name: ZLUserInterfaceStyleChange_Notification, object: nil)
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if !(targetView is ZLRepoInfoView)
        {
            ZLLog_Warn("targetView is not ZLRepoInfoView")
            return
        }
        self.repoInfoView = targetView as? ZLRepoInfoView
    
        guard let repoInfoModel: ZLGithubRepositoryModel = targetModel as? ZLGithubRepositoryModel else
        {
            ZLLog_Warn("targetModel is not ZLGithubRepositoryModel,so return")
            return
        }
        self.repoInfoModel = repoInfoModel
        
        ZLServiceManager.sharedInstance.repoServiceModel?.registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLGetSpecifiedRepoInfoResult_Notification)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLLanguageTypeChange_Notificaiton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLUserInterfaceStyleChange_Notification, object: nil)
        
    
        self.setViewDataForRepoInfoView()
        
        self.repoInfoView!.readMeView?.startLoad(fullName: self.repoInfoModel!.full_name, branch: nil)
        
        // 获取仓库的详细信息
        SVProgressHUD.show()
        self.serialNumber = NSString.generateSerialNumber()
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoInfo(withFullName: repoInfoModel.full_name, serialNumber: self.serialNumber!)
        
        if let vc = self.viewController {
            vc.zlNavigationBar.backButton.isHidden = false
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage.init(named: "run_more"), for: .normal)
            button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
            button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)
            
            vc.zlNavigationBar.rightButton = button
        }
    }
}


extension ZLRepoInfoViewModel
{
    func setViewDataForRepoInfoView()
    {
        self.viewController?.title = self.repoInfoModel?.name == nil ? "Repo" : self.repoInfoModel?.name
        
        if self.repoHeaderInfoViewModel == nil{
            self.repoHeaderInfoViewModel = ZLRepoHeaderInfoViewModel()
            self.addSubViewModel(self.repoHeaderInfoViewModel!)
        }
        self.repoHeaderInfoViewModel?.bindModel(self.repoInfoModel,andView:self.repoInfoView!.headerView!)
        
        if self.repoItemInfoViewModel == nil{
            self.repoItemInfoViewModel = ZLRepoItemInfoViewModel()
            self.addSubViewModel(self.repoItemInfoViewModel!)
        }
        self.repoItemInfoViewModel?.bindModel(self.repoInfoModel,andView:self.repoInfoView!.itemView!)
        
        self.repoInfoView?.readMeView?.delegate = self
    }
}

extension ZLRepoInfoViewModel
{
    @objc func onNotificationArrived(notification: Notification)
    {
        switch(notification.name)
        {
        case ZLGetSpecifiedRepoInfoResult_Notification:do
        {
            let operationResultModel : ZLOperationResultModel = notification.params as! ZLOperationResultModel
            
            if operationResultModel.serialNumber != self.serialNumber
            {
                return;
            }
            
            SVProgressHUD.dismiss()
            
            if operationResultModel.result == true {
                guard let repoInfo : ZLGithubRepositoryModel = operationResultModel.data as? ZLGithubRepositoryModel else
                {
                    ZLLog_Warn("data of operationResultModel is not ZLGithubRepositoryModel,so return")
                    return
                }
                self.repoInfoModel = repoInfo
                self.setViewDataForRepoInfoView()
            } else {
                guard let errorInfo : ZLGithubRequestErrorModel = operationResultModel.data as? ZLGithubRequestErrorModel else
                {
                    ZLToastView.showMessage("query repo info failed")
                    return
                }
                ZLToastView.showMessage("query repo info failed statusCode[\(errorInfo.statusCode)] errorMessage[\(errorInfo.message)]")
            }
            
        
            }
        case ZLLanguageTypeChange_Notificaiton:do{
            self.repoInfoView?.justUpdate()
        }
        case ZLUserInterfaceStyleChange_Notification:do{
            self.repoInfoView?.readMeView?.reRender()
        }
        default:
            break;
        }
    }
    
    @objc func onMoreButtonClick(button : UIButton) {
        
        if self.repoInfoModel?.html_url == nil {
            return
        }
        
        let alertVC = UIAlertController.init(title: self.repoInfoModel?.full_name, message: nil, preferredStyle: .actionSheet)
        alertVC.popoverPresentationController?.sourceView = button
        let alertAction1 = UIAlertAction.init(title:ZLLocalizedString(string: "View in Github", comment: ""), style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            let webContentVC = ZLWebContentController.init()
            webContentVC.requestURL = URL.init(string: self.repoInfoModel!.html_url)
            self.viewController?.navigationController?.pushViewController(webContentVC, animated: true)
        }
        let alertAction2 = UIAlertAction.init(title: ZLLocalizedString(string: "Open in Safari", comment: ""), style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            let url =  URL.init(string: self.repoInfoModel!.html_url)
            if url != nil {
                UIApplication.shared.open(url!, options: [:], completionHandler: {(result : Bool) in})
            }
        }
        
        let alertAction3 = UIAlertAction.init(title: ZLLocalizedString(string: "Share", comment: ""), style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            let url =  URL.init(string: self.repoInfoModel!.html_url)
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

extension ZLRepoInfoViewModel : ZLReadMeViewDelegate{
    
    func onLinkClicked(url : URL?) -> Void{
        if url != nil {
            let vc = ZLWebContentController.init()
            vc.requestURL = url
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
