//
//  ZLGithubItemListView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
@objc protocol ZLGithubItemListViewDelegate : NSObjectProtocol
{
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void;
    
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) -> Void;
}


@objcMembers class ZLGithubItemListView: ZLBaseView {
    
    var tableView : UITableView?
    
    private var cellDatas : [ZLGithubItemTableViewCellData]?
    
    var delegate : ZLGithubItemListViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.setUpUI()
    }
    
    convenience init()
    {
        self.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpUI()
    }
    
    func setUpUI()
    {
        self.tableView = UITableView.init(frame: self.bounds, style: .plain)
        self.tableView?.separatorStyle = .none
        self.tableView?.backgroundColor = UIColor.clear
        self.tableViewRegistereCell()
        self.addSubview(self.tableView!)
        self.tableView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.snp_edges).inset(UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0))
        })
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self;
    }
    
    
    private func tableViewRegistereCell()
    {
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.tableView?.register(UINib.init(nibName: "ZLPullRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLPullRequestTableViewCell")
        self.tableView?.register(UINib.init(nibName: "ZLCommitTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLCommitTableViewCell")
        self.tableView?.register(UINib.init(nibName: "ZLGistTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLGistTableViewCell")
        self.tableView?.register(ZLEventTableViewCell.self, forCellReuseIdentifier: "ZLEventTableViewCell")
        self.tableView?.register(ZLPushEventTableViewCell.self, forCellReuseIdentifier: "ZLPushEventTableViewCell")
        self.tableView?.register(UINib.init(nibName: "ZLRepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLRepositoryTableViewCell")
        self.tableView?.register(UINib.init(nibName: "ZLUserTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLUserTableViewCell")
        self.tableView?.register(UINib.init(nibName: "ZLIssueTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLIssueTableViewCell")
    }
    
    @objc func setTableViewHeader()
    {
        weak var selfWeak = self
        self.tableView?.mj_header = ZLRefresh.refreshHeader(refreshingBlock: {
            selfWeak?.loadNewData()
        })
    }
    
    @objc func setTableViewFooter()
    {
        weak var selfWeak = self
        self.tableView?.mj_footer = ZLRefresh.refreshFooter(refreshingBlock: {
            selfWeak?.loadMoreData()
        })
    }
    
    func itemCount() -> Int
    {
        return self.cellDatas?.count ?? 0
    }
}

extension ZLGithubItemListView : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellDatas?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableViewCellData = self.cellDatas?[indexPath.row]
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellData?.getCellReuseIdentifier() ?? "UITableViewCell", for: indexPath)
        
        tableViewCellData?.bindModel(nil, andView: tableViewCell)
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellDatas?[indexPath.row].getCellHeight() ?? 0.0
    }
}

extension ZLGithubItemListView
{
    func loadNewData()
    {
        
        if
            self.delegate?.responds(to:#selector(ZLGithubItemListViewDelegate.githubItemListViewRefreshDragDown(pullRequestListView:))) ?? false
        {
            self.delegate?.githubItemListViewRefreshDragDown(pullRequestListView: self)
        }
        
    }
    
    func loadMoreData()
    {
        if self.delegate?.responds(to:#selector(ZLGithubItemListViewDelegate.githubItemListViewRefreshDragUp(pullRequestListView:))) ?? false
        {
            self.delegate?.githubItemListViewRefreshDragUp(pullRequestListView: self)
        }
    }
}


extension ZLGithubItemListView
{
    func resetCellDatas(cellDatas: [ZLGithubItemTableViewCellData]?)
    {
        self.tableView?.mj_header?.endRefreshing()
        self.tableView?.mj_footer?.endRefreshing()
        
        if self.cellDatas != nil
        {
            for cellData in self.cellDatas!
            {
                cellData.removeFromSuperViewModel()
            }
        }
        
        self.cellDatas = cellDatas;
        self.tableView?.reloadData();
    }
    
    func appendCellDatas(cellDatas: [ZLGithubItemTableViewCellData]?)
    {
        if((cellDatas == nil) || cellDatas?.count == 0)
        {
            self.tableView?.mj_footer?.endRefreshingWithNoMoreData()
            return
        }
        
        self.tableView?.mj_footer?.endRefreshing()
        
        if(self.cellDatas == nil)
        {
            self.cellDatas = [];
        }
        self.cellDatas?.append(contentsOf: cellDatas!)
        self.tableView?.reloadData()
    }
    
    
    func beginRefresh()
    {
        self.tableView?.mj_header?.beginRefreshing()
    }
    
    
    func endRefreshWithError()
    {
        self.tableView?.mj_header?.endRefreshing()
        self.tableView?.mj_footer?.endRefreshing()
    }
    
}
