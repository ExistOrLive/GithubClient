//
//  ZLRepoCommitViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLUIUtilities
import ZLBaseExtension

class ZLRepoCommitViewModel: ZLBaseViewModel {

    private var fullName: String?

    private var branch: String?

    private var untilDate: Date?

    private var itemListView: ZLGithubItemListView?

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {

        guard let model: [String: String] = targetModel as? [String: String] else {
            return
        }
        self.branch = model["branch"]
        self.fullName = model["fullName"]

        guard let itemListView = targetView as? ZLGithubItemListView else {
            return
        }
        self.itemListView = itemListView
        self.itemListView?.delegate = self

        self.itemListView?.beginRefresh()
    }
}

extension ZLRepoCommitViewModel {
    func loadMoreData() {

        guard let fullName = self.fullName else {
            ZLToastView .showMessage("fullName is nil")
            self.itemListView?.endRefreshWithError()
            return
        }

        let date = Date.init(timeInterval: -1, since: self.untilDate ?? Date.init())

        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoCommit(withFullName: fullName,
                                                                        branch: self.branch,
                                                                        until: date,
                                                                        since: nil,
                                                                        serialNumber: NSString.generateSerialNumber()) {[weak weakSelf = self](resultModel: ZLOperationResultModel) in

            if resultModel.result == false {
                weakSelf?.itemListView?.endRefreshWithError()
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query commit Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }

            guard let data: [ZLGithubCommitModel] = resultModel.data as? [ZLGithubCommitModel] else {
                weakSelf?.itemListView?.endRefreshWithError()
                ZLToastView.showMessage("ZLGithubCommitModel transfer error")
                return
            }

            weakSelf?.untilDate = data.last?.commit_at
            var cellDatas: [ZLCommitTableViewCellData] = []
            for commitModel in data {
                let cellData = ZLCommitTableViewCellData.init(commitModel: commitModel )
                self.addSubViewModel(cellData)
                cellDatas.append(cellData)
            }
            weakSelf?.itemListView?.appendCellDatas(cellDatas: cellDatas)
        }
    }

    func loadNewData() {
        guard let fullName = self.fullName else {

            ZLToastView .showMessage("fullName is nil")
            self.itemListView?.endRefreshWithError()
            return
        }

        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoCommit(withFullName: fullName,
                                                                        branch: self.branch,
                                                                        until: Date.init(),
                                                                        since: nil,
                                                                        serialNumber: NSString.generateSerialNumber()) { [weak weakSelf = self](resultModel: ZLOperationResultModel) in

            if resultModel.result == false {
                weakSelf?.itemListView?.endRefreshWithError()
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query commit Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }

            guard let data: [ZLGithubCommitModel] = resultModel.data as? [ZLGithubCommitModel] else {
                weakSelf?.itemListView?.endRefreshWithError()
                ZLToastView.showMessage("ZLGithubCommitModel transfer error")
                return
            }

            weakSelf?.untilDate = data.last?.commit_at
            var cellDatas: [ZLCommitTableViewCellData] = []
            for commitModel in data {
                let cellData = ZLCommitTableViewCellData.init(commitModel: commitModel )
                self.addSubViewModel(cellData)
                cellDatas.append(cellData)
            }
            weakSelf?.itemListView?.resetCellDatas(cellDatas: cellDatas)

        }
    }
}

extension ZLRepoCommitViewModel: ZLGithubItemListViewDelegate {
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {
        self.loadNewData()
    }

    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        self.loadMoreData()
    }
}
