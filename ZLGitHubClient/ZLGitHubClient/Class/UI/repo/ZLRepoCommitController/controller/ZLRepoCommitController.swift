//
//  ZLRepoCommitController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZMMVVM
import ZLUIUtilities
import ZLGitRemoteService

class ZLRepoCommitController: ZMTableViewController {
    
    var repoFullName: String?
    
    var branch: String?
    
    let date: Date = Date()
    
    
    private var pageNum = 1
    
    static let per_page: Int = 20
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.title = ZLLocalizedString(string: "commits", comment: "提交")
        
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        setRefreshViews(types: [.header,.footer])
        tableView.register(ZLCommitTableViewCell.self,
                           forCellReuseIdentifier: "ZLCommitTableViewCell")
    }
    
    override func refreshLoadNewData() {
        loadData(isLoadNew: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(isLoadNew: false)
    }
    
}


extension ZLRepoCommitController {
    func loadData(isLoadNew: Bool) {
        
        var page = 1
        if !isLoadNew {
            page = self.pageNum
            
        }
        
        ZLRepoServiceShared()?.getRepoCommit(withFullName: repoFullName ?? "",
                                             page: UInt(page),
                                             per_page: UInt(Self.per_page),
                                             branch: branch,
                                             until: date,
                                             since: nil,
                                             serialNumber: NSString.generateSerialNumber())
        { [weak self] resultModel in
            guard let self else { return }
            if resultModel.result == true, let itemArray = resultModel.data as? [ZLGithubCommitModel] {
      
                let cellDataArray: [ZLCommitTableViewCellData] = itemArray.map {
                    let cellData = ZLCommitTableViewCellData(commitModel: $0)
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
