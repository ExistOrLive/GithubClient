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
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let view : ZLNotificationView = targetView as? ZLNotificationView else {
            return
        }
        self.baseView = view
        self.baseView?.githubItemListView.delegate = self
        
        self.showAllNotification = ZLSharedDataManager.sharedInstance().showAllNotifications
        self.baseView?.filterLabel.text = self.showAllNotification ? "all" : "unread"
        
        self.baseView?.githubItemListView.beginRefresh()
    }
    
    
    @IBAction func onFilterButtonClicked(_ sender: Any) {
        
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: ZLLocalizedString(string: "Filter", comment: ""), withInitIndex: self.showAllNotification ? 0 : 1, withDataArray: ["all","unread"], withResultBlock: {(result : UInt) in
            self.showAllNotification = result == 0 ? true : false
            ZLSharedDataManager.sharedInstance().showAllNotifications = self.showAllNotification
            self.baseView?.filterLabel.text = self.showAllNotification ? "all" : "unread"
            
            self.baseView?.githubItemListView.clearListView()
            SVProgressHUD.show()
            self.loadNewData()
        })
    }
    
    
    func loadMoreData(){
        
        weak var weakSelf = self
        ZLNotificationServiceModel.sharedInstance().getNoticaitions(showAll:self.showAllNotification,page: self.pageNum + 1, per_page: 10, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false {
                guard let errorModel : ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    ZLToastView.showMessage("load Notification failed")
                    return
                }
                ZLToastView.showMessage("load Notification failed statusCode[\(errorModel.statusCode)] errorMessage[\(errorModel.message)]")
                weakSelf?.baseView?.githubItemListView.endRefreshWithError()
            } else {
                
                guard let data : [ZLGithubNotificationModel] = resultModel.data as? [ZLGithubNotificationModel] else {
                    return
                }
                
                var cellDataArray : [ZLGithubItemTableViewCellData] = []
                for item in data {
                    let cellData = ZLGithubItemTableViewCellData.getCellDataWithData(data: item)
                    if cellData != nil {
                        weakSelf?.addSubViewModel(cellData!)
                        cellDataArray.append(cellData!)
                    }
                }
                weakSelf?.pageNum = weakSelf!.pageNum + 1
                weakSelf?.baseView?.githubItemListView.appendCellDatas(cellDatas: cellDataArray)
            }
        })
        
    }
    
    func loadNewData(){
        
        weak var weakSelf = self
        ZLNotificationServiceModel.sharedInstance().getNoticaitions(showAll:self.showAllNotification, page: 1, per_page: 10, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
            
            SVProgressHUD.dismiss()
            if resultModel.result == false {
                guard let errorModel : ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    ZLToastView.showMessage("load Notification failed")
                    return
                }
                ZLToastView.showMessage("load Notification failed statusCode[\(errorModel.statusCode)] errorMessage[\(errorModel.message)]")
                weakSelf?.baseView?.githubItemListView.endRefreshWithError()
            } else {
                
                guard let data : [ZLGithubNotificationModel] = resultModel.data as? [ZLGithubNotificationModel] else {
                    return
                }
                
                var cellDataArray : [ZLGithubItemTableViewCellData] = []
                for item in data {
                    let cellData = ZLGithubItemTableViewCellData.getCellDataWithData(data: item)
                    if cellData != nil {
                        weakSelf?.addSubViewModel(cellData!)
                        cellDataArray.append(cellData!)
                    }
                }
                weakSelf?.pageNum = 1
                weakSelf?.baseView?.githubItemListView.resetCellDatas(cellDatas: cellDataArray)
            }
            
            
        })
    }
    
    func deleteCellData(cellData : ZLNotificationTableViewCellData) {
        if self.showAllNotification == false {
            self.baseView?.githubItemListView.deleteGithubItem(cellData: cellData)
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
