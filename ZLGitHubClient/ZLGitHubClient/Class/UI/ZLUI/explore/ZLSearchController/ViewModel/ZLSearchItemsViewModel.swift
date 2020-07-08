//
//  ZLSearchItemsViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit



class ZLSearchTypeAttachInfo: NSObject
{
    var searchFilterInfo : ZLSearchFilterInfoModel? = nil               // 默认为空
    var currentPage: Int = 0                                            // 默认为0
    var itemsInfo : [Any]?                                              // 搜索的结果
    var isEnd : Bool  = false                                           // 是否全部搜索完毕
    
    var contentOffset : CGPoint = CGPoint(x:0,y:0)            // tableView的contentSize
    
}

enum  ZLSearchItemsViewEventType
{
    case userFilterResult
    case repoFilterResult
}


class ZLSearchItemsViewModel: ZLBaseViewModel {
    
   
    // view
    private var searchItemsView : ZLSearchItemsView?
    
    // subViewModel
    private var searchGithubItemListViewModelArray : [ZLSearchGithubItemListViewModel] = []
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
            let githubItemListViewModel = ZLSearchGithubItemListViewModel.init()
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
        case .commits: break
        case .issues: break
        case .code: break
        case .topics: break
        @unknown default:do {
        }
        }
        
    }
    
    func onSearchTypeChanged(searchType : ZLSearchType) {
        self.currentSearchType = searchType
    }
}

