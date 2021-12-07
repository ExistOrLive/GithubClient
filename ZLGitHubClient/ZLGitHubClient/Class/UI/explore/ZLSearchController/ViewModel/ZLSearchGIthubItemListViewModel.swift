//
//  ZLSearchGIthubItemListViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/4.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLSearchGithubItemListViewModel: ZLBaseViewModel {
    
    // model
    var searchType : ZLSearchType = .repositories
    
    var searchFilterInfo : ZLSearchFilterInfoModel?
    
    var searchKey: String?
    
    var currentPage: Int = 1
    
    var serialNumberDic : [String : String] = [:]
    
    
    // view
    var githubItemListView : ZLGithubItemListView?
    
    
    deinit {
        ZLServiceManager.sharedInstance.searchServiceModel?.unRegisterObserver(self, name: ZLSearchResult_Notification)
    }
    
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let githubItemListView : ZLGithubItemListView = targetView as? ZLGithubItemListView  else{
            return
        }
        self.githubItemListView = githubItemListView
        self.githubItemListView?.setTableViewFooter()
        self.githubItemListView?.setTableViewHeader()
        self.githubItemListView?.delegate = self
        
        guard let searchType : ZLSearchType = targetModel as? ZLSearchType else {
            return
        }
        self.searchType = searchType
        
        ZLServiceManager.sharedInstance.searchServiceModel?.registerObserver(self, selector: #selector(ZLSearchGithubItemListViewModel.onNotificationArrived(notification:)), name: ZLSearchResult_Notification)
        
    }
    
    
    func searchWithKeyStr(searchKey : String?) {
        self.searchKey = searchKey
        self.githubItemListView?.clearListView()
        self.githubItemListView?.beginRefresh()
    }
    
    func searchWithFilerInfo(searchFilterInfo: ZLSearchFilterInfoModel) {
        self.searchFilterInfo = searchFilterInfo
        self.githubItemListView?.clearListView()
        self.githubItemListView?.beginRefresh()
    }
    
    func startInput(){
        self.githubItemListView?.resetContentOffset()
    }
    
    
    
}

extension ZLSearchGithubItemListViewModel : ZLGithubItemListViewDelegate {
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {
        let serialNumber = NSString.generateSerialNumber()
        self.serialNumberDic[ZLSearchGithubItemListViewModel.ZLSearchNewDataKey] = serialNumber
        
        if let searchKey = self.searchKey {
            ZLServiceManager.sharedInstance.searchServiceModel?.searchInfo(withKeyWord: searchKey,
                                                                           type: self.searchType,
                                                                           filterInfo: self.searchFilterInfo,
                                                                           page: 1,
                                                                           per_page: UInt(ZLSearchGithubItemListViewModel.per_page),
                                                                           serialNumber: serialNumber)
        } else {
            self.githubItemListView?.resetCellDatas(cellDatas: nil)
        }
    }
    
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        
        let serialNumber = NSString.generateSerialNumber()
        self.serialNumberDic[ZLSearchGithubItemListViewModel.ZLSearchMoreDataKey] = serialNumber
        
        if let searchKey = self.searchKey {
            ZLServiceManager.sharedInstance.searchServiceModel?.searchInfo(withKeyWord: searchKey,
                                                                           type: self.searchType,
                                                                           filterInfo: self.searchFilterInfo,
                                                                           page: UInt(self.currentPage + 1),
                                                                           per_page: UInt(ZLSearchGithubItemListViewModel.per_page),
                                                                           serialNumber: serialNumber)
        } else {
            self.githubItemListView?.resetCellDatas(cellDatas: nil)
        }
        
    }
    
    
}

extension ZLSearchGithubItemListViewModel {
    
    static let ZLSearchMoreDataKey = "ZLSearchMoreDataKey"
    
    static let ZLSearchNewDataKey = "ZLSearchNewDataKey"
    
    static let per_page: UInt = 20                            // 每页多少记录
    
    @objc func onNotificationArrived(notification:Notification){
        
        switch notification.name {
        case ZLSearchResult_Notification:do{
            
            guard let notiPara: ZLOperationResultModel  = notification.params as? ZLOperationResultModel else{
                ZLLog_Warn("notiPara is not ZLOperationResultModel, so return")
                return
            }
            
            if !self.serialNumberDic.values.contains(notiPara.serialNumber)
            {
                ZLLog_Warn("notiPara serialNumber \(notiPara.serialNumber) not match")
                return
            }
            
            if notiPara.result == true
            {
                guard let searchResult: ZLSearchResultModel = notiPara.data as? ZLSearchResultModel else{
                    self.githubItemListView?.endRefreshWithError()
                    ZLLog_Warn("searchResult is not ZLSearchResultModel,return")
                    return
                }
                
                var cellDataArray : [ZLGithubItemTableViewCellData] = []
                for githubItemModel in searchResult.data {
                    if let cellData = ZLGithubItemTableViewCellData.getCellDataWithData(data: githubItemModel) {
                        self.addSubViewModel(cellData)
                        cellDataArray.append(cellData)
                    }
                }
                
                if self.serialNumberDic[ZLSearchGithubItemListViewModel.ZLSearchMoreDataKey] == notiPara.serialNumber {
                    self.serialNumberDic.removeValue(forKey: ZLSearchGithubItemListViewModel.ZLSearchMoreDataKey)
                    self.githubItemListView?.appendCellDatas(cellDatas: cellDataArray)
                    self.currentPage = self.currentPage + 1
                    
                } else if self.serialNumberDic[ZLSearchGithubItemListViewModel.ZLSearchNewDataKey] == notiPara.serialNumber {
                    self.serialNumberDic.removeValue(forKey: ZLSearchGithubItemListViewModel.ZLSearchNewDataKey)
                    self.githubItemListView?.resetCellDatas(cellDatas: cellDataArray)
                    self.currentPage = 1
                } else {
                    self.githubItemListView?.endRefreshWithError()
                }
                
            }
            else
            {
                self.githubItemListView?.endRefreshWithError()
                guard let errorModel : ZLGithubRequestErrorModel = notiPara.data as? ZLGithubRequestErrorModel else{
                    return;
                }
                
                ZLToastView.showMessage("search failed statusCode[\(errorModel.statusCode)] message[\(errorModel.message)]")
                ZLLog_Warn("search failed statusCode[\(errorModel.statusCode)] message[\(errorModel.message)]")
            }
            }
        default:
            break;
        }
        
    }
}
