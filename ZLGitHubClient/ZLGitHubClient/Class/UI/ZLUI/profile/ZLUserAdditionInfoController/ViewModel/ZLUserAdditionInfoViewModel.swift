//
//  ZLUserAdditionInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLUserAdditionInfoViewModel: ZLBaseViewModel {
    
    static let per_page: UInt = 10                            // 每页多少记录
    
    // model
    var type : ZLUserAdditionInfoType?              // info类型
    var userInfo : ZLGithubUserModel?               // 用户信息
    var currentPage : Int  =  0                     // 当前页号
    var serialNumber: String?                       // 当前请求的流水号
    
    var isResetData : Bool  =  false               // 是否重置数据
    
    // view
    var baseView : ZLUserAdditionInfoView?
    
    
    deinit {
        // 注销监听
        ZLServiceManager.sharedInstance.additionServiceModel?.unRegisterObserver(self, name:ZLGetReposResult_Notification);
        ZLServiceManager.sharedInstance.additionServiceModel?.unRegisterObserver(self, name:ZLGetFollowingResult_Notification);
        ZLServiceManager.sharedInstance.additionServiceModel?.unRegisterObserver(self, name:ZLGetFollowersResult_Notification);
        ZLServiceManager.sharedInstance.additionServiceModel?.unRegisterObserver(self, name: ZLGetGistsResult_Notification)
    }

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
       
        //1、 保存baseView 和 model 
        if !(targetView is ZLUserAdditionInfoView)
        {
            ZLLog_Warn("targetView is not ZLUserAdditionInfoView")
            return;
        }
        self.baseView = targetView as? ZLUserAdditionInfoView;
        
        if targetModel == nil || !(targetModel! is [String : Any])
        {
            ZLLog_Warn("targetModel is not valid")
            return;
        }
        
        let dic: [String : Any] = targetModel as! [String : Any]
        self.type = dic["type"] as? ZLUserAdditionInfoType
        self.userInfo = dic["userInfo"] as? ZLGithubUserModel
        
        // 2、 注册对于 ZLAdditionInfoServiceModel 通知的监听
        ZLServiceManager.sharedInstance.additionServiceModel?.registerObserver(self, selector: #selector(self.onNotificationArrived(notification:)), name: ZLGetReposResult_Notification)
        ZLServiceManager.sharedInstance.additionServiceModel?.registerObserver(self, selector: #selector(self.onNotificationArrived(notification:)), name: ZLGetFollowingResult_Notification)
        ZLServiceManager.sharedInstance.additionServiceModel?.registerObserver(self, selector: #selector(self.onNotificationArrived(notification:)), name: ZLGetFollowersResult_Notification)
        ZLServiceManager.sharedInstance.additionServiceModel?.registerObserver(self, selector: #selector(self.onNotificationArrived(notification:)), name: ZLGetGistsResult_Notification)
                
        // 根据model 更新 UI
        self.setViewDataForUserAdditionInfoView(userInfo: self.userInfo!, type: self.type!, view: self.baseView!);
        
        
        self.baseView?.itemListView.beginRefresh()
    }
    
    
}


extension ZLUserAdditionInfoViewModel
{
    func setViewDataForUserAdditionInfoView(userInfo:ZLGithubUserModel,type:ZLUserAdditionInfoType, view:ZLUserAdditionInfoView)
    {
        view.itemListView.delegate = self

        view.headImageView.sd_setImage(with: URL.init(string: userInfo.avatar_url), placeholderImage: UIImage.init(named: "default_avatar"));
        
        switch type
        {
        case .repositories:do{
            self.viewController?.title = ZLLocalizedString(string: "repositories", comment: "仓库")
            view.infoLabel.text = ZLLocalizedString(string: "repositories", comment: "仓库")
            view.numLabel.text = "\(userInfo.public_repos + userInfo.total_private_repos)"

            }
        case .gists:do{
            self.viewController?.title = ZLLocalizedString(string: "gists", comment: "代码片段")
            view.infoLabel.text = ZLLocalizedString(string: "gists", comment: "代码片段")
            view.numLabel.text = "\(userInfo.public_gists + userInfo.private_gists)"
            }
        case .followers:do{
            self.viewController?.title = ZLLocalizedString(string: "followers", comment: "粉丝")
            view.infoLabel.text = ZLLocalizedString(string: "followers", comment: "粉丝")
            view.numLabel.text = "\(userInfo.followers)"
            }
        case .following:do{
            self.viewController?.title = ZLLocalizedString(string: "following", comment: "关注")
            view.infoLabel.text = ZLLocalizedString(string: "following", comment: "关注")
            view.numLabel.text = "\(userInfo.following)"
            }
        case .starredRepos:do
        {
            self.viewController?.title = ZLLocalizedString(string: "stars", comment: "标星")
            view.infoLabel.text = ZLLocalizedString(string: "stars", comment: "标星")
            }
        @unknown default:do {
            }
        }
    }
}

extension ZLUserAdditionInfoViewModel
{
    @objc func onNotificationArrived(notification: Notification)
    {
        ZLLog_Info("onNotificationArrived: notification[\(notification.name)]")
        
        switch(notification.name)
        {
        case ZLGetReposResult_Notification:
            fallthrough
        case ZLGetGistsResult_Notification:
            fallthrough
        case ZLGetFollowersResult_Notification:
            fallthrough
        case ZLGetFollowingResult_Notification:do{
            
            guard let notiPara: ZLOperationResultModel  = notification.params as? ZLOperationResultModel else{
                return
            }
            
            if self.serialNumber == nil || notiPara.serialNumber != self.serialNumber!{
                return;
            }
            
            self.serialNumber = nil;
            
            
            if notiPara.result == true
            {
                let itemArray: [Any]? = notiPara.data as? [Any]
                
                if itemArray == nil {
                    self.baseView?.itemListView.endRefreshWithError()
                    self.isResetData = false
                    ZLToastView.showMessage("Model transfer error")
                    return
                }
                
                var cellDataArray: [ZLGithubItemTableViewCellData] = []
                
                for item in itemArray! {
                    let cellData = ZLGithubItemTableViewCellData.getCellDataWithData(data: item)
                    if cellData != nil {
                        cellDataArray.append(cellData!)
                        self.addSubViewModel(cellData!)
                    }
                }
                
                if self.isResetData {
                    self.isResetData = false
                    self.baseView?.itemListView.resetCellDatas(cellDatas: cellDataArray)
                    self.currentPage = 1
                } else {
                    self.baseView?.itemListView.appendCellDatas(cellDatas: cellDataArray)
                    self.currentPage = self.currentPage + 1
                }
                
            }
            else
            {
                self.baseView?.itemListView.endRefreshWithError()
                self.isResetData = false
                ZLToastView.showMessage("query failed")
            }
        }
        
        default:
            break;
        }
    }
}


//MARK:

extension ZLUserAdditionInfoViewModel : ZLGithubItemListViewDelegate {
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void{
        self.serialNumber = NSString.generateSerialNumber()
        self.isResetData = true
        
        ZLServiceManager.sharedInstance.additionServiceModel?.getAdditionInfo(forUser: self.userInfo!.loginName, infoType: self.type!, page:1, per_page:ZLUserAdditionInfoViewModel.per_page, serialNumber: self.serialNumber!);
    }
    
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) -> Void{
        self.serialNumber = NSString.generateSerialNumber()
        ZLServiceManager.sharedInstance.additionServiceModel?.getAdditionInfo(forUser: self.userInfo!.loginName, infoType: self.type!, page:UInt(self.currentPage + 1), per_page:ZLUserAdditionInfoViewModel.per_page, serialNumber: self.serialNumber!);
    }
}
