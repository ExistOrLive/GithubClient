//
//  ZLMyRepoesController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/24.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZMMVVM
import ZLBaseExtension
import ZLGitRemoteService

class ZLMyRepoesController: ZMTableViewController {

    // after
    var after: String?
    
    @objc init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ZLLocalizedString(string: "My Repos", comment: "")

        self.setRefreshViews(types: [.footer,.header])
        self.tableView.contentInsetAdjustmentBehavior = .automatic
        self.tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        self.tableView.register(ZLRepositoryTableViewCell.self,
                                forCellReuseIdentifier: "ZLRepositoryTableViewCell")
        
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func refreshLoadNewData() {
        loadData(isLoadNew: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(isLoadNew: false)
    }

}

extension ZLMyRepoesController {

    func loadData(isLoadNew: Bool) {
        ZLViewerServiceShared()?.getMyTopRepos(after: isLoadNew ? nil : after,
                                               serialNumber: NSString.generateSerialNumber())
        { [weak self] (resultModel: ZLOperationResultModel) in
            guard let self else { return }
            
            if resultModel.result,
               let data = resultModel.data as? ViewerTopRepositoriesQuery.Data {
                
                var cellDatas: [ZLRepoTableViewCellDataForTopRepoQuery] = []
                if let nodes =  data.viewer.topRepositories.nodes {
                    for tmpData in nodes {
                        if let data = tmpData {
                            let cellData = ZLRepoTableViewCellDataForTopRepoQuery(data: data)
                            cellDatas.append(cellData)
                        }
                    }
                }
                zm_addSubViewModels(cellDatas)
                if isLoadNew {
                    self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDatas)]
                } else {
                    self.sectionDataArray.first?.cellDatas.append(contentsOf: cellDatas)
                }
                
                self.tableView.reloadData()
                self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
                self.endRefreshViews(noMoreData: !data.viewer.topRepositories.pageInfo.hasNextPage)
                
                self.after = data.viewer.topRepositories.pageInfo.endCursor
                
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
