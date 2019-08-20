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
    private var refreshManager: ZMRefreshManager?
    
    // model
    static let per_page : Int = 10
    var keyWord : String = ""                                           // 搜索关键字
    var currentSearchType : ZLSearchType = .repositories                // 当前搜索类型
    var searchFilterInfo : ZLSearchFilterInfoModel? = nil               // 默认为空
    var currentPage: Int = 0                                                 // 默认为0
    
    var itemsInfo : [Any]?                                              // 搜索的结果
    
    deinit {
        ZLSearchServiceModel.shared().unRegisterObserver(self, name: ZLSearchResult_Notification)
        self.refreshManager?.free()
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if !(targetView is ZLSearchItemsView)
        {
            ZLLog_Warn("tagtegteViw is not ZLSearchItemsView, so return")
            return
        }
        
        self.searchItemsView = targetView as? ZLSearchItemsView
        
        self.searchItemsView?.tableView.delegate = self
        self.searchItemsView?.tableView.dataSource = self
        
        self.searchItemsView?.searchTypeCollectionView.delegate = self
        self.searchItemsView?.searchTypeCollectionView.dataSource = self
        
        ZLSearchServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLSearchResult_Notification)
        
    }
    
    
    func startSearch(keyWord:String?)
    {
        
        // 更换关键字，一切状态重置
        self.currentPage = 0
        self.refreshManager?.setFooterViewRefreshEnd() // 设置refresh为init状态
        self.itemsInfo = nil
        self.searchItemsView?.tableView.reloadData()
        
        if keyWord == nil || keyWord! == ""
        {
            self.keyWord = ""
        }
        else
        {
            self.keyWord = keyWord!
            self.searchItemsView?.indicatorBackView.isHidden = false
            self.searchItemsView?.activityIndicator.startAnimating()
            self.searchFromServer();
        }
    }
    
}


// MARK: UITabeViewDelegate UITableViewDataSource
extension ZLSearchItemsViewModel: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsInfo?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch(self.currentSearchType)
        {
        case .repositories:
            return 170
        case .users:
            return 100
        default:
            return 170
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(self.currentSearchType)
        {
        case .repositories:do{
            let tableViewCell: ZLRepositoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLRepositoryTableViewCell", for: indexPath) as! ZLRepositoryTableViewCell
            guard let itemInfo : ZLGithubRepositoryModel = self.itemsInfo![indexPath.row] as? ZLGithubRepositoryModel else
            {
                return tableViewCell;
            }
            tableViewCell.headImageView.sd_setImage(with: URL.init(string: itemInfo.owner.avatar_url), placeholderImage: nil);
            tableViewCell.repostitoryNameLabel.text = itemInfo.name
            tableViewCell.languageLabel.text = itemInfo.language
            tableViewCell.descriptionLabel.text = itemInfo.desc_Repo
            tableViewCell.forkNumLabel.text = "\(itemInfo.forks)"
            tableViewCell.starNumLabel.text = "\(itemInfo.stargazers_count)"
            tableViewCell.ownerNameLabel.text = itemInfo.owner.loginName
            
            return tableViewCell;
        
        }
        case .users:do{
            
            let tableViewCell: ZLUserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLUserTableViewCell", for: indexPath) as! ZLUserTableViewCell
            guard let itemInfo : ZLGithubUserModel = self.itemsInfo![indexPath.row] as? ZLGithubUserModel else
            {
                return tableViewCell;
            }
            
            tableViewCell.headImageView.sd_setImage(with: URL.init(string: itemInfo.avatar_url), placeholderImage: nil);
            tableViewCell.nameLabel.text = itemInfo.name
            tableViewCell.loginNameLabel.text = itemInfo.loginName
            tableViewCell.companyLabel.text = itemInfo.company
            tableViewCell.locationLabel.text = itemInfo.location
            
            return tableViewCell
        }
         
        default:do{
            
              let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLUserTableViewCell", for: indexPath)
              return tableViewCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch(self.currentSearchType)
        {
        case .repositories:do{
            let item : ZLGithubRepositoryModel = self.itemsInfo![indexPath.row] as! ZLGithubRepositoryModel
            let vc = ZLRepoInfoController.init(repoInfoModel: item)
            self.viewController?.navigationController?.pushViewController(vc, animated: false)
            
            break;
            }
        case .users:do{
            
            let item : ZLGithubUserModel = self.itemsInfo![indexPath.row] as! ZLGithubUserModel
            let vc = ZLUserInfoController.init(userInfoModel: item)
            self.viewController?.navigationController?.pushViewController(vc, animated: false)
            
            }
            
        default:do{
            break
            }
        }
       
    }
}

extension ZLSearchItemsViewModel: UICollectionViewDelegate,UICollectionViewDataSource
{
  //  static let searchTypes:[ZLSearchType] = [.repositories,.users,.commits,.issues,.code,.topics]
    static let searchTypes:[ZLSearchType] = [.repositories,.users]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ZLSearchItemsViewModel.searchTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentSearchType = ZLSearchItemsViewModel.searchTypes[indexPath.row]
        self.searchItemsView?.searchTypeCollectionView.reloadData()
        
        self.currentPage = 0;
        self.itemsInfo = nil
        self.refreshManager?.setFooterViewRefreshEnd() // 设置refresh为init状态
        self.searchItemsView?.tableView.reloadData()
        
        if self.keyWord != ""
        {
            self.searchItemsView?.indicatorBackView.isHidden = false
            self.searchItemsView?.activityIndicator.startAnimating()
            self.searchFromServer()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let collectionCell: ZLSearchTypeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZLSearchTypeCollectionViewCell", for: indexPath) as! ZLSearchTypeCollectionViewCell
        
        let searchType = ZLSearchItemsViewModel.searchTypes[indexPath.row]
        switch(searchType)
        {
        case .repositories:do{
            collectionCell.label.text = ZLLocalizedString(string: "repositories", comment: "仓库")
            }
        case .users:do{
            collectionCell.label.text = ZLLocalizedString(string: "users", comment: "用户")
            }
        case .commits:do{
            collectionCell.label.text = ZLLocalizedString(string: "commits", comment: "提交")
            }
        case .issues:do{
            collectionCell.label.text = ZLLocalizedString(string: "issues", comment: "问题")
            }
        case .code:do{
            collectionCell.label.text = ZLLocalizedString(string: "code", comment: "代码")
            }
        case .topics:do{
            collectionCell.label.text = ZLLocalizedString(string: "topics", comment: "标题")
            }
        }
        
        if indexPath.row == self.currentSearchType.rawValue
        {
            collectionCell.isSelected = true
        }
        else
        {
            collectionCell.isSelected = false
        }
        
        return collectionCell
    }
    

}


//MARK : ZLRefreshManagerDelegate
extension ZLSearchItemsViewModel: ZMRefreshManagerDelegate
{
    func zmRefreshIsDragUp(_ isDragUp: Bool, refreshView: UIView!) {
        
        if self.currentPage == 0 || self.keyWord == ""
        {
            ZLLog_Info("current page = 0 or keyword is nil,return")
            self.refreshManager?.setFooterViewRefreshEnd()
            return
        }
        
        self.searchFromServer()
    }
}


extension ZLSearchItemsViewModel
{
    func searchFromServer()
    {
        ZLSearchServiceModel.shared().searchInfo(withKeyWord: self.keyWord, type: self.currentSearchType, filterInfo: self.searchFilterInfo, page: UInt(self.currentPage + 1), per_page: UInt(ZLSearchItemsViewModel.per_page), serialNumber: "123")
    }
    
    
    @objc func onNotificationArrived(notification:Notification)
    {
        switch notification.name {
        case ZLSearchResult_Notification:do{
            
            guard let notiPara: ZLOperationResultModel  = notification.params as? ZLOperationResultModel else
            {
                self.searchItemsView?.indicatorBackView.isHidden = true
                self.searchItemsView?.activityIndicator.stopAnimating()
                self.refreshManager?.setFooterViewRefreshEnd()
                return
            }
            
            // refreshManager为空时，创建
            if self.refreshManager == nil
            {
                self.refreshManager = ZMRefreshManager.init(scrollView: self.searchItemsView!.tableView, addHeaderView: false, addFooterView: true);
                self.refreshManager?.delegate = self
            }
            
            if notiPara.result == true
            {
                guard let searchResult: ZLSearchResultModel = notiPara.data as? ZLSearchResultModel else
                {
                    self.refreshManager?.setFooterViewRefreshEnd()
                    ZLLog_Warn("searchResult is not ZLSearchResultModel,return")
                    return
                }
                
                if searchResult.data.count > 0
                {
                    self.currentPage = self.currentPage + 1
                    
                    self.searchItemsView?.indicatorBackView.isHidden = true
                    self.searchItemsView?.activityIndicator.stopAnimating()
                    self.refreshManager?.setFooterViewRefreshEnd()
                }
                else
                {
                    self.searchItemsView?.indicatorBackView.isHidden = true
                    self.searchItemsView?.activityIndicator.stopAnimating()
                    self.refreshManager?.setFooterViewNoMoreFresh()
                    return;
                }
                
                if self.itemsInfo == nil
                {
                    self.itemsInfo = (searchResult.data as NSArray).mutableCopy() as? [Any]
                }
                else
                {
                    self.itemsInfo?.append(contentsOf: searchResult.data)
                }
                self.searchItemsView?.tableView.reloadData()
            }
            else
            {
                self.refreshManager?.setFooterViewRefreshEnd()
                guard let errorModel : ZLGithubRequestErrorModel = notiPara.data as? ZLGithubRequestErrorModel else
                {
                    return;
                }
                
                ZLLog_Warn("search failed statusCode[\(errorModel.statusCode)] message[\(errorModel.message)]")
            }
        }
        default:
            break;
        }
    }
}
