//
//  ZLGistCodeFileController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/6/15.
//  Copyright © 2025 ZM. All rights reserved.
//


import UIKit
import ZMMVVM
import ZLUIUtilities
import ZLGitRemoteService

class ZLGistCodeFileListController: ZMTableViewController {
    
    // model
    @objc var gistId: String = ""
    
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
        
        self.title = ZLLocalizedString(string: "Gist Files", comment: "代码片段")
        
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        setRefreshViews(types: [.header])
        tableView.register(ZLGistFileTableViewCell.self,
                           forCellReuseIdentifier: "ZLGistFileTableViewCell")
    }
    
    override func refreshLoadNewData() {
        loadData(isLoadNew: true)
    }
}


extension ZLGistCodeFileListController {
    
    func loadData(isLoadNew: Bool) {
        
        ZLServiceManager.sharedInstance
            .userServiceModel?
            .getGistInfo(for: gistId,
                         serialNumber: NSString.generateSerialNumber()) { [weak self] (resultModel: ZLOperationResultModel) in
                guard let self else { return }
                if resultModel.result, let model = resultModel.data as? ZLGithubGistModel {
                    let cellDataArray: [ZLGistFileTableViewCellData] = model.files.map {
                        let cellData = ZLGistFileTableViewCellData(data: $0.value)
                        return cellData
                    }
                    self.zm_addSubViewModels(cellDataArray)
                    
                    self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDataArray)]
                  
                    self.tableView.reloadData()
                    
                    self.endRefreshViews(noMoreData: true)
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
