//
//  ZLSearchItemsViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSearchItemsViewModel: ZLBaseViewModel {
    
   
    // view
    private var searchItemsView : ZLSearchItemsView?
    
    // subViewModel
    private var searchGithubItemListViewModelArray : [ZLSearchGithubItemListSecondViewModel] = []
    private var searchFilterInfoDic : [ZLSearchType : ZLSearchFilterInfoModel] = [:]

    // model
    private var currentSearchType : ZLSearchType = .repositories
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if !(targetView is ZLSearchItemsView)
        {
            ZLLog_Warn("tagtegteViw is not ZLSearchItemsView, so return")
            return
        }
        
        self.searchItemsView = targetView as? ZLSearchItemsView
        self.searchItemsView?.delegate = self
        
        for i in 0...(ZLSearchItemsView.ZLSearchItemsTypes.count - 1) {
            let searchType = ZLSearchItemsView.ZLSearchItemsTypes[i]
            let githubItemListView = self.searchItemsView!.githubItemListViewArray[i]
            let githubItemListViewModel = ZLSearchGithubItemListSecondViewModel()
            self.searchGithubItemListViewModelArray.append(githubItemListViewModel)
            self.addSubViewModel(githubItemListViewModel)
            githubItemListViewModel.bindModel(searchType, andView: githubItemListView)
        }
    }
    
    
    func startSearch(keyWord:String?){
        for githubItemListViewModel in self.searchGithubItemListViewModelArray {
            githubItemListViewModel.searchWithKeyStr(searchKey: keyWord)
        }
    }
    
    func startInput(){
        for githubItemListViewModel in self.searchGithubItemListViewModelArray {
            githubItemListViewModel.startInput()
        }
    }
    
}



// MARK: ZLSearchItemsViewDelegate
extension ZLSearchItemsViewModel: ZLSearchItemsViewDelegate
{
    func onFilterButtonClicked(button : UIButton)
    {
        switch(self.currentSearchType)
        {
        case .repositories:do{
            
            ZLSearchFilterViewForRepo.showSearchFilterViewForRepo(filterInfo: self.searchFilterInfoDic[.repositories], resultBlock: {(searchFilterInfo : ZLSearchFilterInfoModel) in
                self.searchFilterInfoDic[.repositories] = searchFilterInfo
                let index = ZLSearchItemsView.ZLSearchItemsTypes.firstIndex(of: .repositories)
                if index != nil {
                    self.searchGithubItemListViewModelArray[index!].searchWithFilerInfo(searchFilterInfo: searchFilterInfo)
                }
            })
                        
            }
        case .users:do{
            
            ZLSearchFilterViewForUser.showSearchFilterViewForUser(filterInfo: self.searchFilterInfoDic[.users], resultBlock: {(searchFilterInfo : ZLSearchFilterInfoModel) in
                self.searchFilterInfoDic[.users] = searchFilterInfo
                let index = ZLSearchItemsView.ZLSearchItemsTypes.firstIndex(of: .users)
                if index != nil {
                    self.searchGithubItemListViewModelArray[index!].searchWithFilerInfo(searchFilterInfo: searchFilterInfo)
                }
            })
            }
        case .issues:do{
            
            ZLSearchFilterViewForIssue.showSearchFilterViewForIssue(filterInfo: self.searchFilterInfoDic[.issues], resultBlock: {(searchFilterInfo : ZLSearchFilterInfoModel) in
                self.searchFilterInfoDic[.issues] = searchFilterInfo
                let index = ZLSearchItemsView.ZLSearchItemsTypes.firstIndex(of: .issues)
                if index != nil {
                    self.searchGithubItemListViewModelArray[index!].searchWithFilerInfo(searchFilterInfo: searchFilterInfo)
                }
            })
            
        }
        case .pullRequests:do{
            
            ZLSearchFilterViewForPR.showSearchFilterViewForPR(filterInfo: self.searchFilterInfoDic[.pullRequests], resultBlock: {(searchFilterInfo : ZLSearchFilterInfoModel) in
                self.searchFilterInfoDic[.pullRequests] = searchFilterInfo
                let index = ZLSearchItemsView.ZLSearchItemsTypes.firstIndex(of: .pullRequests)
                if index != nil {
                    self.searchGithubItemListViewModelArray[index!].searchWithFilerInfo(searchFilterInfo: searchFilterInfo)
                }
            })
            
        }
        case .organizations:do{
            ZLSearchFilterViewForOrg.showSearchFilterViewForOrg(filterInfo: self.searchFilterInfoDic[.organizations], resultBlock: {(searchFilterInfo : ZLSearchFilterInfoModel) in
                self.searchFilterInfoDic[.organizations] = searchFilterInfo
                let index = ZLSearchItemsView.ZLSearchItemsTypes.firstIndex(of: .organizations)
                if index != nil {
                    self.searchGithubItemListViewModelArray[index!].searchWithFilerInfo(searchFilterInfo: searchFilterInfo)
                }
            })
        }
        @unknown default:do {
        }
        }
        
    }
    
    func onSearchTypeChanged(searchType : ZLSearchType) {
        self.currentSearchType = searchType
    }
}

