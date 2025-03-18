//
//  ZLMyDiscussionsController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/2.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLUIUtilities
import ZLBaseExtension
import SnapKit
import ZLGitRemoteService
import ZMMVVM

class ZLMyDiscussionsController: ZMTableViewController {
    
    // Model
    private var _after: String?
        
    var hasMoreData: Bool {
        _after != nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewStatus = .loading
        loadData(isLoadNewData: true)
    }
    
    override func setupUI() {
        super.setupUI()
        setRefreshViews(types: [.header,.footer])
        title = ZLLocalizedString(string: "Discussions", comment: "")
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.register(ZLDiscussionTableViewCell.self,
                           forCellReuseIdentifier: "ZLDiscussionTableViewCell")
    }
    
    override func refreshLoadNewData() {
        loadData(isLoadNewData: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(isLoadNewData: false)
    }
}

// MARK: Request
extension ZLMyDiscussionsController {
    func loadData(isLoadNewData: Bool) {
        ZLViewerServiceShared()?.getMyDiscussions(key: nil,
                                                  filter: .created,
                                                  after: isLoadNewData ? nil : _after,
                                                  serialNumber: NSString.generateSerialNumber(),
                                                  completeHandle: { [weak self] resultModel in
            guard let self = self else { return }
            self.viewStatus = .normal
            self.endRefreshViews()
            
            if resultModel.result {
                
                guard let data = resultModel.data as? SearchItemQuery.Data else {
                    return
                }
                var cellDatas: [ZLDiscussionTableViewCellData] = []
                for node in data.search.nodes ?? [] {
                    if let discussionData = node?.asDiscussion {
                        let cellData = ZLDiscussionTableViewCellData(data: discussionData)
                        cellDatas.append(cellData)
                    }
                }
                self.zm_addSubViewModels(cellDatas)
                if isLoadNewData {
                    self.sectionDataArray.forEach( { $0.zm_removeFromSuperViewModel()})
                    self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDatas)]
                    
                } else {
                    self.sectionDataArray.first?.cellDatas.append(contentsOf: cellDatas)
                }
                self.tableViewProxy.reloadData()
                self._after = data.search.pageInfo.hasNextPage ? data.search.pageInfo.endCursor : nil
                self.endRefreshViews(noMoreData: !self.hasMoreData)
                self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
                
            } else {
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
                guard let errorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    return
                }
                ZLToastView.showMessage(errorModel.message)
            }
        })
    }
}


