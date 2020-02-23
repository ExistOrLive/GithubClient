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
    
    
    static let per_page : Int = 10
    
    //  static let searchTypes:[ZLSearchType] = [.repositories,.users,.commits,.issues,.code,.topics]
    static let searchTypes:[ZLSearchType] = [.repositories,.users]

    // view
    private var searchItemsView : ZLSearchItemsView?
    private var refreshManager: ZMRefreshManager?
    
    // model
    var keyWord : String = ""                                           // 搜索关键字
    var currentSearchType : ZLSearchType = .repositories                // 当前搜索类型
    
    var searchTypeAttachInfos : [ZLSearchType:ZLSearchTypeAttachInfo]?  //
    
    var serialNumber : String?                // 流水号
    
    
    
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
        self.searchItemsView?.delegate = self
        
        self.searchTypeAttachInfos = [ZLSearchType:ZLSearchTypeAttachInfo]()
        for type in ZLSearchItemsViewModel.searchTypes
        {
            self.searchTypeAttachInfos?.updateValue(ZLSearchTypeAttachInfo(), forKey: type)
        }
        
        self.searchItemsView?.tableView.delegate = self
        self.searchItemsView?.tableView.dataSource = self
        
        self.searchItemsView?.searchTypeCollectionView.delegate = self
        self.searchItemsView?.searchTypeCollectionView.dataSource = self
        
        self.refreshManager = ZMRefreshManager.init(scrollView: self.searchItemsView!.tableView, addHeaderView: false, addFooterView: true);
        self.refreshManager?.delegate = self
        
        // 初始时，没有数据，隐藏tableView，避免滑动refresh
        self.searchItemsView?.tableView.isHidden = true
        
        ZLSearchServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLSearchResult_Notification)
        
    }
    
    
    func startSearch(keyWord:String?)
    {
        // 更换关键字，一切状态重置
        for type in ZLSearchItemsViewModel.searchTypes
        {
            self.searchTypeAttachInfos?.updateValue(ZLSearchTypeAttachInfo(), forKey: type)
        }
        self.refreshManager?.resetFooterViewInit()// 设置refresh为init状态
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
    
    
    override func getEvent(_ event: Any?, fromSubViewModel subViewModel: ZLBaseViewModel) {
        
        guard let eventType : ZLSearchItemsViewEventType = event as? ZLSearchItemsViewEventType else
        {
            return
        }
        
        if(self.keyWord == "")
        {
            // keyword 未空时不记录过滤条件
            return;
        }
        
        switch(eventType)
        {
        case .repoFilterResult:do{
            guard let viewModel : ZLSearchFilterViewModelForRepo = subViewModel as? ZLSearchFilterViewModelForRepo else
            {
                return
            }
            
            let searchAttachInfo = ZLSearchTypeAttachInfo()
            searchAttachInfo.searchFilterInfo = viewModel.searchFilterModel
            
             self.searchTypeAttachInfos?.updateValue(searchAttachInfo, forKey: .repositories)
            }
        case .userFilterResult:do{
            guard let viewModel : ZLSearchFilterViewModelForUser = subViewModel as? ZLSearchFilterViewModelForUser else
            {
                return
            }
            
            let searchAttachInfo = ZLSearchTypeAttachInfo()
            searchAttachInfo.searchFilterInfo = viewModel.searchFilterModel
            
            self.searchTypeAttachInfos?.updateValue(searchAttachInfo, forKey: .users)
            
            }
        }
        
        // 根据过滤条件，重新拉取数据
        
        self.refreshManager?.resetFooterViewInit()// 设置refresh为init状态
        self.searchItemsView?.tableView.reloadData()
        
        self.searchItemsView?.indicatorBackView.isHidden = false
        self.searchItemsView?.activityIndicator.startAnimating()
        self.searchFromServer();
    }
    
}


// MARK: UITabeViewDelegate UITableViewDataSource
extension ZLSearchItemsViewModel: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSearchTypeAttachInfo = self.searchTypeAttachInfos?[self.currentSearchType]
        return currentSearchTypeAttachInfo?.itemsInfo?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch(self.currentSearchType)
        {
        case .repositories:
            return 180
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
            let currentSearchTypeAttachInfo = self.searchTypeAttachInfos?[self.currentSearchType]
        
            guard let itemInfo : ZLGithubRepositoryModel = currentSearchTypeAttachInfo!.itemsInfo![indexPath.row] as? ZLGithubRepositoryModel else
            {
                return tableViewCell;
            }
            tableViewCell.headImageView.sd_setImage(with: URL.init(string: itemInfo.owner.avatar_url), placeholderImage: UIImage.init(named: "default_avatar"));
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
              let currentSearchTypeAttachInfo = self.searchTypeAttachInfos?[self.currentSearchType]
            guard let itemInfo : ZLGithubUserModel = currentSearchTypeAttachInfo!.itemsInfo![indexPath.row] as? ZLGithubUserModel else
            {
                return tableViewCell;
            }
            
            tableViewCell.headImageView.sd_setImage(with: URL.init(string: itemInfo.avatar_url), placeholderImage: UIImage.init(named: "default_avatar"));
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
            let currentSearchTypeAttachInfo = self.searchTypeAttachInfos?[self.currentSearchType]
            let item : ZLGithubRepositoryModel = currentSearchTypeAttachInfo!.itemsInfo![indexPath.row] as! ZLGithubRepositoryModel
            let vc = ZLRepoInfoController.init(repoInfoModel: item)
            self.viewController?.navigationController?.pushViewController(vc, animated: false)
            
            break;
            }
        case .users:do{
            let currentSearchTypeAttachInfo = self.searchTypeAttachInfos?[self.currentSearchType]
            let item : ZLGithubUserModel = currentSearchTypeAttachInfo!.itemsInfo![indexPath.row] as! ZLGithubUserModel
            let vc = ZLUserInfoController.init(userInfoModel: item)
            self.viewController?.navigationController?.pushViewController(vc, animated: false)
            
            }
            
        default:do{
            break
            }
        }
       
    }
}

// MARK: UICollectionViewDelegate,UICollectionViewDataSource
extension ZLSearchItemsViewModel: UICollectionViewDelegate,UICollectionViewDataSource
{

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ZLSearchItemsViewModel.searchTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let preSearchTypeAttachInfo = self.searchTypeAttachInfos![self.currentSearchType]
        preSearchTypeAttachInfo?.contentOffset = self.searchItemsView?.tableView.contentOffset ?? CGPoint(x: 0, y: 0)
        

        self.currentSearchType = ZLSearchItemsViewModel.searchTypes[indexPath.row]
        self.serialNumber = nil
        self.searchItemsView?.searchTypeCollectionView.reloadData()
        self.searchItemsView?.indicatorBackView.isHidden = true
        self.searchItemsView?.activityIndicator.stopAnimating()
        
        let currentSearchTypeInfo = self.searchTypeAttachInfos![self.currentSearchType]
        self.searchItemsView?.tableView.reloadData()
        
        if currentSearchTypeInfo?.itemsInfo?.count ?? 0 == 0 && currentSearchTypeInfo?.isEnd == false
        {
            self.searchItemsView?.tableView.isHidden = true
        }
        else
        {
            self.searchItemsView?.tableView.isHidden = false
        }
        
        if currentSearchTypeInfo?.isEnd == true
        {
            self.refreshManager?.resetFooterViewNoMoreFresh()
        }
        else
        {
            self.refreshManager?.resetFooterViewInit()
        }
        
        if self.keyWord != "" &&
            currentSearchTypeInfo?.isEnd ?? false == false &&
            currentSearchTypeInfo?.itemsInfo?.count ?? 0 == 0
        {
            self.searchItemsView?.indicatorBackView.isHidden = false
            self.searchItemsView?.activityIndicator.startAnimating()
            self.searchFromServer()
        }
        
        self.searchItemsView?.tableView.setContentOffset(currentSearchTypeInfo!.contentOffset, animated: false)

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


// MARK: ZLRefreshManagerDelegate
extension ZLSearchItemsViewModel: ZMRefreshManagerDelegate
{
    func zmRefreshIsDragUp(_ isDragUp: Bool, refreshView: UIView!) {
        
//        if self.currentPage == 0 || self.keyWord == ""
//        {
//            ZLLog_Info("current page = 0 or keyword is nil,return")
//            self.refreshManager?.setFooterViewRefreshEnd()
//            return
//        }
        
        self.searchFromServer()
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
            
            let viewModel = ZLSearchFilterViewModelForRepo.init()
            guard let view : ZLSearchFilterViewForRepo = Bundle.main.loadNibNamed("ZLSearchFilterViewForRepo", owner: viewModel, options: nil)?.first as? ZLSearchFilterViewForRepo else {
                return
            }
            self.addSubViewModel(viewModel)
         viewModel.bindModel(self.searchTypeAttachInfos?[.repositories]?.searchFilterInfo, andView: view)
            
            ZLPresentContainerView.showPresentContainerView(withContentView: view, withContentInSet: UIEdgeInsets.init(top: 0, left:ZLScreenWidth - ZLSearchFilterViewForRepo.minWidth , bottom: 0, right: 0))
            
            }
        case .users:do{
            
            let viewModel = ZLSearchFilterViewModelForUser.init()
            guard let view : ZLSearchFilterViewForUser = Bundle.main.loadNibNamed("ZLSearchFilterViewForUser", owner: viewModel, options: nil)?.first as? ZLSearchFilterViewForUser else {
                return
            }
            self.addSubViewModel(viewModel)
            viewModel.bindModel(self.searchTypeAttachInfos?[.users]?.searchFilterInfo, andView: view)
            
            ZLPresentContainerView.showPresentContainerView(withContentView: view, withContentInSet: UIEdgeInsets.init(top: 0, left:ZLScreenWidth - ZLSearchFilterViewForRepo.minWidth , bottom: 0, right: 0))
            
            }
        case .commits: break
        case .issues: break
        case .code: break
        case .topics: break
        }
        
    }
}


extension ZLSearchItemsViewModel
{
    func searchFromServer()
    {
        let searchTypeAttachInfo = self.searchTypeAttachInfos?[self.currentSearchType]
        
        if searchTypeAttachInfo != nil
        {
            self.serialNumber = NSString.generateSerialNumber()
            ZLSearchServiceModel.shared().searchInfo(withKeyWord: self.keyWord, type: self.currentSearchType, filterInfo: searchTypeAttachInfo!.searchFilterInfo, page: UInt(searchTypeAttachInfo!.currentPage + 1), per_page: UInt(ZLSearchItemsViewModel.per_page), serialNumber: self.serialNumber!)
        }
        else
        {
            ZLLog_Warn("searchTypeAttachInfo for \(self.currentSearchType) is nil");
        }
    }
    
    
    @objc func onNotificationArrived(notification:Notification)
    {
        switch notification.name {
        case ZLSearchResult_Notification:do{
            
            guard let notiPara: ZLOperationResultModel  = notification.params as? ZLOperationResultModel else
            {
                ZLLog_Warn("notiPara is not ZLOperationResultModel, so return")
                return
            }
            
            if self.serialNumber == nil || self.serialNumber! != notiPara.serialNumber
            {
                ZLLog_Warn("notiPara serialNumber \(notiPara.serialNumber) not match serialNumber \(String(describing: self.serialNumber))")
                return
            }
            
            self.searchItemsView?.indicatorBackView.isHidden = true
            self.searchItemsView?.activityIndicator.stopAnimating()
            
            if notiPara.result == true
            {
                guard let searchResult: ZLSearchResultModel = notiPara.data as? ZLSearchResultModel else
                {
                    self.refreshManager?.setFooterViewRefreshEnd()
                    ZLLog_Warn("searchResult is not ZLSearchResultModel,return")
                    return
                }
                
                let searchTypeAttachInfo = self.searchTypeAttachInfos?[self.currentSearchType]
                
                if searchTypeAttachInfo == nil
                {
                    return
                }
                
                if searchResult.data.count > 0
                {
                    searchTypeAttachInfo!.currentPage = searchTypeAttachInfo!.currentPage + 1
                    self.refreshManager?.setFooterViewRefreshEnd()
                }
                else
                {
                    searchTypeAttachInfo?.isEnd = true
                    self.refreshManager?.setFooterViewNoMoreFresh()
                    //return;
                }
                
                if searchTypeAttachInfo!.itemsInfo == nil
                {
                    searchTypeAttachInfo!.itemsInfo = (searchResult.data as NSArray).mutableCopy() as? [Any]
                }
                else
                {
                    searchTypeAttachInfo!.itemsInfo!.append(contentsOf: searchResult.data)
                }
                
                if searchTypeAttachInfo!.itemsInfo?.count ?? 0 == 0 && searchTypeAttachInfo?.isEnd == false
                {
                    self.searchItemsView?.tableView.isHidden = true
                }
                else
                {
                    self.searchItemsView?.tableView.isHidden = false
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
