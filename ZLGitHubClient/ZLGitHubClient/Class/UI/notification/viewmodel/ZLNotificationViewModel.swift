//
//  ZLNotificationViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLNotificationViewModel: ZLBaseViewModel {
    
    var baseView : ZLNotificationView?
    
    var pageNum : UInt = 0
    
    var showAllNotification : Bool = false
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let view : ZLNotificationView = targetView as? ZLNotificationView else {
            return
        }
        self.baseView = view
        self.baseView?.githubItemListView.delegate = self
        
        self.showAllNotification = ZLUISharedDataManager.showAllNotifications
        self.baseView?.filterLabel.text = self.showAllNotification ? "all" : "unread"
        
        self.baseView?.githubItemListView.beginRefresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notifcation:)), name: ZLLanguageTypeChange_Notificaiton, object: nil)
    }
    
    
    @IBAction func onFilterButtonClicked(_ sender: Any) {
        
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: ZLLocalizedString(string: "Filter", comment: ""), withInitIndex: self.showAllNotification ? 0 : 1, withDataArray: ["all","unread"], withResultBlock: {(result : UInt) in
            self.showAllNotification = result == 0 ? true : false
            ZLUISharedDataManager.showAllNotifications = self.showAllNotification
            self.baseView?.filterLabel.text = self.showAllNotification ? "all" : "unread"
            
            self.baseView?.githubItemListView.clearListView()
            SVProgressHUD.show()
            self.loadNewData()
        })
    }
    
    
    func loadMoreData(){
        
        ZLServiceManager.sharedInstance.eventServiceModel?.getNotificationsWithShowAll(self.showAllNotification,
                                                                                       page: Int32(self.pageNum + 1),
                                                                                       per_page: 10,
                                                                                       serialNumber: NSString.generateSerialNumber())
        { [weak weakSelf = self](resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false {
                guard let errorModel : ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    ZLToastView.showMessage("query Notifications failed")
                    return
                }
                ZLToastView.showMessage("query Notifications failed statusCode[\(errorModel.statusCode)] errorMessage[\(errorModel.message)]")
                weakSelf?.baseView?.githubItemListView.endRefreshWithError()
            } else {
                
                guard let data : [ZLGithubNotificationModel] = resultModel.data as? [ZLGithubNotificationModel] else {
                    return
                }
                
                var cellDataArray : [ZLGithubItemTableViewCellData] = []
                for item in data {
                    if let cellData = ZLGithubItemTableViewCellData.getCellDataWithData(data: item) {
                        weakSelf?.addSubViewModel(cellData)
                        cellDataArray.append(cellData)
                    }
                }
                weakSelf?.pageNum += 1
                weakSelf?.baseView?.githubItemListView.appendCellDatas(cellDatas: cellDataArray)
            }
        }
        
    }
    
    func loadNewData(){
        
        ZLServiceManager.sharedInstance.eventServiceModel?.getNotificationsWithShowAll(self.showAllNotification,
                                                                                       page: 1,
                                                                                       per_page: 10,
                                                                                       serialNumber: NSString.generateSerialNumber())
       {[weak weakSelf = self](resultModel : ZLOperationResultModel) in
            
            SVProgressHUD.dismiss()
            if resultModel.result == false {
                guard let errorModel : ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    ZLToastView.showMessage("query Notification failed")
                    return
                }
                ZLToastView.showMessage("query Notification failed statusCode[\(errorModel.statusCode)] errorMessage[\(errorModel.message)]")
                weakSelf?.baseView?.githubItemListView.endRefreshWithError()
            } else {
                
                guard let data : [ZLGithubNotificationModel] = resultModel.data as? [ZLGithubNotificationModel] else {
                    return
                }
                
                var cellDataArray : [ZLGithubItemTableViewCellData] = []
                for item in data {
                    if let cellData = ZLGithubItemTableViewCellData.getCellDataWithData(data: item) {
                        weakSelf?.addSubViewModel(cellData)
                        cellDataArray.append(cellData)
                    }
                }
                weakSelf?.pageNum = 1
                weakSelf?.baseView?.githubItemListView.resetCellDatas(cellDatas: cellDataArray)
            }
        }
    }
    
    func deleteCellData(cellData : ZLNotificationTableViewCellData) {
        if self.showAllNotification == false {
            self.baseView?.githubItemListView.deleteGithubItem(cellData: cellData)
        }
    }
    
    
    @objc func onNotificationArrived(notifcation : Notification) -> Void {
        if notifcation.name == ZLLanguageTypeChange_Notificaiton {
            self.viewController?.title = ZLLocalizedString(string: "Notification", comment: "")
        }
    }
    
}

extension ZLNotificationViewModel : ZLGithubItemListViewDelegate {
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void{
        self.loadNewData()
    }
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) -> Void{
        self.loadMoreData()
    }
}
