//
//  ZLMyEventBaseViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/8.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLGitRemoteService

class ZLMyEventBaseViewModel: ZLBaseViewModel {

    private var serialNumberDic: [String: String] = [:]

    // view
    private weak var baseView: ZLGithubItemListView?

    // model
    private var data: [ZLGithubEventModel] = []

    var pageNum = 0

    deinit {
        self.removeObservers()
    }

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {

        guard let baseView: ZLGithubItemListView = targetView as? ZLGithubItemListView else {
            return
        }

        self.baseView = baseView
        self.baseView?.delegate = self

        self.addObservers()

        self.baseView?.beginRefresh()
    }

    override func vcLifeCycle_viewWillAppear() {
        super.vcLifeCycle_viewWillAppear()
    }
}

// MARK: ZLEventListViewDelegate
extension ZLMyEventBaseViewModel: ZLGithubItemListViewDelegate {
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {
        self.queryNewMyEventRequest(pageNum: 1, pageSize: 20)
    }
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        self.queryMoreMyEventRequest(pageNum: self.pageNum + 1, pageSize: 20)
    }
}

// MARK: request
extension ZLMyEventBaseViewModel {
    static let ZLQueryMoreMyEventRequestKey = "ZLQueryMoreMyEventRequestKey"
    static let ZLQueryNewMyEventRequestKey = "ZLQueryNewMyEventRequestKey"

    func queryMoreMyEventRequest(pageNum: Int, pageSize: Int) {
        let serialNumber = NSString.generateSerialNumber()
        self.serialNumberDic.updateValue(serialNumber, forKey: ZLMyEventBaseViewModel.ZLQueryMoreMyEventRequestKey)

        ZLServiceManager.sharedInstance.eventServiceModel?.getMyEventsWithpage(UInt(pageNum), per_page: UInt(pageSize), serialNumber: serialNumber)
    }

    func queryNewMyEventRequest(pageNum: Int, pageSize: Int) {
          let serialNumber = NSString.generateSerialNumber()
          self.serialNumberDic.updateValue(serialNumber, forKey: ZLMyEventBaseViewModel.ZLQueryNewMyEventRequestKey)

          ZLServiceManager.sharedInstance.eventServiceModel?.getMyEventsWithpage(UInt(pageNum), per_page: UInt(pageSize), serialNumber: serialNumber)
      }
}

// MARK: Notification

extension ZLMyEventBaseViewModel {
    func addObservers() {
        ZLServiceManager.sharedInstance.eventServiceModel?.registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLGetMyEventResult_Notification)
    }

    func removeObservers() {
        ZLServiceManager.sharedInstance.eventServiceModel?.unRegisterObserver(self, name: ZLGetMyEventResult_Notification)
    }

    @objc func onNotificationArrived(notification: Notification) {
        switch notification.name {
        case ZLGetMyEventResult_Notification:do {
            guard let responseObject: ZLOperationResultModel = notification.params as? ZLOperationResultModel else {
                return
            }

            if !self.serialNumberDic.values.contains(responseObject.serialNumber) {
                return
            }

            if !responseObject.result {
                self.baseView?.endRefreshWithError()
                guard let errorModel: ZLGithubRequestErrorModel = responseObject.data as? ZLGithubRequestErrorModel else {
                    ZLLog_Warn("get received event failed")
                    ZLToastView.showMessage("get received event failed")
                    return
                }
                ZLLog_Warn("get received event failed statusCode[\(errorModel.statusCode)] message[\(errorModel.message)]")
                ZLToastView.showMessage("get received event failed statusCode[\(errorModel.statusCode)] message[\(errorModel.message)]")
                return
            }

            if let eventModels = responseObject.data as? [ZLGithubEventModel] {

                var cellDataArray: [ZLEventTableViewCellData] = []
                for eventModel in eventModels {
                    let cellData = ZLEventTableViewCellData.getCellDataWithEventModel(eventModel: eventModel)
                    cellDataArray.append(cellData)
                }
                self.addSubViewModels(cellDataArray)

                if responseObject.serialNumber == self.serialNumberDic[ZLMyEventBaseViewModel.ZLQueryMoreMyEventRequestKey] {
                    self.serialNumberDic.removeValue(forKey: ZLMyEventBaseViewModel.ZLQueryMoreMyEventRequestKey)
                    self.baseView?.appendCellDatas(cellDatas: cellDataArray)
                    self.pageNum = self.pageNum + 1
                } else if responseObject.serialNumber == self.serialNumberDic[ZLMyEventBaseViewModel.ZLQueryNewMyEventRequestKey] {
                    self.serialNumberDic.removeValue(forKey: ZLMyEventBaseViewModel.ZLQueryNewMyEventRequestKey)
                    self.baseView?.resetCellDatas(cellDatas: cellDataArray)
                    self.pageNum = 1
                }
            }

            }
        default:
            break
        }
    }

}
