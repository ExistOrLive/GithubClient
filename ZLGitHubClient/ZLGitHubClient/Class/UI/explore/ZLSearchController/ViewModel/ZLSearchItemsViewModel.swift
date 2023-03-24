//
//  ZLSearchItemsViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLGitRemoteService

class ZLSearchItemsViewModel: ZLBaseViewModel {

    // view
    private var searchItemsView: ZLSearchItemsView?

    // subViewModel
    private var searchGithubItemListViewModelArray: [ZLSearchGithubItemListSecondViewModel] = []
    private var searchFilterInfoDic: [ZLSearchType: ZLSearchFilterInfoModel] = [:]

    // model
    private var currentSearchType: ZLSearchType = .repositories
    
    // filterViewManager
    private lazy var filterViewManager: ZLSearchFilterViewManager = ZLSearchFilterViewManager(viewModel: self)

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {

        guard let targetView = targetView as? ZLSearchItemsView else {

            ZLLog_Warn("tagtegteViw is not ZLSearchItemsView, so return")
            return
        }

        self.searchItemsView = targetView
        self.searchItemsView?.delegate = self

        for i in 0...(ZLSearchItemsView.ZLSearchItemsTypes.count - 1) {
            let searchType = ZLSearchItemsView.ZLSearchItemsTypes[i]
            let githubItemListView = targetView.githubItemListViewArray[i]
            let githubItemListViewModel = ZLSearchGithubItemListSecondViewModel()
            self.searchGithubItemListViewModelArray.append(githubItemListViewModel)
            self.addSubViewModel(githubItemListViewModel)
            githubItemListViewModel.bindModel(searchType, andView: githubItemListView)
        }
    }

    func startSearch(keyWord: String?) {
        for githubItemListViewModel in self.searchGithubItemListViewModelArray {
            githubItemListViewModel.searchWithKeyStr(searchKey: keyWord)
        }
    }

    func startInput() {
        for githubItemListViewModel in self.searchGithubItemListViewModelArray {
            githubItemListViewModel.startInput()
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
