//
//  ZLPullRequestListView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/15.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLPullRequestListViewDelegate : NSObjectProtocol
{
    func pullRequestListViewRefreshDragDown(pullRequestListView: ZLPullRequestListView) -> Void;
}


class ZLPullRequestListView: ZLBaseView {

    private var tableView : UITableView?
    
    private var refreshManager : ZMRefreshManager?
     
    private var cellDatas : [ZLPullRequestTableViewCellData]?
     
    var delegate : ZLPullRequestListViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.setUpUI()
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
        self.tableView?.register(UINib.init(nibName: "ZLPullRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLPullRequestTableViewCell")
        self.addSubview(self.tableView!)
        self.tableView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.snp_edges).inset(UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0))
        })
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self;
       
        weak var selfWeak = self
        self.tableView?.mj_header = ZLRefresh.refreshHeader(refreshingBlock: {
            selfWeak?.startRefresh()
        })
    }
}

extension ZLPullRequestListView : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellDatas?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLPullRequestTableViewCell", for: indexPath) as! ZLPullRequestTableViewCell
        
        let tableViewCellData = self.cellDatas?[indexPath.row]
        
        tableViewCellData?.bindModel(nil, andView: tableViewCell)
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return self.cellDatas?[indexPath.row].getCellHeight() ?? 0.0
       }
}

extension ZLPullRequestListView
{
    func startRefresh() {
        
        
        if
            self.delegate?.responds(to:#selector(ZLPullRequestListViewDelegate.pullRequestListViewRefreshDragDown(pullRequestListView:))) ?? false
        {
            self.delegate?.pullRequestListViewRefreshDragDown(pullRequestListView:self)
        }
        
    }
}


extension ZLPullRequestListView
{
    func resetCellDatas(cellDatas: [ZLPullRequestTableViewCellData]?)
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
    
    func apppendCellDatas(cellDatas: [ZLPullRequestTableViewCellData]?)
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
