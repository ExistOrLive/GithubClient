//
//  ZLRepoReleasesController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/10.
//  Copyright © 2025 ZM. All rights reserved.
//

import UIKit
import SnapKit
import ZLGitRemoteService
import ZMMVVM
import ZLUIUtilities
import ZLBaseExtension

class ZLRepoReleasesController: ZMTableViewController {
    
    // input model
    @objc var login: String?
    @objc var repoName: String?

    
    // data
    private var after: String? = nil
    
    static let per_page: UInt = 20
    
    override class func getOne() -> UIViewController! {
        return ZLRepoReleasesController()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        
        title = ZLLocalizedString(string: "Releases", comment: "")
        
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        setRefreshViews(types: [.header,.footer])
        tableView.register(ZLReleaseTableViewCell.self,
                           forCellReuseIdentifier: "ZLReleaseTableViewCell")
    }
    
    override func refreshLoadNewData() {
        loadData(isLoadNew: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(isLoadNew: false)
    }
}


// MARK: request
extension ZLRepoReleasesController {
    
    func loadData(isLoadNew: Bool) {

        ZLRepoServiceShared()?
            .getRepoReleaseLits(withLogin: login ?? "",
                                repoName: repoName ?? "",
                                per_page: Int(Self.per_page),
                                after: isLoadNew ? nil : after,
                                serialNumber: NSString.generateSerialNumber())
        { [weak self] resultModel in
            guard let self else { return }
            if resultModel.result == true, let data = resultModel.data as? RepoReleasesQuery.Data {
                
                let cellDataArray: [ZMBaseTableViewCellViewModel] = data.repository?.releases.nodes?.compactMap {
                    if let data = $0 {
                        return ZLReleaseTableViewCellData(data: data)
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
                self.after = data.repository?.releases.pageInfo.endCursor
                
                self.tableView.reloadData()
                
                self.endRefreshViews(noMoreData: !(data.repository?.releases.pageInfo.hasNextPage ?? false) )
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



