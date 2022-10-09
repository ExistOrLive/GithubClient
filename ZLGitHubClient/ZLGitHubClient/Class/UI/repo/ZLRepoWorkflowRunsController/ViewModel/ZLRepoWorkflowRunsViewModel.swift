//
//  ZLRepoWorkflowRunsViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/11.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension

class ZLRepoWorkflowRunsViewModel: ZLBaseViewModel {

    // view
    var baseView: ZLGithubItemListView?

    // model
    var fullName: String = ""
    var workflow_id: String = ""
    var workflowTitle: String = ""

    var currentPage: Int = 0

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let githubItemListView: ZLGithubItemListView = targetView as?  ZLGithubItemListView else {
            return
        }
        self.baseView = githubItemListView
        self.baseView?.delegate = self

        guard let model: [String: String] = targetModel as? [String: String] else {
            return
        }
        self.fullName = model["fullName"] ?? ""
        self.workflow_id = model["workflow_id"] ?? ""
        self.workflowTitle = model["workflowTitle"] ?? ""

        self.baseView?.beginRefresh()
    }

    func loadNewData() {

        weak var weakSelf = self
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoWorkflowRuns(withFullName: fullName, workflowId: workflow_id, per_page: 20, page: 1, serialNumber: NSString.generateSerialNumber()) { (result: ZLOperationResultModel) in

            if result.result == false {
                ZLToastView.showMessage("Query failed")
                weakSelf?.baseView?.endRefreshWithError()
                return
            }

            guard let dataArray: [ZLGithubRepoWorkflowRunModel] = result.data as? [ZLGithubRepoWorkflowRunModel] else {
                ZLToastView.showMessage("Query failed")
                weakSelf?.baseView?.endRefreshWithError()
                return
            }

            var cellDatas: [ZLGithubItemTableViewCellData] = []
            for data in dataArray {
                let cellData = ZLWorkflowRunTableViewCellData.init(data: data)
                cellData.workFlowTitle = self.workflowTitle
                cellData.repoFullName = self.fullName
                cellDatas.append(cellData)
                weakSelf?.addSubViewModel(cellData)
            }
            weakSelf?.baseView?.resetCellDatas(cellDatas: cellDatas)
            weakSelf?.currentPage = 2
        }
    }

    func loadMoreData() {

        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoWorkflowRuns(withFullName: fullName,
                                                                              workflowId: workflow_id,
                                                                              per_page: 20,
                                                                              page: self.currentPage + 1,
                                                                              serialNumber: NSString.generateSerialNumber()) { [weak weakSelf = self] (result: ZLOperationResultModel) in

            if result.result == false {
                ZLToastView.showMessage("Query failed")
                weakSelf?.baseView?.endRefreshWithError()
                return
            }

            guard let dataArray: [ZLGithubRepoWorkflowRunModel] = result.data as? [ZLGithubRepoWorkflowRunModel] else {
                ZLToastView.showMessage("Query failed")
                weakSelf?.baseView?.endRefreshWithError()
                return
            }

            var cellDatas: [ZLGithubItemTableViewCellData] = []
            for data in dataArray {
                let cellData = ZLWorkflowRunTableViewCellData(data: data)
                cellData.workFlowTitle = self.workflowTitle
                cellData.repoFullName = self.fullName
                cellDatas.append(cellData)
                weakSelf?.addSubViewModel(cellData)
            }
            weakSelf?.baseView?.appendCellDatas(cellDatas: cellDatas)
            weakSelf?.currentPage += 1
        }

    }

}

extension ZLRepoWorkflowRunsViewModel: ZLGithubItemListViewDelegate {
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {
        self.loadNewData()
    }
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        self.loadMoreData()
    }
}
