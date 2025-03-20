//
//  ZLStarRepoViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/21.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import SnapKit
import ZLGitRemoteService
import ZMMVVM
import ZLUIUtilities
import ZLBaseExtension

class ZLStarRepoViewController: ZMTableViewController {
    
    // data
    private var pageNum = 1
    
    static let per_page: UInt = 20  
    
    override class func getOne() -> UIViewController! {
        return ZLStarRepoViewController()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        
        title = ZLLocalizedString(string: "star", comment: "标星")
        
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        setRefreshViews(types: [.header,.footer])
        tableView.register(ZLRepositoryTableViewCell.self,
                           forCellReuseIdentifier: "ZLRepositoryTableViewCell")
    }
    
    override func refreshLoadNewData() {
        loadData(isLoadNew: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(isLoadNew: false)
    }
}


// MARK: request
extension ZLStarRepoViewController {
    
    func loadData(isLoadNew: Bool) {
        
        let login = ZLViewerServiceShared()?.currentUserLoginName ?? ""
        
        ZLUserServiceShared()?.getAdditionInfo(forUser: login,
                                               infoType: .starredRepos,
                                               page: UInt(isLoadNew ? 1 : pageNum) ,
                                               per_page: 20,
                                               serialNumber: NSString.generateSerialNumber())
        { [weak self] resultModel in
            guard let self else { return }
            if resultModel.result == true, let itemArray = resultModel.data as? [ZLGithubRepositoryModel] {

                let cellDataArray: [ZMBaseTableViewCellViewModel] = itemArray.map {
                    ZLRepositoryTableViewCellDataV3(data: $0)
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



