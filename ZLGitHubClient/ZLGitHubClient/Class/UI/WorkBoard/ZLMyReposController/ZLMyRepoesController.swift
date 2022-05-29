//
//  ZLMyRepoesController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/24.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension

class ZLMyRepoesController: ZLBaseViewController {

    // view
    var itemListView: ZLGithubItemListView!

    // after
    var after: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ZLLocalizedString(string: "My Repos", comment: "")

        // view
        let itemListView = ZLGithubItemListView()
        itemListView.setTableViewHeader()
        itemListView.setTableViewFooter()
        itemListView.delegate = self
        self.contentView.addSubview(itemListView)
        itemListView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.itemListView = itemListView

        self.itemListView.beginRefresh()
    }

}

extension ZLMyRepoesController: ZLGithubItemListViewDelegate {

    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {

        ZLServiceManager.sharedInstance.viewerServiceModel?.getMyTopRepos(after: nil, serialNumber: NSString.generateSerialNumber()) { [weak weakSelf = self] (resultModel: ZLOperationResultModel) in

            if resultModel.result == false {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
                weakSelf?.itemListView.endRefreshWithError()
            } else {
                if let data = resultModel.data as? ViewerTopRepositoriesQuery.Data {
                    weakSelf?.after = data.viewer.topRepositories.pageInfo.endCursor
                    var cellDatas: [ZLRepoTableViewCellDataForTopRepoQuery] = []
                    if let nodes =  data.viewer.topRepositories.nodes {
                        for tmpData in nodes {
                            if let data = tmpData {
                                let cellData = ZLRepoTableViewCellDataForTopRepoQuery(data: data)
                                cellDatas.append(cellData)
                            }
                        }
                    }
                    weakSelf?.addSubViewModels(cellDatas)
                    weakSelf?.itemListView.resetCellDatas(cellDatas: cellDatas)
                } else {
                    weakSelf?.itemListView.endRefreshWithError()
                }
            }
        }

    }

    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {

        ZLServiceManager.sharedInstance.viewerServiceModel?.getMyTopRepos(after: self.after, serialNumber: NSString.generateSerialNumber()) {[weak weakSelf = self] (resultModel: ZLOperationResultModel) in
            if resultModel.result == false {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
                weakSelf?.itemListView.endRefreshWithError()
            } else {
                if let data = resultModel.data as? ViewerTopRepositoriesQuery.Data {
                    weakSelf?.after = data.viewer.topRepositories.pageInfo.endCursor

                    var cellDatas: [ZLRepoTableViewCellDataForTopRepoQuery] = []
                    if let nodes = data.viewer.topRepositories.nodes {
                        for tmpData in nodes {
                            if let data = tmpData {
                                let cellData = ZLRepoTableViewCellDataForTopRepoQuery(data: data)
                                cellDatas.append(cellData)
                            }
                        }
                    }

                    weakSelf?.addSubViewModels(cellDatas)
                    weakSelf?.itemListView.appendCellDatas(cellDatas: cellDatas)
                } else {
                    weakSelf?.itemListView.endRefreshWithError()
                }
            }
        }
    }

}
