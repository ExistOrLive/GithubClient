//
//  ZLEditFixedRepoSearchController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/3/23.
//  Copyright © 2025 ZM. All rights reserved.
//

import Foundation
import ZLUIUtilities
import ZLGitRemoteService
import UIKit
import ZMMVVM


// MARK: ZLEditFixedRepoSearchControllerDelegate

protocol ZLEditFixedRepoSearchControllerDelegate: NSObjectProtocol {
    func onSelectResult(repo: ZLGithubRepositoryModel)
}

// MARK: - ZLEditFixedRepoSearchController
class ZLEditFixedRepoSearchController: ZMSearchViewController {
    
    weak var delegate: ZLEditFixedRepoSearchControllerDelegate?

    private var pageNum: UInt = 0
        
    override func setupUI() {
        super.setupUI()
        tableView.register(ZLSimpleRepoTableViewCell.self,
                           forCellReuseIdentifier: "ZLSimpleRepoTableViewCell")
    }
    
    override func refreshLoadNewData() {
        loadData(isLoadNew: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(isLoadNew: false)
    }
}

// MARK: - request
extension ZLEditFixedRepoSearchController {
    
    func loadData(isLoadNew: Bool) {
        
        ZLSearchServiceShared()?.searchInfo(withKeyWord: searchText,
                                            type: .repositories,
                                            filterInfo: nil,
                                            page: isLoadNew ? 1 : pageNum,
                                            per_page: 20,
                                            serialNumber: NSString.generateSerialNumber()) 
        { [weak self] resultModel in
            guard let self else { return }
            if resultModel.result == true,
                let data = resultModel.data as? ZLSearchResultModel,
               let itemArray = data.data as? [ZLGithubRepositoryModel] {

                let cellDataArray: [ZMBaseTableViewCellViewModel] = itemArray.map {
                    return ZLSearchFixedRepoTableViewCellModel(repo: $0)
                }                
                self.zm_addSubViewModels(cellDataArray)
                
                if isLoadNew {
                    self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDataArray)]
                    self.pageNum = 2
                } else {
                    self.sectionDataArray.first?.cellDatas.append(contentsOf: cellDataArray)
                    self.pageNum = self.pageNum + 1
                }
                
                self.tableView.reloadData()
                
                self.endRefreshViews(noMoreData: cellDataArray.count < 20)
                self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal

            } else {
                self.endRefreshViews()
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
                
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
            }
        }
        
    }

}


