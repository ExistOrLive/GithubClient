//
//  ZLEventListView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/11/27.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLEventListViewDelegate : NSObjectProtocol {
    
    func eventListViewRefreshDragUp(eventListView: ZLEventListView) -> Void;
    
    func eventListViewRefreshDragDown(eventListView: ZLEventListView) -> Void;
    
}

class ZLEventListView: UIView {
 
    var tableView : UITableView?
    
    var refreshManager : ZMRefreshManager?
    
    var cellDatas : [ZLEventTableViewCellData]?
    
    weak var delegate : ZLEventListViewDelegate?
    
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
        self.tableView?.register(ZLEventTableViewCell.self, forCellReuseIdentifier: "ZLEventTableViewCell")
        self.tableView?.register(ZLPushEventTableViewCell.self, forCellReuseIdentifier: "ZLPushEventTableViewCell")
        
        self.refreshManager = ZMRefreshManager.init(scrollView: self.tableView, addHeaderView: true, addFooterView: true)
        self.refreshManager?.delegate = self;
        
    }
}


extension ZLEventListView : UITableViewDataSource,UITableViewDelegate
{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellDatas?.count ?? 0
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cellData  = self.cellDatas?[indexPath.row]
        let reuseIdentifier = cellData?.getCellReuseIdentifier() ?? "ZLEventTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cellData?.bindModel(nil, andView: cell)
        
        return cell
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellDatas?[indexPath.row].getCellHeight() ?? 0.0
    }
}


extension ZLEventListView : ZMRefreshManagerDelegate
{
    func zmRefreshIsDragUp(_ isDragUp: Bool, refreshView: UIView!) {
        
        if(isDragUp)    // 上拉
        {
            if self.delegate?.responds(to: #selector(ZLEventListViewDelegate.eventListViewRefreshDragUp(eventListView:))) ?? false
            {
                self.delegate?.eventListViewRefreshDragUp(eventListView: self)
            }
        }
        else           // 下拉
        {
            if self.delegate?.responds(to:#selector(ZLEventListViewDelegate.eventListViewRefreshDragDown(eventListView:))) ?? false
            {
                self.delegate?.eventListViewRefreshDragDown(eventListView: self)
            }
        }
    }
}

extension ZLEventListView
{
    func resetCellDatas(cellDatas: [ZLEventTableViewCellData]?)
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
    
    func apppendCellDatas(cellDatas: [ZLEventTableViewCellData]?)
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

