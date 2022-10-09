//
//  ZLNotificationViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension

class ZLNotificationViewModel: ZLBaseViewModel {

    var baseView: ZLNotificationView?

    var pageNum: UInt = 0

    var showAll: Bool = false

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {

        guard let view: ZLNotificationView = targetView as? ZLNotificationView else {
            return
        }
        self.baseView = view

        self.showAll = ZLUISharedDataManager.showAllNotifications

        self.baseView?.fillWithViewModel(viewModel: self)

        self.baseView?.githubItemListView.beginRefresh()

        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notifcation:)), name: ZLLanguageTypeChange_Notificaiton, object: nil)
    }

    func loadMoreData() {

        ZLServiceManager.sharedInstance.eventServiceModel?.getNotificationsWithShowAll(self.showAllNotification,
                                                                                       page: Int32(self.pageNum + 1),
                                                                                       per_page: 20,
                                                                                       serialNumber: NSString.generateSerialNumber()) { [weak self](resultModel: ZLOperationResultModel) in

            if resultModel.result == false {
                guard let errorModel: ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    ZLToastView.showMessage("query Notifications failed")
                    return
                }
                ZLToastView.showMessage("query Notifications failed statusCode[\(errorModel.statusCode)] errorMessage[\(errorModel.message)]")
                self?.baseView?.githubItemListView.endRefreshWithError()
            } else {

                guard let data: [ZLGithubNotificationModel] = resultModel.data as? [ZLGithubNotificationModel] else {
                    return
                }

                var cellDataArray: [ZLGithubItemTableViewCellData] = []
                for item in data {
                    if let cellData = ZLGithubItemTableViewCellData.getCellDataWithData(data: item) {
                        self?.addSubViewModel(cellData)
                        cellDataArray.append(cellData)
                    }
                }
                self?.pageNum += 1
                self?.baseView?.githubItemListView.appendCellDatas(cellDatas: cellDataArray)
            }
        }

    }

    func loadNewData() {

        ZLServiceManager.sharedInstance.eventServiceModel?.getNotificationsWithShowAll(self.showAllNotification,
                                                                                       page: 1,
                                                                                       per_page: 20,
                                                                                       serialNumber: NSString.generateSerialNumber()) {[weak self](resultModel: ZLOperationResultModel) in
            self?.baseView?.dismissProgressHUD()
            if resultModel.result == false {
                guard let errorModel: ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    ZLToastView.showMessage("query Notification failed")
                    return
                }
                ZLToastView.showMessage("query Notification failed statusCode[\(errorModel.statusCode)] errorMessage[\(errorModel.message)]")
                self?.baseView?.githubItemListView.endRefreshWithError()
            } else {

                guard let data: [ZLGithubNotificationModel] = resultModel.data as? [ZLGithubNotificationModel] else {
                    return
                }

                var cellDataArray: [ZLGithubItemTableViewCellData] = []
                for item in data {
                    if let cellData = ZLGithubItemTableViewCellData.getCellDataWithData(data: item) {
                        self?.addSubViewModel(cellData)
                        cellDataArray.append(cellData)
                    }
                }
                self?.pageNum = 1
                self?.baseView?.githubItemListView.resetCellDatas(cellDatas: cellDataArray)
            }
        }
    }

    func deleteCellData(cellData: ZLNotificationTableViewCellData) {
        if self.showAll == false {
            self.baseView?.githubItemListView.deleteGithubItem(cellData: cellData)
        }
    }

    @objc func onNotificationArrived(notifcation: Notification) {
        if notifcation.name == ZLLanguageTypeChange_Notificaiton {
            self.viewController?.title = ZLLocalizedString(string: "Notification", comment: "")
            self.baseView?.githubItemListView.justRefresh()
        }
    }

}

extension ZLNotificationViewModel: ZLNotificationViewDataSourceAndDelagate {

    func onFilterTypeChange(_ showAllNotification: Bool) {
        showAll = showAllNotification
        baseView?.showProgressHUD()
        self.loadNewData()
    }

    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {
        self.loadNewData()
    }
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        self.loadMoreData()
    }

    var showAllNotification: Bool {
        showAll
    }
}
