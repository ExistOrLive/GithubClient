//
//  ZLSearchGithubItemListSecondViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/4/13.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension
import ZLGitRemoteService

class ZLSearchGithubItemListSecondViewModel: ZLBaseViewModel {

    // model
    private var searchType: ZLSearchType = .repositories

    private var searchFilterInfo: ZLSearchFilterInfoModel =  ZLSearchFilterInfoModel()

    private var searchKey: String?

    private var after: String?

    // view
    private var githubItemListView: ZLGithubItemListView?

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {

        guard let githubItemListView: ZLGithubItemListView = targetView as? ZLGithubItemListView  else {
            return
        }
        self.githubItemListView = githubItemListView
        self.githubItemListView?.setTableViewFooter()
        self.githubItemListView?.setTableViewHeader()
        self.githubItemListView?.delegate = self

        guard let searchType: ZLSearchType = targetModel as? ZLSearchType else {
            return
        }
        self.searchType = searchType
    }

    func searchWithKeyStr(searchKey: String?) {
        self.searchKey = searchKey
        self.githubItemListView?.clearListView()
        self.githubItemListView?.beginRefresh()
    }

    func searchWithFilerInfo(searchFilterInfo: ZLSearchFilterInfoModel) {
        self.searchFilterInfo = searchFilterInfo
        self.githubItemListView?.clearListView()
        self.githubItemListView?.beginRefresh()
    }

    func startInput() {
        self.githubItemListView?.resetContentOffset()
    }

}

extension ZLSearchGithubItemListSecondViewModel: ZLGithubItemListViewDelegate {

    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {

        if let searchKey = self.searchKey {

            ZLServiceManager.sharedInstance.searchServiceModel?.searchInfo(withKeyWord: searchKey,
                                                                           type: self.searchType,
                                                                           filterInfo: self.searchFilterInfo,
                                                                           after: nil,
                                                                           serialNumber: NSString.generateSerialNumber()) { [weak self](resultModel) in

                if resultModel.result == true,
                   let data = resultModel.data as? SearchItemQuery.Data {

                    var tableViewCellDatas = [ZLGithubItemTableViewCellData]()
                    if let nodes = data.search.nodes {
                        for node in nodes {
                            if let realNode = node {
                                let cellData = ZLSearchItemTableViewCellData(data: realNode)
                                tableViewCellDatas.append(cellData)
                            }
                        }

                    }

                    self?.addSubViewModels(tableViewCellDatas)
                    self?.after = data.search.pageInfo.endCursor

                    self?.githubItemListView?.resetCellDatas(cellDatas: tableViewCellDatas)

                } else if resultModel.result == false, let data = resultModel.data as? ZLGithubRequestErrorModel {

                    ZLToastView.showMessage("Search Error: [\(data.statusCode)](\(data.message)")
                    self?.githubItemListView?.endRefreshWithError()

                } else {
                    ZLToastView.showMessage("Search Error: invalid format data")
                    self?.githubItemListView?.endRefreshWithError()
                }

            }
        } else {
            self.githubItemListView?.resetCellDatas(cellDatas: nil)
        }
    }

    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {

        if let searchKey = self.searchKey {

            ZLServiceManager.sharedInstance.searchServiceModel?.searchInfo(withKeyWord: searchKey,
                                                                           type: self.searchType,
                                                                           filterInfo: self.searchFilterInfo,
                                                                           after: self.after,
                                                                           serialNumber: NSString.generateSerialNumber()) { [weak self](resultModel) in

                if resultModel.result == true,
                   let data = resultModel.data as? SearchItemQuery.Data {

                    var tableViewCellDatas = [ZLGithubItemTableViewCellData]()
                    if let nodes = data.search.nodes {
                        for node in nodes {
                            if let realNode = node {
                                let cellData = ZLSearchItemTableViewCellData(data: realNode)
                                tableViewCellDatas.append(cellData)
                            }
                        }

                    }
                    self?.addSubViewModels(tableViewCellDatas)
                    self?.after = data.search.pageInfo.endCursor

                    self?.githubItemListView?.appendCellDatas(cellDatas: tableViewCellDatas)

                } else if resultModel.result == false,
                          let data = resultModel.data as? ZLGithubRequestErrorModel {

                    ZLToastView.showMessage("Search Error: [\(data.statusCode)](\(data.message)")
                    self?.githubItemListView?.endRefreshWithError()

                } else {
                    ZLToastView.showMessage("Search Error: invalid format data")
                    self?.githubItemListView?.endRefreshWithError()
                }

            }

        } else {
            self.githubItemListView?.resetCellDatas(cellDatas: nil)
        }

    }
}
