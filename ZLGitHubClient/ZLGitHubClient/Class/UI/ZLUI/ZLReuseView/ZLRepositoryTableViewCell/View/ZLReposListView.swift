//
//  ZLReposListView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/10.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLReposListView: ZLBaseView {

    var tableView : UITableView?
    
    var refreshManager : ZMRefreshManager?
    
    var cellDatas : [ZLEventTableViewCellData]?
    
    var delegate : ZLEventListViewDelegate?
    
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
        
        return tableViewCell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
}

// MARK: ZMRefreshManager
extension ZLReposListView : ZMRefreshManagerDelegate
{
    func zmRefreshIsDragUp(_ isDragUp: Bool, refreshView: UIView!) {
        
    }
}
