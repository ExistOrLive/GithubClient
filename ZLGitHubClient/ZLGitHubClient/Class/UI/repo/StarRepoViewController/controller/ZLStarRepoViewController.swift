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
import ZLBaseUI
import ZLUIUtilities
import ZLBaseExtension

class ZLStarRepoViewController: ZLBaseViewController {
    
    // data
    private var pageNum = 1
    
    override class func getOne() -> UIViewController! {
        return ZLStarRepoViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableContainerView.startLoad()
    }
    
    func setupUI() {
        title = ZLLocalizedString(string: "star", comment: "标星")
        
        contentView.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        }
    }
    
    
    func addData(data: [ZLGithubRepositoryModel], reset: Bool) {
        
        if reset {
            let subViewModels = self.subViewModels
            for viewModel in subViewModels {
                viewModel.removeFromSuperViewModel()
            }
        }
        
        let cellDatas = data.compactMap { model in
            return ZLRepositoryTableViewCellDataV2(data: model)
        }
        addSubViewModels(cellDatas)
        
        if reset {
            pageNum = 2
            tableContainerView.resetCellDatas(cellDatas: cellDatas, hasMoreData: cellDatas.count >= 20)
        } else {
            pageNum += 1
            tableContainerView.appendCellDatas(cellDatas: cellDatas, hasMoreData: cellDatas.count >= 20)
        }
        
    }
    
    // MARK: Lazy view
    
    lazy var tableContainerView: ZLTableContainerView = {
        let tableView = ZLTableContainerView()
        tableView.register(ZLRepositoryTableViewCell.self, forCellReuseIdentifier: "ZLRepositoryTableViewCell")
        tableView.delegate = self
        tableView.setTableViewFooter()
        tableView.setTableViewHeader()
        return tableView
    }()

}

// MARK: ZLTableContainerViewDelegate
extension ZLStarRepoViewController: ZLTableContainerViewDelegate {
    func zlLoadNewData() {
        loadData(loadNew: true)
    }
    
    func zlLoadMoreData() {
        loadData(loadNew: false)
    }
}

// MARK: request
extension ZLStarRepoViewController {
    
    func loadData(loadNew: Bool) {
        
        guard let login = ZLViewerServiceShared()?.currentUserLoginName,
              !login.isEmpty else {
                  ZLToastView.showMessage("login is nil")
                  tableContainerView.endRefresh()
                  return
        }
        
        ZLUserServiceShared()?.getAdditionInfo(forUser: login,
                                               infoType: .starredRepos,
                                               page: UInt(loadNew ? 1 : pageNum) ,
                                               per_page: 20,
                                               serialNumber: NSString.generateSerialNumber())
        { [weak self] resultModel in
            guard let self = self else { return }
            
            if resultModel.result {
                guard let data = resultModel.data as? [ZLGithubRepositoryModel] else {
                    self.tableContainerView.endRefresh()
                    return
                }
                self.addData(data: data, reset: loadNew)
                
            } else {
                self.tableContainerView.endRefresh()
                guard let errorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    return
                }
                ZLToastView.showMessage(errorModel.message, sourceView: self.contentView)
            }
        }
    }
}



