//
//  ZLBlockedUserViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/10/12.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService

class ZLBlockedUserViewModel: ZLBaseViewModel {

    weak var listView: ZLGithubItemListView?

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let listView: ZLGithubItemListView = targetView as? ZLGithubItemListView else {
            return
        }
        self.listView = listView
        self.listView?.delegate = self

        self.listView?.beginRefresh()
    }

}

extension ZLBlockedUserViewModel: ZLGithubItemListViewDelegate {
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {

        weak var weakSelf = self

        ZLServiceManager.sharedInstance.userServiceModel?.getBlockedUsers(withSerialNumber: NSString.generateSerialNumber(), completeHandle: {(model: ZLOperationResultModel) in

            if model.result == false {
                guard let errorModel: ZLGithubRequestErrorModel = model.data as? ZLGithubRequestErrorModel else {
                    ZLToastView.showMessage("query Blocked User list failed")
                    return
                }
                ZLToastView.showMessage("query Blocked User list failed statusCode[\(errorModel.statusCode)] errorMessage[\(errorModel.message)]")
                weakSelf?.listView?.endRefreshWithError()
            } else {

                guard let data: [ZLGithubUserModel] = model.data as? [ZLGithubUserModel] else {
                    return
                }

                var cellDataArray: [ZLGithubItemTableViewCellData] = []
                for item in data {
                    if let cellData = ZLGithubItemTableViewCellData.getCellDataWithData(data: item) {
                        cellDataArray.append(cellData)
                    }
                }
                weakSelf?.addSubViewModels(cellDataArray)

                weakSelf?.listView?.resetCellDatas(cellDatas: cellDataArray)

            }
        })
    }
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {

    }
}
