//
//  ZLGithubItemListView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import MJRefresh
import ZLBaseUI
import ZLBaseExtension

@objc protocol ZLGithubItemListViewDelegate: NSObjectProtocol {
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView)
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView)
}

@objc class ZLGithubItemListView: ZLBaseView {

    // view
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: self.bounds, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    private lazy var noDataView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.clear

        let tagLabel = UILabel()
        tagLabel.textColor = ZLRGBValue_H(colorValue: 0x999999)
        tagLabel.textAlignment = .center
        tagLabel.font = .zlIconFont(withSize: 45)
        tagLabel.text = ZLIconFont.NoData.rawValue
        view.addSubview(tagLabel)
        tagLabel.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize.init(width: 70, height: 60))
            make.top.left.right.equalToSuperview()
        })

        let label = UILabel.init()
        label.text = "No Data"
        label.textColor = ZLRGBValue_H(colorValue: 0x999999)
        label.font = .zlSemiBoldFont(withSize: 15)
        label.textAlignment = .center
        view.addSubview(label)
        label.snp.makeConstraints({(make) in
            make.top.equalTo(tagLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        })

        return view
    }()

    // viewModel
    private var cellDatas: [ZLGithubItemTableViewCellData] = []

    // delegate
    @objc weak var delegate: ZLGithubItemListViewDelegate?

    @objc override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }

    @objc convenience init() {
        self.init(frame: CGRect())
    }

    @objc required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.clear
    }

    override func tintColorDidChange() {
        // appearence mode 改变
        for cellData in self.cellDatas {
            cellData.clearCache()
        }
        self.tableView.reloadData()
    }

    private func setUpUI() {

        addSubview(self.tableView)
        tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.snp_edges).inset(UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0))
        })
        
        addSubview(noDataView)
        noDataView.snp.makeConstraints({(make) in
            make.center.equalToSuperview()
        })

        noDataView.isHidden = true
        self.tableViewRegistereCell()
    }

    private func tableViewRegistereCell() {

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.tableView.register(ZLPullRequestTableViewCell.self, forCellReuseIdentifier: "ZLPullRequestTableViewCell")
        self.tableView.register(ZLCommitTableViewCell.self, forCellReuseIdentifier: "ZLCommitTableViewCell")
        self.tableView.register(UINib.init(nibName: "ZLGistTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLGistTableViewCell")
        self.tableView.register(ZLEventTableViewCell.self, forCellReuseIdentifier: "ZLEventTableViewCell")
        self.tableView.register(ZLPushEventTableViewCell.self, forCellReuseIdentifier: "ZLPushEventTableViewCell")
        self.tableView.register(ZLCommitCommentEventTableViewCell.self, forCellReuseIdentifier: "ZLCommitCommentEventTableViewCell")
        self.tableView.register(ZLIssueCommentEventTableViewCell.self, forCellReuseIdentifier: "ZLIssueCommentEventTableViewCell")
        self.tableView.register(ZLIssueEventTableViewCell.self, forCellReuseIdentifier: "ZLIssueEventTableViewCell")
        self.tableView.register(ZLCommitCommentEventTableViewCell.self, forCellReuseIdentifier: "ZLCommitCommentEventTableViewCell")
        self.tableView.register(ZLPullRequestEventTableViewCell.self, forCellReuseIdentifier: "ZLPullRequestEventTableViewCell")
        self.tableView.register(ZLRepositoryTableViewCell.self, forCellReuseIdentifier: "ZLRepositoryTableViewCell")
        self.tableView.register(ZLUserTableViewCell.self, forCellReuseIdentifier: "ZLUserTableViewCell")
        self.tableView.register(ZLIssueTableViewCell.self, forCellReuseIdentifier: "ZLIssueTableViewCell")
        self.tableView.register(ZLNotificationTableViewCell.self, forCellReuseIdentifier: "ZLNotificationTableViewCell")
        self.tableView.register(ZLWorkflowTableViewCell.self, forCellReuseIdentifier: "ZLWorkflowTableViewCell")
        self.tableView.register(ZLWorkflowRunTableViewCell.self, forCellReuseIdentifier: "ZLWorkflowRunTableViewCell")

        self.tableView.register(ZLIssueHeaderTableViewCell.self, forCellReuseIdentifier: "ZLIssueHeaderTableViewCell")
        self.tableView.register(ZLIssueCommentTableViewCell.self, forCellReuseIdentifier: "ZLIssueCommentTableViewCell")
        self.tableView.register(ZLIssueTimelineTableViewCell.self, forCellReuseIdentifier: "ZLIssueTimelineTableViewCell")

        self.tableView.register(ZLPullRequestHeaderTableViewCell.self, forCellReuseIdentifier: "ZLPullRequestHeaderTableViewCell")
        self.tableView.register(ZLPullRequestCommentTableViewCell.self, forCellReuseIdentifier: "ZLPullRequestCommentTableViewCell")
        self.tableView.register(ZLPullRequestTimelineTableViewCell.self, forCellReuseIdentifier: "ZLPullRequestTimelineTableViewCell")
    }
}

extension ZLGithubItemListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num =  self.cellDatas.count
        if num == 0 {
            self.noDataView.isHidden = false
            self.hiddenRefreshView(type: .footer)
        } else {
            self.noDataView.isHidden = true
            self.showRefreshView(type: .footer)
        }
        return num
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let tableViewCellData = self.cellDatas[indexPath.row]

        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellData.getCellReuseIdentifier(), for: indexPath)

        tableViewCellData.bindModel(nil, andView: tableViewCell)

        return tableViewCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellDatas[indexPath.row].getCellHeight()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableViewCellData = self.cellDatas[indexPath.row]
        tableViewCellData.onCellSingleTap()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tableViewCellData = self.cellDatas[indexPath.row]
        return tableViewCellData.getCellSwipeActions()
    }
}


extension ZLGithubItemListView: ZLRefreshProtocol {
    
    var scrollView: UIScrollView {
        tableView
    }
    
    func refreshLoadNewData() {
        if self.delegate?.responds(to: #selector(ZLGithubItemListViewDelegate.githubItemListViewRefreshDragDown(pullRequestListView:))) ?? false {
            self.delegate?.githubItemListViewRefreshDragDown(pullRequestListView: self)
        }
    }
    
    func refreshLoadMoreData() {
        if self.delegate?.responds(to: #selector(ZLGithubItemListViewDelegate.githubItemListViewRefreshDragUp(pullRequestListView:))) ?? false {
            self.delegate?.githubItemListViewRefreshDragUp(pullRequestListView: self)
        }
    }
}

extension ZLGithubItemListView {
    
    @objc func setTableViewHeader() {
        self.setRefreshView(type: .header)
    }

    @objc  func setTableViewFooter() {
        self.setRefreshView(type: .footer)
        self.hiddenRefreshView(type: .footer)
    }

    @objc  func deleteGithubItem(cellData: ZLGithubItemTableViewCellData) {
        cellData.removeFromSuperViewModel()
        let index = cellDatas.firstIndex(of: cellData)
        if let index = index {
            cellDatas.remove(at: index)
            self.tableView.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: UITableView.RowAnimation.fade)
        }
    }

    @objc func itemCount() -> Int {
        self.cellDatas.count
    }
    
    @objc func setCellDatas(cellDatas: [ZLGithubItemTableViewCellData], lastPage: Bool) {
        endRefreshView(type: .header)
        if lastPage {
            endRefreshFooterWithNoMoreData()
        } else {
            endRefreshView(type: .footer)
        }
    
        self.cellDatas = cellDatas
        self.tableView.reloadData()
    }
    
    @objc func resetCellDatas(cellDatas: [ZLGithubItemTableViewCellData]?) {
        
        endRefreshView(type: .footer)
        endRefreshView(type: .header)

        for cellData in self.cellDatas {
            cellData.removeFromSuperViewModel()
        }

        self.cellDatas = cellDatas ?? []
      
        self.tableView.reloadData()
    }

    @objc func appendCellDatas(cellDatas: [ZLGithubItemTableViewCellData]?) {
        if cellDatas?.isEmpty ?? true {
            endRefreshFooterWithNoMoreData()
            return
        }

        endRefreshView(type: .footer)
        
        self.cellDatas.append(contentsOf: cellDatas ?? [])
    
        self.tableView.reloadData()
    }

    @objc func resetContentOffset() {
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
    }

    @objc  func clearListView() {
        for cellData in self.cellDatas {
            cellData.removeFromSuperViewModel()
        }
        self.cellDatas.removeAll()
        self.tableView.reloadData()
    }

    @objc func beginRefresh() {
        beginRefreshView(type: .header)
    }

    @objc func endRefreshWithError() {
        endRefreshView(type: .header)
        endRefreshView(type: .footer)
    }

    @objc func justRefresh() {
        ZLRefresh.justRefreshHeader(header: self.tableView.mj_header as? MJRefreshNormalHeader)
        ZLRefresh.justRefreshFooter(footer: self.tableView.mj_footer as? MJRefreshAutoStateFooter)
        self.tableView.reloadData()
    }

    @objc func reloadData() {
        self.tableView.reloadData()
    }

    @objc func reloadVisibleCells(cellDatas: [ZLGithubItemTableViewCellData]) {
        if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows {

            let indexPaths = cellDatas.compactMap({ cellData -> IndexPath? in
                if let index = cellDatas.firstIndex(of: cellData) {
                    let indexPath =  IndexPath(row: index, section: 0)
                    if visibleIndexPaths.contains(where: { objIndexPath in
                        objIndexPath.row == indexPath.row
                    }) {
                        return indexPath
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            })

            self.tableView.reloadRows(at: indexPaths, with: .automatic)
        }
    }

}
