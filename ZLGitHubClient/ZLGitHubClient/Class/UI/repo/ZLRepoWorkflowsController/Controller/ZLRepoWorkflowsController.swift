//
//  ZLRepoWorkflowsController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZMMVVM
import ZLUIUtilities
import ZLGitRemoteService


class ZLRepoWorkflowsController: ZMTableViewController {

    var repoFullName: String?
    
    private var pageNum = 1
    
    static let per_page: Int = 20

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.title = "Workflow"

        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        setRefreshViews(types: [.header,.footer])
        tableView.register(ZLWorkflowTableViewCell.self,
                           forCellReuseIdentifier: "ZLWorkflowTableViewCell")
    }
    
    override func refreshLoadNewData() {
        loadData(isLoadNew: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(isLoadNew: false)
    }

}


extension ZLRepoWorkflowsController {
    
    func loadData(isLoadNew: Bool) {

        var page = 1
        if !isLoadNew {
            page = pageNum
        }
        ZLRepoServiceShared()?.getRepoWorkflows(withFullName: repoFullName ?? "",
                                                per_page: Self.per_page,
                                                page: page,
                                                serialNumber: NSString.generateSerialNumber())
        { [weak self] resultModel in
            guard let self else { return }
            if resultModel.result == true, let itemArray = resultModel.data as? [ZLGithubRepoWorkflowModel] {

                let cellDataArray: [ZMBaseTableViewCellViewModel] = itemArray.map {
                    let cellData = ZLWorkflowTableViewCellData(data: $0)
                    cellData.repoFullName = self.repoFullName ?? ""
                    return cellData
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
                
                self.endRefreshViews(noMoreData: cellDataArray.count < Self.per_page)
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
