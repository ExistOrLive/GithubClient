//
//  ZLSearchRecordViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSearchRecordViewModel: ZLBaseViewModel {
    
    // view
    var searchRecordView: ZLSearchRecordView?

    // model
    var searchRecordArray: [String] = []
    
    var tmpSearchRecordArray : [String] = []
    var searchKey : String?
    
    // resultBlocl
    var resultBlock : ((String) -> Void)?
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        if !(targetView is ZLSearchRecordView)
        {
            ZLLog_Warn("targteView is not ZLSearchRecordView, so return")
            return
        }
        
        self.searchRecordView = targetView as? ZLSearchRecordView
        self.searchRecordView?.delegate = self
        self.searchRecordView?.tableView.delegate = self
        self.searchRecordView?.tableView.dataSource = self
        
        self.searchRecordArray = ZLUISharedDataManager.searchRecordArray ?? []
        self.filterRecord()
    }
    
    
    func filterRecord() {
        if searchKey == nil || searchKey?.count == 0 {
            self.tmpSearchRecordArray = Array.init(searchRecordArray.prefix(10))
        } else {
            let tmpArray = searchRecordArray.filter { (model : String) -> Bool in
                return model.contains(find: searchKey!)
            }
            self.tmpSearchRecordArray = Array.init(tmpArray.prefix(10))
        }
        self.searchRecordView?.tableView.reloadData()
    }
    
    func onSearchKeyChanged(searchKey: String?) {
        self.searchKey = searchKey
        self.filterRecord()
    }
    
    func onSearhKeyConfirmed(searchKey: String?) {
        if searchKey == nil || searchKey?.count == 0 {
            return
        }
        
        var recordArray = self.searchRecordArray
        let index = recordArray.firstIndex(of: searchKey!)
        if index != nil {
            recordArray.remove(at: index!)
        }
        recordArray.insert(searchKey!, at: 0)
        recordArray = Array.init(recordArray.prefix(50))
        self.searchRecordArray = recordArray
        ZLUISharedDataManager.searchRecordArray = recordArray
    }
    
    
    
}


extension ZLSearchRecordViewModel : ZLSearchRecordViewDelegate {
    func clearRecord() -> Void {
        self.searchRecordArray = []
        self.filterRecord()
        ZLUISharedDataManager.searchRecordArray = []
    }
}


extension ZLSearchRecordViewModel: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tmpSearchRecordArray.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let record = self.tmpSearchRecordArray[indexPath.row]
        guard  let tableViewCell : ZLSearchRecordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSearchRecordTableViewCell", for: indexPath) as? ZLSearchRecordTableViewCell else {
            return UITableViewCell.init(style: .default, reuseIdentifier: "")
        }
        tableViewCell.recordLabel.text = record
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record = self.tmpSearchRecordArray[indexPath.row]
        self.resultBlock?(record)
    }
    
    
}
