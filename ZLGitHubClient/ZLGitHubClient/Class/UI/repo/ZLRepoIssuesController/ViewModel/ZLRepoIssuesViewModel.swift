//
//  ZLRepoIssuesViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/14.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension

class ZLRepoIssuesViewModel: ZLBaseViewModel, ZLRepoIssuesViewDelegate {

    var baseView: ZLRepoIssuesView?

    // model
    var fullName: String?
    var filterOpen: Bool = true
    var currentPage: Int = 0

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {

        self.fullName = targetModel as? String

        guard let repoIssuesView: ZLRepoIssuesView = targetView as? ZLRepoIssuesView else {
            return
        }
        self.baseView = repoIssuesView

        self.baseView?.fillWithViewModel(viewModel: self)

        self.baseView?.githubItemListView.beginRefresh()
    }

    func onFilterTypeChange(_ open: Bool) {
        self.filterOpen = open
        ZLProgressHUD.show()
        self.loadNewData()
    }
}

extension ZLRepoIssuesViewModel {
    func loadNewData() {

        guard let fullName = self.fullName else {
            ZLProgressHUD.dismiss()
            self.baseView?.githubItemListView.endRefreshWithError()
            return
        }

        ZLServiceManager.sharedInstance.repoServiceModel?.getRepositoryIssues(withFullName: fullName,
                                                                              state: self.filterOpen ?  "open" : "closed",
                                                                              per_page: 20,
                                                                              page: 1,
                                                                              serialNumber: NSString.generateSerialNumber()) { [weak weakSelf = self](resultModel: ZLOperationResultModel) in

            ZLProgressHUD.dismiss()

            if resultModel.result == false {

                weakSelf?.baseView?.githubItemListView.endRefreshWithError()
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query issues Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }

            guard let data: [ZLGithubIssueModel] = resultModel.data as? [ZLGithubIssueModel] else {

                weakSelf?.baseView?.githubItemListView.endRefreshWithError()
                ZLToastView.showMessage("ZLGithubIssueModel transfer error")
                return
            }

            var cellDatas: [ZLIssueTableViewCellData] = []
            for issueModel in data {
                let cellData = ZLIssueTableViewCellData.init(issueModel: issueModel)
                self.addSubViewModel(cellData)
                cellDatas.append(cellData)
            }
            weakSelf?.baseView?.githubItemListView.resetCellDatas(cellDatas: cellDatas)
            weakSelf?.currentPage = 1
        }
    }

    func loadMoreData() {

        guard let fullName = self.fullName else {
            ZLProgressHUD.dismiss()
            self.baseView?.githubItemListView.endRefreshWithError()
            return
        }

        ZLServiceManager.sharedInstance.repoServiceModel?.getRepositoryIssues(withFullName: fullName,
                                                                              state: self.filterOpen ?  "open" : "closed",
                                                                              per_page: 20,
                                                                              page: Int(self.currentPage) + 1,
                                                                              serialNumber: NSString.generateSerialNumber()) { [weak weakSelf = self](resultModel: ZLOperationResultModel) in

            if resultModel.result == false {

                weakSelf?.baseView?.githubItemListView.endRefreshWithError()
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query issues Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }

            guard let data: [ZLGithubIssueModel] = resultModel.data as? [ZLGithubIssueModel] else {

                weakSelf?.baseView?.githubItemListView.endRefreshWithError()
                ZLToastView.showMessage("ZLGithubIssueModel transfer error")
                return
            }

            var cellDatas: [ZLIssueTableViewCellData] = []
            for issueModel in data {
                let cellData = ZLIssueTableViewCellData.init(issueModel: issueModel)
                self.addSubViewModel(cellData)
                cellDatas.append(cellData)
            }
            weakSelf?.baseView?.githubItemListView.appendCellDatas(cellDatas: cellDatas)
            weakSelf?.currentPage += 1
        }
    }

}

extension ZLRepoIssuesViewModel: ZLGithubItemListViewDelegate {
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        self.loadMoreData()
    }

    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {
        self.loadNewData()
    }
}
