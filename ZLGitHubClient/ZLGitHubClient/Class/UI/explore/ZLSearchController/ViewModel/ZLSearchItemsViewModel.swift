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
        switch self.currentSearchType {
        case .repositories:do {

            ZLSearchFilterViewForRepo.showSearchFilterViewForRepo(filterInfo: self.searchFilterInfoDic[.repositories], resultBlock: {(searchFilterInfo: ZLSearchFilterInfoModel) in
                self.searchFilterInfoDic[.repositories] = searchFilterInfo
                if let index = ZLSearchItemsView.ZLSearchItemsTypes.firstIndex(of: .repositories) {
                    self.searchGithubItemListViewModelArray[index].searchWithFilerInfo(searchFilterInfo: searchFilterInfo)
                }
            })

            }
        case .users:do {

            ZLSearchFilterViewForUser.showSearchFilterViewForUser(filterInfo: self.searchFilterInfoDic[.users], resultBlock: {(searchFilterInfo: ZLSearchFilterInfoModel) in
                self.searchFilterInfoDic[.users] = searchFilterInfo
                if let index = ZLSearchItemsView.ZLSearchItemsTypes.firstIndex(of: .users) {
                    self.searchGithubItemListViewModelArray[index].searchWithFilerInfo(searchFilterInfo: searchFilterInfo)
                }
            })
            }
        case .issues:do {

            ZLSearchFilterViewForIssue.showSearchFilterViewForIssue(filterInfo: self.searchFilterInfoDic[.issues], resultBlock: {(searchFilterInfo: ZLSearchFilterInfoModel) in
                self.searchFilterInfoDic[.issues] = searchFilterInfo
                if let index = ZLSearchItemsView.ZLSearchItemsTypes.firstIndex(of: .issues) {
                    self.searchGithubItemListViewModelArray[index].searchWithFilerInfo(searchFilterInfo: searchFilterInfo)
                }
            })

        }
        case .pullRequests:do {

            ZLSearchFilterViewForPR.showSearchFilterViewForPR(filterInfo: self.searchFilterInfoDic[.pullRequests], resultBlock: {(searchFilterInfo: ZLSearchFilterInfoModel) in
                self.searchFilterInfoDic[.pullRequests] = searchFilterInfo
                if let index = ZLSearchItemsView.ZLSearchItemsTypes.firstIndex(of: .pullRequests) {
                    self.searchGithubItemListViewModelArray[index].searchWithFilerInfo(searchFilterInfo: searchFilterInfo)
                }
            })

        }
        case .organizations:do {
            ZLSearchFilterViewForOrg.showSearchFilterViewForOrg(filterInfo: self.searchFilterInfoDic[.organizations], resultBlock: {(searchFilterInfo: ZLSearchFilterInfoModel) in
                self.searchFilterInfoDic[.organizations] = searchFilterInfo
                if let index = ZLSearchItemsView.ZLSearchItemsTypes.firstIndex(of: .organizations) {
                    self.searchGithubItemListViewModelArray[index].searchWithFilerInfo(searchFilterInfo: searchFilterInfo)
                }
            })
        }
        @unknown default:do {
        }
        }

    }

    func onSearchTypeChanged(searchType: ZLSearchType) {
        self.currentSearchType = searchType
    }
}
