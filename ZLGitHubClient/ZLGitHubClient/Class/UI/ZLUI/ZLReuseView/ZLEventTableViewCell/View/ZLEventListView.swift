//
//  ZLEventListView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/11/27.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

protocol ZLEventListViewDelegate {
    
    func cellDatasFor(eventListView: ZLEventListView) -> [ZLEventTableViewCellData];
    
    func eventListViewRefreshDragUp(eventListView: ZLEventListView) -> Void;
    
    func eventListViewRefreshDragDown(eventListView: ZLEventListView) -> Void;
    
    
}

class ZLEventListView: UIView {
 
    var tableView : UITableView?
    
    var cellDatas : [ZLEventTableViewCellData]?
    
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
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), style: .plain)
        self.tableView?.separatorStyle = .none
        self.tableView?.backgroundColor = UIColor.clear
        self.addSubview(self.tableView!)
        self.tableView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.snp_edges)
        })
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self;
        self.tableView?.register(ZLEventTableViewCell.self, forCellReuseIdentifier: "ZLEventTableViewCell")
        
        
        
    }
}


extension ZLEventListView : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellDatas?.count ?? 0
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData  = self.cellDatas?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZLEventTableViewCell", for: indexPath)
        
        cellData?.bindModel(nil, andView: cell)
        
        return cell
         
     }
}


