//
//  ZLMyPullRequestsController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/12/11.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLMyPullRequestsController: ZLBaseViewController, ZLMyPullRequestsViewDelegate {

    // view
    var myPRView: ZLMyPullRequestsView!

    // model
    var filterType: ZLPRFilterType = .created
    var state: ZLGithubPullRequestState = .open
    var afterCursor: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ZLLocalizedString(string: "pull requests", comment: "")

        let myPRView = ZLMyPullRequestsView()
        self.contentView.addSubview(myPRView)
        myPRView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        myPRView.githubItemListView.delegate = self
        myPRView.delegate = self

        self.myPRView = myPRView

        self.myPRView.githubItemListView.beginRefresh()
    }

    func onFilterTypeChange(type: ZLPRFilterType) {
        self.filterType = type
        self.myPRView.githubItemListView.clearListView()
        self.myPRView.githubItemListView.beginRefresh()
    }

    func onStateChange(state: ZLGithubIssueState) {
        switch state {
        case .open:
            self.state = .open
        case .closed:
            self.state = .closed
        @unknown default:
            self.state = .open
        }
        self.myPRView.githubItemListView.clearListView()
        self.myPRView.githubItemListView.beginRefresh()
    }

}

extension ZLMyPullRequestsController: ZLGithubItemListViewDelegate {

    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {

        ZLServiceManager.sharedInstance.viewerServiceModel?.getMyPRs(key: nil,
                                                                     state: state,
                                                                     filter: filterType,
                                                                     after: nil,
                                                                     serialNumber: NSString.generateSerialNumber()) { [weak self] (resultModel) in

            if resultModel.result == false {

                self?.myPRView.githubItemListView.endRefreshWithError()
                guard let errorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    return
                }
                ZLToastView.showMessage(errorModel.message)

            } else {

                guard let data = resultModel.data as? SearchItemQuery.Data else {
                    self?.myPRView.githubItemListView.endRefreshWithError()
                    return
                }
                self?.afterCursor = data.search.pageInfo.endCursor
                var cellDatas: [ZLPullRequestTableViewCellDataForViewerPR] = []
                if let nodes = data.search.nodes {
                    for pr in nodes {
                        if let tmpData = pr?.asPullRequest {
                            cellDatas.append(ZLPullRequestTableViewCellDataForViewerPR(data: tmpData))
                        }
                    }
                    self?.addSubViewModels(cellDatas)
                }
                self?.myPRView.githubItemListView.resetCellDatas(cellDatas: cellDatas)
            }

        }

    }

    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {

        ZLServiceManager.sharedInstance.viewerServiceModel?.getMyPRs(key: nil,
                                                                     state: state,
                                                                     filter: filterType,
                                                                     after: afterCursor,
                                                                     serialNumber: NSString.generateSerialNumber()) { [weak self](resultModel: ZLOperationResultModel) in

            if resultModel.result == false {

                self?.myPRView.githubItemListView.endRefreshWithError()
                guard let errorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    return
                }
                ZLToastView.showMessage(errorModel.message)

            } else {

                guard let data = resultModel.data as? SearchItemQuery.Data else {
                    self?.myPRView.githubItemListView.endRefreshWithError()
                    return
                }
                self?.afterCursor = data.search.pageInfo.endCursor
                var cellDatas: [ZLPullRequestTableViewCellDataForViewerPR] = []
                if let nodes = data.search.nodes {
                    for pr in nodes {
                        if let tmpData = pr?.asPullRequest {
                            cellDatas.append(ZLPullRequestTableViewCellDataForViewerPR(data: tmpData))
                        }
                    }
                    self?.addSubViewModels(cellDatas)
                }
                self?.myPRView.githubItemListView.appendCellDatas(cellDatas: cellDatas)
            }
        }
    }
}
