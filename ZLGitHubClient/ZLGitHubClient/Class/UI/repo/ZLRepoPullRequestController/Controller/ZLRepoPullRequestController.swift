//
//  ZLRepoPullRequestController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/15.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZLUIUtilities
import ZLUtilities
import ZMMVVM

class ZLRepoPullRequestController: ZMTableViewController {

    var repoFullName: String?
    
    var filterOpen: Bool = true
    
    var currentPage: Int = 0
    
    @objc init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewStatus = .loading
        self.refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.title = ZLLocalizedString(string: "pull request", comment: "合并请求")
                
        self.setRefreshViews(types: [.header,.footer])
        
        self.tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        self.tableView.register(ZLPullRequestTableViewCell.self,
                                forCellReuseIdentifier: "ZLPullRequestTableViewCell")
        
        self.contentView.addSubview(filterBackView)
       
        filterBackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(filterBackView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private lazy var filterBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.back(withName: "ZLSubBarColor")
        view.addSubview(filterButton)
        view.addSubview(filterLabel)
        filterLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.centerY.equalToSuperview()
        }
        filterButton.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(50)
        }
        return view
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(ZLIconFont.Filter.rawValue, for: .normal)
        button.setTitleColor(UIColor.label(withName: "ICON_Common"), for: .normal)
        button.titleLabel?.font = UIFont.zlIconFont(withSize: 18)
        button.addTarget(self, action: #selector(onFilterButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlSemiBoldFont(withSize: 14)
        label.textColor = UIColor.label(withName: "ZLLabelColor3")
        label.text = "open"
        return label
    }()
    
    
 
    override func refreshLoadNewData() {
        loadData(isLoadNew: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(isLoadNew: false)
    }

}

// MARK: - Action
extension ZLRepoPullRequestController {
    @objc func onFilterButtonClicked() {
        ZMSingleSelectTitlePopView
            .showCenterSingleSelectTickBox(to: view,
                                           title: ZLLocalizedString(string: "Filter",
                                                                    comment: ""),
                                           selectableTitles: ["open", "closed"],
                                           selectedTitle: self.filterOpen ? "open" : "closed")
        { [weak self](index, result) in
            guard let self else { return }
            self.filterLabel.text = index == 0 ? "open" : "closed"
            self.filterOpen = index == 0
            
            ZLProgressHUD.show()
            self.loadData(isLoadNew: true)
        }
    }
}


// MARK: - Request
extension ZLRepoPullRequestController {
    
    func loadData(isLoadNew: Bool) {
        
        var page = 1
        if !isLoadNew {
            page = self.currentPage
        }
        
        ZLRepoServiceShared()?.getRepoPullRequest(withFullName: repoFullName ?? "",
                                                  state: self.filterOpen ? "open" : "closed",
                                                  per_page: 20 ,
                                                  page: page ,
                                                  serialNumber: NSString.generateSerialNumber())
        {[weak self] (resultModel: ZLOperationResultModel) in
            guard let self else { return }

            ZLProgressHUD.dismiss()
            
            if resultModel.result,
               let data = resultModel.data as? [ZLGithubPullRequestModel] {
                
                let cellDatas = data.map {
                    ZLPullRequestTableViewCellData(eventModel: $0)
                }
                self.zm_addSubViewModels(cellDatas)
                
                if isLoadNew {
                    self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDatas)]
                    self.currentPage = 2
                } else {
                    self.sectionDataArray.first?.cellDatas.append(contentsOf: cellDatas)
                    self.currentPage += 1
                }
                
                self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
                self.endRefreshViews(noMoreData: cellDatas.isEmpty)
                
                if self.tableView.contentOffset.y > 0, isLoadNew {
                    self.tableView.zl_reloadAndScrollToTop()
                } else {
                    self.tableViewProxy.reloadData()
                }
                
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
