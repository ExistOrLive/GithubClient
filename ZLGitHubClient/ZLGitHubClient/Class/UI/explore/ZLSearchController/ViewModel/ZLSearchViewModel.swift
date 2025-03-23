//
//  ZLSearchViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/3.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZMMVVM

class ZLSearchViewModel: ZMBaseViewModel {

    // view
    var searchView: ZLSearchView? {
        zm_view as? ZLSearchView
    }

    // viewModel
    lazy var searchItemsViewModel: ZLSearchItemsViewModel = {
        let viewModel = ZLSearchItemsViewModel()
        self.zm_addSubViewModel(viewModel)
        return viewModel
    }()
    lazy var searchRecordViewModel: ZLSearchRecordViewModel = {
        let viewModel = ZLSearchRecordViewModel()
        viewModel.resultBlock = {[weak self](searchKey: String) in
            self?.searchView?.setUnEditStatus()
            self?.searchView?.searchTextField.text = searchKey
            self?.searchView?.searchTextField.resignFirstResponder()
            self?.searchItemsViewModel.startSearch(keyWord: searchKey)
            self?.searchRecordViewModel.onSearhKeyConfirmed(searchKey: searchKey)
        }
        self.zm_addSubViewModel(viewModel)
        return viewModel
    }()

    var searchKey: String? 
    var preSearchKeyWord: String?                // 保存之前搜索的关键字
    
    init(searchKey: String? ) {
        self.searchKey = searchKey
        super.init()
    }
    
    override func zm_onViewUpdated() {
        if let searchKey = searchKey {
            self.searchItemsViewModel.startSearch(keyWord: searchKey)
            self.searchRecordViewModel.onSearhKeyConfirmed(searchKey: searchKey)
        }
    }
    
    @objc func onBackButtonClicked() {
        zm_viewController?.navigationController?.popViewController(animated: true)
    }

}
