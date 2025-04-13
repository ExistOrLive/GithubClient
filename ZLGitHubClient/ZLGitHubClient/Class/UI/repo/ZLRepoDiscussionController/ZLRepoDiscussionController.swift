//
//  ZLRepoDiscussionController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/4/12.
//  Copyright © 2025 ZM. All rights reserved.
//


import UIKit
import SnapKit
import ZLGitRemoteService
import ZMMVVM
import ZLUIUtilities
import ZLBaseExtension

class ZLRepoDiscussionController: ZMTableViewController {
    
    // input model
    @objc var login: String?
    @objc var repoName: String?

    
    // data
    private var after: String? = nil
    
    static let per_page: UInt = 20
    
    override class func getOne() -> UIViewController! {
        return ZLRepoDiscussionController()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        
        title = ZLLocalizedString(string: "Discussions", comment: "")
        
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        setRefreshViews(types: [.header,.footer])
        tableView.register(ZLDiscussionTableViewCell.self,
                           forCellReuseIdentifier: "ZLDiscussionTableViewCell")
    }
    
    override func refreshLoadNewData() {
        loadData(isLoadNew: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(isLoadNew: false)
    }
}


// MARK: request
extension ZLRepoDiscussionController {
    
    func loadData(isLoadNew: Bool) {
        
        
        ZLEventServiceShared()?.getDiscussionInfoList(withLogin: login ?? "",
                                                      repoName: repoName ?? "",
                                                      per_page: Int32(Self.per_page),
                                                      after: isLoadNew ? nil : after,
                                                      serialNumber: NSString.generateSerialNumber())
        { [weak self] resultModel in
            guard let self else { return }
            if resultModel.result == true, let data = resultModel.data as? RepoDiscussionsQuery.Data {

                let cellDataArray: [ZMBaseTableViewCellViewModel] = data.repository?.discussions.nodes?.compactMap {
                    if let data = $0 {
                        return ZLDiscussionTableViewCellDataV2(data: data)
                    }
                    return nil
                } ?? []
                self.zm_addSubViewModels(cellDataArray)
                
                if isLoadNew {
                    self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDataArray)]
                } else {
                    self.sectionDataArray.first?.cellDatas.append(contentsOf: cellDataArray)
                }
                self.after = data.repository?.discussions.pageInfo.endCursor
                
                self.tableView.reloadData()
                
                self.endRefreshViews(noMoreData: !(data.repository?.discussions.pageInfo.hasNextPage ?? false) )
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



