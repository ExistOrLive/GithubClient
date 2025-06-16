//
//  ZLReleaseInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/11.
//  Copyright © 2025 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZLUIUtilities
import ZLUtilities
import ZMMVVM

class ZLReleaseInfoController: ZMTableViewController {

    // input model
    @objc var login: String?
    @objc var repoName: String?
    @objc var tagName: String?
    
    lazy var viewModel: ZLReleaseInfoViewModel = {
        let viewModel = ZLReleaseInfoViewModel(login: self.login ?? "",
                                               repoName: self.repoName ?? "",
                                               tagName: self.tagName ?? "")
        self.zm_addSubViewModel(viewModel)
        return viewModel
    }()
        
    @objc init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    
    override func setupUI() {
        super.setupUI()
        
        self.title = "\(ZLLocalizedString(string: "Release", comment: "发行版")) \(tagName ?? "")"
        
        self.zmNavigationBar.addRightView(moreButton)
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        tableView.register(ZLReleaseInfoHeaderCell.self,
                           forCellReuseIdentifier: "ZLReleaseInfoHeaderCell")
        tableView.register(ZLReleaseInfoDescriptionCell.self,
                           forCellReuseIdentifier: "ZLReleaseInfoDescriptionCell")
        
        self.setRefreshViews(types: [.header])
    }
    
    lazy var moreButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: ZLIconFont.More.rawValue,
                                                     attributes: [.font: UIFont.zlIconFont(withSize: 30),
                                                                  .foregroundColor: UIColor.label(withName: "ICON_Common")]),
                                  for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        return button
    }()
    

    override func refreshLoadNewData() {
        requestReleaseInfo()
    }
}

// MARK: - Action
extension ZLReleaseInfoController {
    
    @objc func onMoreButtonClick(button: UIButton) {
        let path = viewModel.data?.url ?? ""
        guard let url = URL(string: path) else { return }
        button.showShareMenu(title: path, url: url, sourceViewController: self)
    }
    
}


//
extension ZLReleaseInfoController {
    
    func requestReleaseInfo() {
        
        viewModel.requestReleaseInfoData { [weak self] result, msg in
            guard let self else { return }
            if result, let data = self.viewModel.data {
                
                let cellDatas = self.getCellDatas(data: data)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(200), execute: {
                    
                    self.viewModel.zm_addSubViewModels(cellDatas)
                    
                    self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDatas)]
                    

                    self.tableView.reloadData()
                    self.endRefreshViews(noMoreData: true)
                    self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
                })
                
               
                
            } else {
               
                ZLToastView.showMessage(msg)
                self.endRefreshViews()
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
            }
        }
    }
  
    func getCellDatas(data: RepoReleaseInfoQuery.Data.Repository.Release) -> [ZMBaseTableViewCellViewModel] {
        
        var cellDatas: [ZMBaseTableViewCellViewModel] = []
        
        cellDatas = [ZLReleaseInfoHeaderCellData(),
                     ZLReleaseInfoDescriptionCellData(data:data)]
        
        return cellDatas
    }

}


