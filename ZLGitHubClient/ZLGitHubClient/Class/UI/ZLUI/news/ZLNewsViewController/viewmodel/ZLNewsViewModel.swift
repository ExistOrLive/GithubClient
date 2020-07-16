//
//  ZLNewsViewModel.swift
//  ZLGitHubClient
//
//  Created by LongMac on 2019/8/30.
//  Copyright © 2019年 ZM. All rights reserved.
//

import UIKit

class ZLNewsViewModel: ZLBaseViewModel {

    private weak var itemListView: ZLGithubItemListView?
    
    var isRefreshNew : Bool = true
    var currentPage: Int = 0
    var per_page: Int = 10

    var curLoginName: String?
    var userInfo: ZLGithubUserModel?
    private var serialNumber: String?
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView)
    {
        if !(targetView is ZLGithubItemListView)
        {
            ZLLog_Info("targetView is invalid")
        }
        
        self.itemListView = targetView as? ZLGithubItemListView
        self.itemListView?.delegate = self
        
        
        // 注册事件监听
        ZLEventServiceModel.shareInstance().registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name:ZLGetUserReceivedEventResult_Notification)
        ZLUserServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLGetCurrentUserInfoResult_Notification)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLLanguageTypeChange_Notificaiton, object: nil)
        
        //每次界面将要展示时，更新数据
        self.userInfo = ZLUserServiceModel.shared().currentUserInfo()
        guard self.userInfo != nil else
        {
            return;
        }
        
        self.itemListView?.beginRefresh()
    }
    
    deinit {
        ZLEventServiceModel.shareInstance().unRegisterObserver(self, name: ZLGetUserReceivedEventResult_Notification)
        ZLUserServiceModel.shared().unRegisterObserver(self, name: ZLGetCurrentUserInfoResult_Notification)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func vcLifeCycle_viewWillAppear() {
        
        super.vcLifeCycle_viewWillAppear()
        
        if self.itemListView?.itemCount() == 0 && self.userInfo != nil
        {
            self.itemListView?.beginRefresh()
        }
    }
}

// MARK: onNotificationArrived
extension ZLNewsViewModel
{
    func loadMoreData()
    {
        self.serialNumber = NSString.generateSerialNumber()
        ZLEventServiceModel.shareInstance().getReceivedEvents(forUser: userInfo?.loginName, page: UInt(self.currentPage + 1), per_page: UInt(self.per_page), serialNumber: self.serialNumber)
    }
    
    
    func loadNewData()
    {
        self.isRefreshNew = true;
        self.serialNumber = NSString.generateSerialNumber()
        ZLEventServiceModel.shareInstance().getReceivedEvents(forUser: userInfo?.loginName, page: 1, per_page: UInt(self.per_page), serialNumber: self.serialNumber)
    }
    
    
    @objc func onNotificationArrived(notification: Notification)
    {
        ZLLog_Info("onNotificationArrived: notification[\(notification.name)]")
        
        switch notification.name
        {
            case ZLGetUserReceivedEventResult_Notification:do
            {
                guard let resultModel: ZLOperationResultModel = notification.params as? ZLOperationResultModel else
                {
                    ZLToastView.showMessage("Query Events failed")
                    return
                }
                
                // 
                if resultModel.serialNumber != self.serialNumber!
                {
                    return
                }
                
                guard resultModel.result == true else
                {
                    self.itemListView?.endRefreshWithError()
                    guard let errorModel : ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel else
                    {
                        return;
                    }
                     
                    ZLToastView.showMessage("Query Events failed statusCode[\(errorModel.statusCode)] message[\(errorModel.message)]")
                    return
                }
                
                guard let itemArray: [ZLGithubEventModel] = resultModel.data as? [ZLGithubEventModel] else
                {
                    self.itemListView?.endRefreshWithError()
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
                    self.itemListView?.resetCellDatas(cellDatas: cellDataArray)
                    self.isRefreshNew = false
                    self.currentPage = 2
                }
                else
                {
                    self.itemListView?.appendCellDatas(cellDatas: cellDataArray)
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
                
                if self.itemListView?.itemCount() == 0
                {
                    self.itemListView?.beginRefresh()
                }
            }
            case ZLLanguageTypeChange_Notificaiton: do{
                self.viewController?.title = ZLLocalizedString(string: "news", comment: "")
                self.itemListView?.justRefresh()
            }
            default:
                ZLLog_Info("event have no deal")
        }
    }
}

extension ZLNewsViewModel : ZLGithubItemListViewDelegate
{
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void
    {
        self.loadNewData()
    }
      
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) -> Void
    {
        self.loadMoreData()
    }
}
