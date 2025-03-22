//
//  ZLSearchItemsViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZMMVVM

class ZLSearchItemsViewModel: ZMBaseViewModel {

    // subViewModel
    internal var searchGithubItemListViewModelArray: [ZLSearchGithubItemListSecondViewModel] = []
    private var searchFilterInfoDic: [ZLSearchType: ZLSearchFilterInfoModel] = [:]

    // model
    private var currentSearchType: ZLSearchType = .repositories
    
    // filterViewManager
    private lazy var filterViewManager: ZLSearchFilterViewManager = ZLSearchFilterViewManager(viewModel: self)

    override init() {
        super.init()
        for i in 0...(ZLSearchItemsView.ZLSearchItemsTypes.count - 1) {
            let searchType = ZLSearchItemsView.ZLSearchItemsTypes[i]
            let subViewModel = ZLSearchGithubItemListSecondViewModel(searchType: searchType)
            searchGithubItemListViewModelArray.append(subViewModel)
        }
        zm_addSubViewModels(searchGithubItemListViewModelArray)
    }
    
    func startSearch(keyWord: String?) {
        for githubItemListViewModel in self.searchGithubItemListViewModelArray {
            githubItemListViewModel.searchWithKeyStr(searchKey: keyWord)
        }
    }
}

// MARK: ZLSearchItemsViewDelegate
extension ZLSearchItemsViewModel: ZLSearchItemsViewDelegate {
    func onFilterButtonClicked(button: UIButton) {
        
        filterViewManager.showSearchFilterViewFor(searchType: currentSearchType ,
                                                  filterBlock: { [weak self] model in
            guard let self = self else { return }
            self.searchFilterInfoDic[self.currentSearchType] = model
            if let index = ZLSearchItemsView.ZLSearchItemsTypes.firstIndex(of: self.currentSearchType) {
                self.searchGithubItemListViewModelArray[index].searchWithFilerInfo(searchFilterInfo: model)
            }
        })
    }

    func onSearchTypeChanged(searchType: ZLSearchType) {
        self.currentSearchType = searchType
    }
}
