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
    private var repoFooterInfoViewModel: ZLRepoFooterInfoViewModel?
    
    // 当前repo请求流水号
    private var serialNumber: String?
    
    
    deinit {
        ZLRepoServiceModel.shared().unRegisterObserver(self, name: ZLGetSpecifiedRepoInfoResult_Notification)
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
        
        self.setViewDataForRepoInfoView()
        
        ZLRepoServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLGetSpecifiedRepoInfoResult_Notification)
        
        // 获取仓库的详细信息
        SVProgressHUD.show()
        self.serialNumber = NSString.generateSerialNumber() as String
        ZLRepoServiceModel.shared().getRepoInfo(withFullName: repoInfoModel.full_name, serialNumber: self.serialNumber!)
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
        
        if self.repoFooterInfoViewModel == nil{
            self.repoFooterInfoViewModel = ZLRepoFooterInfoViewModel()
            self.addSubViewModel(self.repoFooterInfoViewModel!)
        }
        self.repoFooterInfoViewModel?.bindModel(self.repoInfoModel,andView:self.repoInfoView!.footerView!)
        
        
        
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
            
            if operationResultModel.serialNumber != operationResultModel.serialNumber
            {
                return;
            }
            
            SVProgressHUD.dismiss()
            
            guard let repoInfo : ZLGithubRepositoryModel = operationResultModel.data as? ZLGithubRepositoryModel else
            {
                ZLLog_Warn("data of operationResultModel is not ZLGithubRepositoryModel,so return")
                return
            }
            
            self.repoInfoModel = repoInfo
            
            self.setViewDataForRepoInfoView()
            }
        default:
            break;
        }
        
      
    }
}
