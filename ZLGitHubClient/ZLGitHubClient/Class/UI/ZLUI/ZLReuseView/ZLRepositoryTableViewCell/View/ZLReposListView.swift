//
//  ZLReposListView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/10.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLReposListViewDelegate : NSObjectProtocol {
    
    func reposListViewRefreshDragUp(reposListView : ZLReposListView) -> Void
    
    func reposListViewRefreshDragDown(reposListView : ZLReposListView) -> Void
}

@objcMembers class ZLReposListView: ZLBaseView {

    var tableView : UITableView?
    
    var refreshManager : ZMRefreshManager?
    
    var cellDatas : [ZLRepositoryTableViewCellData]?
    
    @objc var delegate : ZLReposListViewDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        self.setUpUI()
    }
    
    func setUpUI() -> Void
    {
        self.tableView = UITableView.init(frame: self.bounds, style: .plain)
        self.tableView?.separatorStyle = .none
        self.tableView?.backgroundColor = UIColor.clear
        self.addSubview(self.tableView!)
        self.tableView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.snp_edges)
        })
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self;
        self.tableView?.register(UINib.init(nibName: "ZLRepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLRepositoryTableViewCell")
        
        self.refreshManager = ZMRefreshManager.init(scrollView: self.tableView, addHeaderView: true, addFooterView: true)
        self.refreshManager?.delegate = self;
        
    }
}


extension ZLReposListView : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tableViewCell : ZLRepositoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLRepositoryTableViewCell", for: indexPath) as? ZLRepositoryTableViewCell else
        {
            return UITableViewCell.init(style: .default, reuseIdentifier: "UITableViewCell")
        }
        let cellData : ZLRepositoryTableViewCellData? = self.cellDatas?[indexPath.row]
        cellData?.bindModel(nil, andView: tableViewCell)
        
        return tableViewCell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellDatas?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellDatas?[indexPath.row].getCellHeight() ?? 0
    }
}

// MARK: ZMRefreshManager
extension ZLReposListView : ZMRefreshManagerDelegate
{
    func zmRefreshIsDragUp(_ isDragUp: Bool, refreshView: UIView!) {
        
        if(isDragUp)    // 上拉
        {
            if self.delegate?.responds(to: #selector(ZLReposListViewDelegate.reposListViewRefreshDragUp(reposListView:))) ?? false
            {
                self.delegate?.reposListViewRefreshDragUp(reposListView: self)
            }
        }
        else           // 下拉
        {
            if self.delegate?.responds(to: #selector(ZLReposListViewDelegate.reposListViewRefreshDragDown(reposListView:))) ?? false
            {
                self.delegate?.reposListViewRefreshDragDown(reposListView: self)
            }
        }
    }
}

extension ZLReposListView
{
    func resetCellDatas(cellDatas: [ZLRepositoryTableViewCellData]?)
    {
        self.refreshManager?.resetFooterViewInit();
        self.refreshManager?.resetHeaderViewInit();
        
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
    
    func apppendCellDatas(cellDatas: [ZLRepositoryTableViewCellData]?)
    {
        if((cellDatas == nil) || cellDatas?.count == 0)
        {
            self.refreshManager?.setFooterViewNoMoreFresh()
            return
        }
        
        self.refreshManager?.setFooterViewRefreshEnd()
        
        if(self.cellDatas == nil)
        {
            self.cellDatas = [];
        }
        self.cellDatas?.append(contentsOf: cellDatas!)
        self.tableView?.reloadData()
    }
    
    
    func beginRefresh()
    {
        self.refreshManager?.headerBeginRefreshing()
    }
    
    
    func endRefreshWithError()
    {
        self.refreshManager?.setFooterViewRefreshEnd()
        self.refreshManager?.setHeaderViewRefreshEnd()
    }
    
}
