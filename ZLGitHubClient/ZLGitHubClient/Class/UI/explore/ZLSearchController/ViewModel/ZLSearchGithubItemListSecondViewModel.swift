//
//  ZLSearchGithubItemListSecondViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/4/13.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService
import ZMMVVM

class ZLSearchGithubItemListSecondViewModel: ZMBaseViewModel {

    // model
    private let searchType: ZLSearchType

    private var searchFilterInfo: ZLSearchFilterInfoModel =  ZLSearchFilterInfoModel()

    private var searchKey: String?

    private var after: String?
    
    var sectionDataArray: [ZMBaseTableViewSectionData] = []
    
    var searchItemSecondView:  ZLSearchItemSecondView? {
        zm_view as? ZLSearchItemSecondView
    }
    
    init(searchType: ZLSearchType) {
        self.searchType = searchType
        super.init()
    }



    func searchWithKeyStr(searchKey: String?) {
        self.searchKey = searchKey
        searchItemSecondView?.viewStatus = .loading
        loadData(isLoadNew: true)
    }

    func searchWithFilerInfo(searchFilterInfo: ZLSearchFilterInfoModel) {
        self.searchFilterInfo = searchFilterInfo
        searchItemSecondView?.viewStatus = .loading
        loadData(isLoadNew: true)
    }
}

// MARK: - Request
extension ZLSearchGithubItemListSecondViewModel {

    func loadData(isLoadNew: Bool) {
        
        ZLSearchServiceShared()?.searchInfo(withKeyWord: searchKey ?? "",
                                            type: searchType,
                                            filterInfo: searchFilterInfo,
                                            after: isLoadNew ? nil: after,
                                            serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel) in
            guard let self else { return }
            
            if resultModel.result, let data = resultModel.data as? SearchItemQuery.Data {
                
                var tableViewCellDatas = [ZMBaseTableViewCellViewModel]()
                if let nodes = data.search.nodes {
                    for node in nodes {
                        if let realNode = node {
                            let cellData = ZLSearchItemTableViewCellData(data: realNode)
                            tableViewCellDatas.append(cellData)
                        }
                    }
                }
                self.zm_addSubViewModels(tableViewCellDatas)
                
                if isLoadNew {
                    self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: tableViewCellDatas)]
                } else {
                    self.sectionDataArray.first?.cellDatas.append(contentsOf: tableViewCellDatas)
                }
                self.after = data.search.pageInfo.endCursor
                
                guard let searchItemSecondView = self.searchItemSecondView else { return }
                searchItemSecondView.sectionDataArray = self.sectionDataArray
                searchItemSecondView.endRefreshViews(noMoreData: tableViewCellDatas.isEmpty)
                searchItemSecondView.viewStatus = (self.searchItemSecondView?.tableViewProxy.isEmpty ?? true) ? .empty : .normal
                
                if searchItemSecondView.tableView.contentOffset.y > 0, isLoadNew {
                    searchItemSecondView.tableView.zl_reloadAndScrollToTop()
                } else {
                    searchItemSecondView.tableView.reloadData()
                }
                
            } else {
                self.searchItemSecondView?.endRefreshViews()
                self.searchItemSecondView?.viewStatus = (self.searchItemSecondView?.tableViewProxy.isEmpty ?? true) ? .error : .normal
                if let data = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage("Search Error: [\(data.statusCode)](\(data.message)")
                }
            }
        }
    }
}
