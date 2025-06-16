//
//  ZLRepoCompareCommitController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/20.
//  Copyright © 2025 ZM. All rights reserved.
//

import UIKit
import ZMMVVM
import ZLUIUtilities
import ZLGitRemoteService

class ZLRepoCompareCommitController: ZMTableViewController {
    
    @objc var login: String?
    @objc var repoName: String?
    @objc var baseRef: String?
    @objc var headRef: String?
    
    // data
    private var pageNum = 1
    
    static let per_page: UInt = 20
        
    @objc init() {
        super.init(style: .plain)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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


extension ZLRepoCompareCommitController {
    
    func loadData(isLoadNew: Bool) {
        
        ZLRepoServiceShared()?.getRepoCommitCompare(withLogin: login ?? "",
                                                    repoName: repoName ?? "",
                                                    baseRef: baseRef ?? "",
                                                    headRef: headRef ?? "",
                                                    per_page: Int(Self.per_page),
                                                    page: isLoadNew ? 1 : pageNum,
                                                    serialNumber: NSString.generateSerialNumber())
        { [weak self] resultModel in
            guard let self else { return }
            if resultModel.result == true, let model = resultModel.data as? ZLGithubCompareModel {
                let cellDataArray: [ZLCommitTableViewCellData] = model.commits.map {
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
