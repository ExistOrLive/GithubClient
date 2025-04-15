//
//  ZLSearchItemSecondView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/3/22.
//  Copyright © 2025 ZM. All rights reserved.
//

import Foundation
import ZLUIUtilities
import ZMMVVM
import JXSegmentedView

class ZLSearchItemSecondView: UIView, ZMBaseTableViewContainerProtocol, ZLRefreshProtocol, ZLViewStatusProtocol {

    var delegate: ZLSearchGithubItemListSecondViewModel? {
        zm_viewModel as? ZLSearchGithubItemListSecondViewModel
    }
    
    var scrollView: UIScrollView {
        tableView
    }
    
    var targetView: UIView {
        tableView
    }
    
    lazy var tableViewProxy: ZMBaseTableViewProxy = {
        return ZMBaseTableViewProxy(style: .grouped)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.register(ZLRepositoryTableViewCell.self,
                           forCellReuseIdentifier: "ZLRepositoryTableViewCell")
        tableView.register(ZLUserTableViewCell.self,
                           forCellReuseIdentifier: "ZLUserTableViewCell")
        tableView.register(ZLIssueTableViewCell.self,
                           forCellReuseIdentifier: "ZLIssueTableViewCell")
        tableView.register(ZLPullRequestTableViewCell.self,
                           forCellReuseIdentifier: "ZLPullRequestTableViewCell")
        tableView.register(ZLDiscussionTableViewCell.self,
                           forCellReuseIdentifier: "ZLDiscussionTableViewCell")
        
        setRefreshViews(types: [.header,.footer])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshLoadNewData() {
        delegate?.loadData(isLoadNew: true)
    }
    
    func refreshLoadMoreData() {
        delegate?.loadData(isLoadNew: false)
    }
    
    // 外观模式切换
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
                
                for sectionData in sectionDataArray {
                    for cellData in sectionData.cellDatas {
                        cellData.zm_clearCache()
                    }
                    sectionData.headerData?.zm_clearCache()
                    sectionData.footerData?.zm_clearCache()
                }
                tableView.reloadData()
            }
        }
    }
    
}

extension ZLSearchItemSecondView: ZMBaseViewUpdatableWithViewData {
    func zm_fillWithViewData(viewData: ZLSearchGithubItemListSecondViewModel) {
        self.sectionDataArray = viewData.sectionDataArray
        self.viewStatus = viewData.viewStatus
        if viewData.hasNextPage {
            self.showRefreshView(type: .footer)
        } else {
            self.hiddenRefreshView(type: .footer)
        }
        self.tableView.reloadData()
    }
}

extension ZLSearchItemSecondView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
