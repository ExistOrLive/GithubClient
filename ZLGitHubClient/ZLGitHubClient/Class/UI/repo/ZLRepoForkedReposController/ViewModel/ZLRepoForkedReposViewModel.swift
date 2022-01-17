//
//  ZLRepoForkedReposViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/24.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoForkedReposViewModel: ZLBaseViewModel {

    var itemListView: ZLGithubItemListView?

    // model
    var fullName: String?
    var currentPage: Int = 0

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {

        self.fullName = targetModel as? String

        guard let itemsView: ZLGithubItemListView = targetView as? ZLGithubItemListView else {
            return
        }
        self.itemListView = itemsView
        self.itemListView?.delegate = self
        self.itemListView?.beginRefresh()
    }
}

extension ZLRepoForkedReposViewModel {
    func loadNewData() {
        guard let fullName = fullName else {
            ZLToastView .showMessage("fullName is nil")
            self.itemListView?.endRefreshWithError()
            return
        }

        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoForks(withFullName: fullName,
                                                                       serialNumber: NSString.generateSerialNumber(),
                                                                       per_page: 20,
                                                                       page: 1) { [weak weakSelf = self](resultModel: ZLOperationResultModel) in

            if resultModel.result == false {
                weakSelf?.itemListView?.endRefreshWithError()
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query Forks Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }

            guard let data: [ZLGithubRepositoryModel] = resultModel.data as? [ZLGithubRepositoryModel] else {
                weakSelf?.itemListView?.endRefreshWithError()
                ZLToastView.showMessage("ZLGithubRepositoryModel transfer error")
                return
            }

            var cellDatas: [ZLRepositoryTableViewCellData] = []
            for repoData in data {
                let cellData = ZLRepositoryTableViewCellData.init(data: repoData)
                self.addSubViewModel(cellData)
                cellDatas.append(cellData)
            }
            weakSelf?.itemListView?.resetCellDatas(cellDatas: cellDatas)
            weakSelf?.currentPage = 1
        }
    }

    func loadMoreData() {

        guard let fullName = fullName else {
            ZLToastView .showMessage("fullName is nil")
            self.itemListView?.endRefreshWithError()
            return
        }

        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoForks(withFullName: fullName,
                                                                       serialNumber: NSString.generateSerialNumber(),
                                                                       per_page: 20,
                                                                       page: self.currentPage + 1) { [weak weakSelf = self](resultModel: ZLOperationResultModel) in

            if resultModel.result == false {
                weakSelf?.itemListView?.endRefreshWithError()
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query Forks Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }

            guard let data: [ZLGithubRepositoryModel] = resultModel.data as? [ZLGithubRepositoryModel] else {
                weakSelf?.itemListView?.endRefreshWithError()
                ZLToastView.showMessage("ZLGithubRepositoryModel transfer error")
                return
            }

            var cellDatas: [ZLRepositoryTableViewCellData] = []
            for repoData in data {
                let cellData = ZLRepositoryTableViewCellData.init(data: repoData)
                self.addSubViewModel(cellData)
                cellDatas.append(cellData)
            }
            weakSelf?.itemListView?.appendCellDatas(cellDatas: cellDatas)
            weakSelf?.currentPage += 1
        }
    }

}

extension ZLRepoForkedReposViewModel: ZLGithubItemListViewDelegate {
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        self.loadMoreData()
    }

    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {
        self.loadNewData()
    }
}
