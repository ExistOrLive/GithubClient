//
//  ZLGithubItemListView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import MJRefresh

@objc protocol ZLGithubItemListViewDelegate : NSObjectProtocol{
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) -> Void
}


@objcMembers class ZLGithubItemListView: ZLBaseView {
    
    // view
    private var tableView : UITableView?
    private var noDataView : UIView?
    
    // viewModel
    private var cellDatas : [ZLGithubItemTableViewCellData]?
    
    // delegate
    weak var delegate : ZLGithubItemListViewDelegate?
        
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
    
    override func awakeFromNib() {
        self.tableView?.separatorStyle = .none
        self.tableView?.backgroundColor = UIColor.clear
    }
    
    override func tintColorDidChange() {
        // appearence mode 改变
        if let tmpCellDatas = self.cellDatas{
            for cellData in tmpCellDatas{
                cellData.clearCache()
            }
        }
        self.tableView?.reloadData()
    }
    
    
    
    private func setUpUI()
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
        
        self.setNoDataView()
    }
    
    
    private func tableViewRegistereCell()
    {
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.tableView?.register(UINib.init(nibName: "ZLPullRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLPullRequestTableViewCell")
        self.tableView?.register(UINib.init(nibName: "ZLCommitTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLCommitTableViewCell")
        self.tableView?.register(UINib.init(nibName: "ZLGistTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLGistTableViewCell")
        self.tableView?.register(ZLEventTableViewCell.self, forCellReuseIdentifier: "ZLEventTableViewCell")
        self.tableView?.register(ZLPushEventTableViewCell.self, forCellReuseIdentifier: "ZLPushEventTableViewCell")
        self.tableView?.register(ZLCommitCommentEventTableViewCell.self, forCellReuseIdentifier: "ZLCommitCommentEventTableViewCell")
        self.tableView?.register(ZLIssueCommentEventTableViewCell.self, forCellReuseIdentifier: "ZLIssueCommentEventTableViewCell")
        self.tableView?.register(ZLIssueEventTableViewCell.self, forCellReuseIdentifier: "ZLIssueEventTableViewCell")
        self.tableView?.register(ZLCommitCommentEventTableViewCell.self, forCellReuseIdentifier: "ZLCommitCommentEventTableViewCell")
        self.tableView?.register(ZLPullRequestEventTableViewCell.self, forCellReuseIdentifier: "ZLPullRequestEventTableViewCell")
        self.tableView?.register(UINib.init(nibName: "ZLRepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLRepositoryTableViewCell")
        self.tableView?.register(UINib.init(nibName: "ZLUserTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLUserTableViewCell")
        self.tableView?.register(UINib.init(nibName: "ZLIssueTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLIssueTableViewCell")
        self.tableView?.register(UINib.init(nibName: "ZLNotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLNotificationTableViewCell")
        self.tableView?.register(UINib.init(nibName: "ZLWorkflowTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLWorkflowTableViewCell")
        self.tableView?.register(UINib.init(nibName: "ZLWorkflowRunTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLWorkflowRunTableViewCell")
        
        self.tableView?.register(ZLIssueHeaderTableViewCell.self, forCellReuseIdentifier: "ZLIssueHeaderTableViewCell")
        self.tableView?.register(ZLIssueCommentTableViewCell.self, forCellReuseIdentifier: "ZLIssueCommentTableViewCell")
        self.tableView?.register(ZLIssueTimelineTableViewCell.self, forCellReuseIdentifier: "ZLIssueTimelineTableViewCell")
        
        
        self.tableView?.register(ZLPullRequestHeaderTableViewCell.self, forCellReuseIdentifier: "ZLPullRequestHeaderTableViewCell")
    }
    
    private func setNoDataView() -> Void {
        let view = UIView.init()
        view.backgroundColor = UIColor.clear
        
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "NoData")
        view.addSubview(imageView)
        imageView.snp.makeConstraints ({ (make) in
            make.size.equalTo(CGSize.init(width: 50, height: 50))
            make.top.left.right.equalToSuperview()
        })
        
        let label = UILabel.init()
        label.text = "No Data"
        label.textColor = ZLRGBValue_H(colorValue: 0x999999)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        view.addSubview(label)
        label.snp.makeConstraints({(make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        
        self.addSubview(view)
        view.snp.makeConstraints({(make) in
            make.center.equalToSuperview()
        })
        
        noDataView = view
        view.isHidden = true
    }
    
    
    @objc func setTableViewHeader(){
        weak var selfWeak = self
        self.tableView?.mj_header = ZLRefresh.refreshHeader(refreshingBlock: {
            selfWeak?.loadNewData()
        })
    }
    
    @objc func setTableViewFooter(){
        weak var selfWeak = self
        self.tableView?.mj_footer = ZLRefresh.refreshFooter(refreshingBlock: {
            selfWeak?.loadMoreData()
        })
    }
    
    func deleteGithubItem(cellData : ZLGithubItemTableViewCellData) {
        cellData.removeFromSuperViewModel()
        let index = cellDatas?.firstIndex(of: cellData)
        if index != nil {
            cellDatas?.remove(at: index!)
            self.tableView?.deleteRows(at: [IndexPath.init(row: index!, section: 0)], with: UITableView.RowAnimation.fade)
        }
    }
    
    
    func itemCount() -> Int
    {
        return self.cellDatas?.count ?? 0
    }
}

extension ZLGithubItemListView : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num =  self.cellDatas?.count ?? 0
        self.noDataView?.isHidden = (num != 0)
        
        return num;
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableViewCellData = self.cellDatas?[indexPath.row]
        tableViewCellData?.onCellSingleTap()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tableViewCellData = self.cellDatas?[indexPath.row]
        return tableViewCellData?.getCellSwipeActions()
    }
}

extension ZLGithubItemListView
{
    func loadNewData(){
        if self.delegate?.responds(to:#selector(ZLGithubItemListViewDelegate.githubItemListViewRefreshDragDown(pullRequestListView:))) ?? false{
            self.delegate?.githubItemListViewRefreshDragDown(pullRequestListView: self)
        }
    }
    
    func loadMoreData(){
        if self.delegate?.responds(to:#selector(ZLGithubItemListViewDelegate.githubItemListViewRefreshDragUp(pullRequestListView:))) ?? false{
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
        
        if self.cellDatas != nil{
            for cellData in self.cellDatas!{
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
    
    func resetContentOffset(){
        self.tableView?.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func clearListView(){
        
        if self.cellDatas != nil{
            for cellData in self.cellDatas!{
                cellData.removeFromSuperViewModel()
            }
        }
      
        self.cellDatas?.removeAll()
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
    
    func justRefresh(){
        ZLRefresh.justRefreshHeader(header: self.tableView?.mj_header as? MJRefreshNormalHeader)
        ZLRefresh.justRefreshFooter(footer: self.tableView?.mj_footer as? MJRefreshAutoStateFooter)
        self.tableView?.reloadData();
    }
    
    func reloadData(){
        self.tableView?.reloadData()
    }
}
