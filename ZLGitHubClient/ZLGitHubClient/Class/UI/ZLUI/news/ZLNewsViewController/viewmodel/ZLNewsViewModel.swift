//
//  ZLNewsViewModel.swift
//  ZLGitHubClient
//
//  Created by LongMac on 2019/8/30.
//  Copyright © 2019年 ZM. All rights reserved.
//

import UIKit

class ZLNewsViewModel: ZLBaseViewModel {

    private weak var newsBaseView: ZLNewsBaseView?
    
    var isRefreshNew : Bool = true
    var currentPage: Int = 0
    var per_page: Int = 10

    var curLoginName: String?
    var userInfo: ZLGithubUserModel?
    private var serialNumber: String?
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView)
    {
        if !(targetView is ZLNewsBaseView)
        {
            ZLLog_Info("targetView is invalid")
        }
        
        self.newsBaseView = targetView as? ZLNewsBaseView
        self.newsBaseView?.eventListView.delegate = self
        
        // 注册事件监听
        ZLEventServiceModel.shareInstance().registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name:ZLGetUserReceivedEventResult_Notification)
        ZLUserServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLGetCurrentUserInfoResult_Notification)
        ZLUserServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLGetSpecifiedUserInfoResult_Notification)
        
        //每次界面将要展示时，更新数据
            self.userInfo = ZLUserServiceModel.shared().currentUserInfo()
           
            guard self.userInfo != nil else
            {
                return;
            }

            
        
    }
    
    deinit {
        ZLEventServiceModel.shareInstance().unRegisterObserver(self, name: ZLGetUserReceivedEventResult_Notification)
        ZLUserServiceModel.shared().unRegisterObserver(self, name: ZLGetCurrentUserInfoResult_Notification)
        ZLUserServiceModel.shared().unRegisterObserver(self, name: ZLGetSpecifiedUserInfoResult_Notification)
    }
    
    override func vcLifeCycle_viewWillAppear() {
        super.vcLifeCycle_viewWillAppear()
        self.newsBaseView?.eventListView.beginRefresh()
    }
}

// MARK: onNotificationArrived
extension ZLNewsViewModel
{
    @objc func onNotificationArrived(notification: Notification)
    {
        ZLLog_Info("onNotificationArrived: notification[\(notification.name)]")
        
        switch notification.name
        {
            case ZLGetUserReceivedEventResult_Notification:do
            {
                guard let resultModel: ZLOperationResultModel = notification.params as? ZLOperationResultModel else
                {
                    return
                }
                
                // 
                if resultModel.serialNumber != self.serialNumber!
                {
                    return;
                }
                
                guard resultModel.result == true else
                {
                    self.newsBaseView?.eventListView.endRefreshWithError()
                    guard let errorModel : ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel else
                    {
                        return;
                    }
                    
                    ZLLog_Warn("get received event failed statusCode[\(errorModel.statusCode)] message[\(errorModel.message)]")
                    
                    return
                }
                
                guard let itemArray: [ZLGithubEventModel] = resultModel.data as? [ZLGithubEventModel] else
                {
                    self.newsBaseView?.eventListView.endRefreshWithError()
                    return
                }
                
                var cellDataArray :[ZLEventTableViewCellData] = [];
                
                for model in itemArray
                {
                    let cellData : ZLEventTableViewCellData = ZLEventTableViewCellData.getCellDataWithEventModel(eventModel: model)
                    self.addSubViewModel(cellData)
                    cellDataArray.append(cellData)
                }
                
                if self.isRefreshNew
                {
                    self.newsBaseView?.eventListView.resetCellDatas(cellDatas: cellDataArray)
                    self.isRefreshNew = false
                    self.currentPage = 2
                }
                else
                {
                    self.newsBaseView?.eventListView.apppendCellDatas(cellDatas: cellDataArray)
                    self.currentPage = self.currentPage + 1
                }
            }
            case ZLGetCurrentUserInfoResult_Notification:do
            {
                let operationResultModel : ZLOperationResultModel = notification.params as! ZLOperationResultModel
                
                guard let userInfo : ZLGithubUserModel = operationResultModel.data as? ZLGithubUserModel else
                {
                    ZLLog_Warn("data of operationResultModel is not ZLGithubUserModel,so return")
                    return
                }
                
                self.userInfo = userInfo
                
                self.newsBaseView?.eventListView.beginRefresh()
            }
            case ZLGetSpecifiedUserInfoResult_Notification: do
            {
                let operationResultModel : ZLOperationResultModel = notification.params as! ZLOperationResultModel
                
                guard self.serialNumber == operationResultModel.serialNumber else
                {
                    ZLLog_Warn("serialNumber is not equal, this response will discard")
                    return
                }
                
                guard let userInfo : ZLGithubUserModel = operationResultModel.data as? ZLGithubUserModel else
                {
                    ZLLog_Warn("data of operationResultModel is not ZLGithubUserModel,so return")
                    return
                }

                let vc = ZLUserInfoController.init(userInfoModel: userInfo)
                vc.hidesBottomBarWhenPushed = true
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
            default:
                ZLLog_Info("event have no deal")
        }
    }
}

extension ZLNewsViewModel : ZLEventListViewDelegate
{
    func eventListViewRefreshDragUp(eventListView: ZLEventListView) -> Void
    {
        self.serialNumber = NSString.generateSerialNumber()
        ZLEventServiceModel.shareInstance().getReceivedEvents(forUser: userInfo?.loginName, page: UInt(self.currentPage + 1), per_page: UInt(self.per_page), serialNumber: self.serialNumber)
    }
    
    func eventListViewRefreshDragDown(eventListView: ZLEventListView) -> Void
    {
        self.isRefreshNew = true;
        self.serialNumber = NSString.generateSerialNumber()
        ZLEventServiceModel.shareInstance().getReceivedEvents(forUser: userInfo?.loginName, page: 1, per_page: UInt(self.per_page), serialNumber: self.serialNumber)
    }
}
