//
//  ZLMyPullRequestsController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/12/11.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService
import ZMMVVM
import ZLUtilities

class ZLMyPullRequestsController: ZMTableViewController {

    // model
    var filterType: ZLPRFilterType = .created
    var state: ZLGithubPullRequestState = .open
    var afterCursor: String?

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
        
        self.title = ZLLocalizedString(string: "pull requests", comment: "")
        
        self.setRefreshViews(types: [.header,.footer])
        
        self.tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        self.tableView.register(ZLPullRequestTableViewCell.self,
                                forCellReuseIdentifier: "ZLPullRequestTableViewCell")
        
        self.contentView.addSubview(filterView)
       
        filterView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(filterView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    lazy var filterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLSubBarColor")
        view.addSubview(filterButton)
        filterButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        filterButton.addTarget(self,
                               action: #selector(onFilterButtonClicked),
                               for: .touchUpInside)

        view.addSubview(stateButton)
        stateButton.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(filterButton.snp.left).offset(-10)
        }
        stateButton.addTarget(self,
                              action: #selector(onStateButtonClicked),
                              for: .touchUpInside)
        
        return view
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        let title = NSMutableAttributedString()
        title.append(NSAttributedString(string: ZLIconFont.DownArrow.rawValue,
                                        attributes: [.font: UIFont.zlIconFont(withSize: 12),
                                                     .foregroundColor: UIColor.iconColor(withName: "ICON_Common")]))
        title.append(NSAttributedString(string: " "))
        title.append(NSAttributedString(string: "Created",
                                        attributes: [.foregroundColor: UIColor.label(withName: "ZLLabelColor3"),
                                                     .font: UIFont.zlMediumFont(withSize: 12)]))
        button.setAttributedTitle(title, for: .normal)
        return button
    }()

    lazy var stateButton: UIButton = {
        let button = UIButton(type: .custom)
        let title = NSMutableAttributedString()
        title.append(NSAttributedString(string: ZLIconFont.DownArrow.rawValue,
                                        attributes: [.font: UIFont.zlIconFont(withSize: 12),
                                                     .foregroundColor: UIColor.iconColor(withName: "ICON_Common")]))
        title.append(NSAttributedString(string: " "))
        title.append(NSAttributedString(string: "Open",
                                        attributes: [.foregroundColor: UIColor.label(withName: "ZLLabelColor3"),
                                                     .font: UIFont.zlMediumFont(withSize: 12)]))
        button.setAttributedTitle(title, for: .normal)
        return button
    }()

    
    
    
    override func refreshLoadNewData() {
        loadData(isLoadNew: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(isLoadNew: false)
    }
    
   

}

// MARK: - Action
extension ZLMyPullRequestsController {
    
    @objc func onFilterButtonClicked() {
        let titles = ["Created", "Assigned", "Mentioned", "Review"]
        var selectedTitle = "Created"
        if self.filterType.rawValue < titles.count {
            selectedTitle = titles[self.filterType.rawValue]
        }
        ZMSingleSelectTitlePopView
            .showCenterSingleSelectTickBox(to: view,
                                           title:  ZLLocalizedString(string: "Filter",
                                                                     comment: ""),
                                           selectableTitles: titles,
                                           selectedTitle: selectedTitle)
        { [weak self] (index, result) in
            guard let self =  self else { return }
            
            let str = titles[index]
            
            let title = NSMutableAttributedString()
            title.append(NSAttributedString(string: ZLIconFont.DownArrow.rawValue,
                                            attributes: [.font: UIFont.zlIconFont(withSize: 12),
                                                         .foregroundColor: UIColor.iconColor(withName: "ICON_Common")]))
            title.append(NSAttributedString(string: " "))
            title.append(NSAttributedString(string: str,
                                            attributes: [.foregroundColor: UIColor.label(withName: "ZLLabelColor3"),
                                                         .font: UIFont.zlMediumFont(withSize: 12)]))
            self.filterButton.setAttributedTitle(title, for: .normal)
            
            self.filterType = ZLPRFilterType.init(rawValue: index) ?? .created
    
            ZLProgressHUD.show()
            self.loadData(isLoadNew: true)
        }
    }

    @objc func onStateButtonClicked() {
        let titles = ["Open", "Closed"]
        var selectedTitle = "Open"
        if self.state.rawValue < titles.count {
            selectedTitle = titles[Int(self.state.rawValue)]
        }
        ZMSingleSelectTitlePopView
            .showCenterSingleSelectTickBox(to: view,
                                           title:  ZLLocalizedString(string: "Filter",
                                                                     comment: ""),
                                           selectableTitles: titles,
                                           selectedTitle: selectedTitle)
        { [weak self] (index, result) in
            guard let self =  self else { return }
            
            let str = titles[index]

            let title = NSMutableAttributedString()
            title.append(NSAttributedString(string: ZLIconFont.DownArrow.rawValue,
                                            attributes: [.font: UIFont.zlIconFont(withSize: 12),
                                                         .foregroundColor: UIColor.iconColor(withName: "ICON_Common")]))
            title.append(NSAttributedString(string: " "))
            title.append(NSAttributedString(string: str,
                                            attributes: [.foregroundColor: UIColor.label(withName: "ZLLabelColor3"),
                                                         .font: UIFont.zlMediumFont(withSize: 12)]))
            self.stateButton.setAttributedTitle(title, for: .normal)
            let stateIndex = ZLGithubIssueState.init(rawValue: UInt(index)) ?? .open

            self.onStateChange(state: stateIndex)
            
        }
    }
    
    
   

    func onStateChange(state: ZLGithubIssueState) {
        switch state {
        case .open:
            self.state = .open
        case .closed:
            self.state = .closed
        @unknown default:
            self.state = .open
        }
        ZLProgressHUD.show()
        loadData(isLoadNew: true)
    }
}

// MARK: - Request
extension ZLMyPullRequestsController {
    
    func loadData(isLoadNew: Bool) {
        var after = self.afterCursor
        if isLoadNew {
            after = nil
        }
        
        ZLViewerServiceShared()?.getMyPRs(key: nil,
                                          state: state,
                                          filter: filterType,
                                          after: after,
                                          serialNumber: NSString.generateSerialNumber()) { [weak self] (resultModel) in
            guard let self else { return }
            
            ZLProgressHUD.dismiss()
            
            if resultModel.result,
               let data = resultModel.data as? SearchItemQuery.Data {
                
                self.afterCursor = data.search.pageInfo.endCursor
                
                var cellDatas: [ZLPullRequestTableViewCellDataForViewerPR] = []
                if let nodes = data.search.nodes {
                    for pr in nodes {
                        if let tmpData = pr?.asPullRequest {
                            cellDatas.append(ZLPullRequestTableViewCellDataForViewerPR(data: tmpData))
                        }
                    }
                }
                self.zm_addSubViewModels(cellDatas)
                
                if isLoadNew {
                    self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDatas)]
                } else {
                    self.sectionDataArray.first?.cellDatas.append(contentsOf: cellDatas)
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
