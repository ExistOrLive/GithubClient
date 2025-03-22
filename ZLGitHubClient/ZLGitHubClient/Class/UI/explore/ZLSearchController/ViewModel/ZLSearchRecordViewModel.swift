//
//  ZLSearchRecordViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZMMVVM

class ZLSearchRecordViewModel: ZMBaseTableViewCellViewModel {
    
    // view
    var searchRecordView: ZLSearchRecordView? {
        zm_view as? ZLSearchRecordView
    }

    // model
    var searchRecordArray: [String] = []

    var tmpSearchRecordArray: [String] = []
    var searchKey: String?

    // resultBlocl
    var resultBlock: ((String) -> Void)?

    
    override init() {
        super.init()
        self.searchRecordArray = ZLUISharedDataManager.searchRecordArray ?? []
        self.filterRecord()
    }

    func filterRecord() {
        if let searchKey = searchKey,
           !searchKey.isEmpty {
            let tmpArray = searchRecordArray.filter { (model: String) -> Bool in
                return model.lowercased().contains(find: searchKey.lowercased())
            }
            self.tmpSearchRecordArray = Array.init(tmpArray.prefix(10))
        } else {
            self.tmpSearchRecordArray = Array.init(searchRecordArray.prefix(10))
        }
        self.searchRecordView?.tableView.reloadData()
    }

    func onSearchKeyChanged(searchKey: String?) {
        self.searchKey = searchKey
        self.filterRecord()
    }

    func onSearhKeyConfirmed(searchKey: String?) {

        guard let searchKey = searchKey,
              !searchKey.isEmpty else {
            return
        }

        var recordArray = self.searchRecordArray
        if let index = recordArray.firstIndex(of: searchKey) {
            recordArray.remove(at: index)
        }
        recordArray.insert(searchKey, at: 0)
        recordArray = Array.init(recordArray.prefix(50))
        self.searchRecordArray = recordArray
        ZLUISharedDataManager.searchRecordArray = recordArray
    }

}

extension ZLSearchRecordViewModel: ZLSearchRecordViewDelegate {
    func clearRecord() {
        self.searchRecordArray = []
        self.filterRecord()
        ZLUISharedDataManager.searchRecordArray = []
    }
    
    func didSelectRecord(record: String) {
        resultBlock?(record)
    }
}
