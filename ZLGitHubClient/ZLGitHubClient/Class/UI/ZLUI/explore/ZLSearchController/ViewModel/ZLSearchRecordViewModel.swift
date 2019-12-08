//
//  ZLSearchRecordViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSearchRecordViewModel: ZLBaseViewModel {
    
    var searchRecordView: ZLSearchRecordView?

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        if !(targetView is ZLSearchRecordView)
        {
            ZLLog_Warn("targteView is not ZLSearchRecordView, so return")
            return
        }
        
        self.searchRecordView = targetView as? ZLSearchRecordView
        
        
        self.searchRecordView?.tableView.delegate = self
        self.searchRecordView?.tableView.dataSource = self
        
    }
}


extension ZLSearchRecordViewModel: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSearchRecordTableViewCell", for: indexPath)
        return tableViewCell
        
    }
    
    
}
