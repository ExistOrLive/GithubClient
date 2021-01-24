//
//  ZLExploreBaseViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/3.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import JXSegmentedView

class ZLExploreBaseViewModel: ZLBaseViewModel {
    
    // view
    var baseView : ZLExploreBaseView?
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: ZLLanguageTypeChange_Notificaiton, object: nil)
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if !(targetView is ZLExploreBaseView)
        {
            ZLLog_Warn("targetView is not ZLExploreBaseView,so return")
            return
        }
        self.baseView = targetView as? ZLExploreBaseView
        self.baseView?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notication:)), name: ZLLanguageTypeChange_Notificaiton, object: nil)
        
        for itemListView in self.baseView!.githubItemListViewArray{
            itemListView.beginRefresh()
        }
        
        switch self.baseView!.segmentedView.selectedIndex {
        case 0:do{
            self.baseView!.languageLabel.text = ZLSharedDataManager.sharedInstance().lanaguageForTrendingRepo() ?? "Any"
            let title = self.titleForDateRange(dateRange: ZLSharedDataManager.sharedInstance().dateRangeForTrendingRepo())
            self.baseView!.dateRangeButton.setTitle(ZLLocalizedString(string: title, comment: ""), for: .normal)
            }
        case 1:do{
            self.baseView!.languageLabel.text = ZLSharedDataManager.sharedInstance().lanaguageForTrendingUser() ?? "Any"
            let title = self.titleForDateRange(dateRange: ZLSharedDataManager.sharedInstance().dateRangeForTrendingUser())
            self.baseView!.dateRangeButton.setTitle(ZLLocalizedString(string: title, comment: ""), for: .normal)
            }
        default:break
        }
    }
    
    func titleForDateRange(dateRange : ZLDateRange) -> String {
        var title = ZLLocalizedString(string: "Today", comment: "")
        switch dateRange {
        case ZLDateRangeDaily : title = ZLLocalizedString(string: "Today", comment: "")
            break
        case ZLDateRangeWeakly : title = ZLLocalizedString(string: "This Week", comment: "")
            break
        case ZLDateRangeMonthly : title = ZLLocalizedString(string: "This Month", comment: "")
            break
        default:
            break
        }
        return title
    }
    
    @objc func onNotificationArrived(notication: Notification)
    {
        ZLLog_Info("notificaition[\(notication) arrived]")
        
        switch notication.name
        {
        case ZLLanguageTypeChange_Notificaiton:do{
            self.baseView?.justReloadView()
            
            switch self.baseView!.segmentedView.selectedIndex {
            case 0:do{
                let dateRange =  ZLSharedDataManager.sharedInstance().dateRangeForTrendingRepo()
                self.baseView!.dateRangeButton.setTitle(self.titleForDateRange(dateRange: dateRange), for: .normal)
                }
            case 1:do{
                let dateRange = ZLSharedDataManager.sharedInstance().dateRangeForTrendingUser()
                self.baseView!.dateRangeButton.setTitle(self.titleForDateRange(dateRange: dateRange), for: .normal)
                }
            default:break
            }
            
            }
        default:
            break;
        }
        
    }
}

extension ZLExploreBaseViewModel{
    func getTrendRepo() -> Void {
        weak var weakSelf = self
        
        let dateRange = ZLSharedDataManager.sharedInstance().dateRangeForTrendingRepo()
        let language = ZLSharedDataManager.sharedInstance().lanaguageForTrendingRepo()
        ZLServiceManager.sharedInstance.searchServiceModel?.trending(with:.repositories, language: language, dateRange: dateRange, serialNumber: NSString.generateSerialNumber(), completeHandle: { (model:ZLOperationResultModel) in
    
            if model.result == true {
                guard let repoArray : [ZLGithubRepositoryModel] = model.data as?  [ZLGithubRepositoryModel] else {
                    ZLLog_Info("ZLGithubRepositoryModel transfer failed")
                    weakSelf?.baseView?.githubItemListViewArray[0].endRefreshWithError()
                    return
                }
                
                var repoCellDatas : [ZLRepositoryTableViewCellData] = []
                for item in repoArray {
                    let cellData = ZLRepositoryTableViewCellData.init(data: item, needPullData: true)
                    weakSelf!.addSubViewModel(cellData)
                    repoCellDatas.append(cellData)
                }
                
                weakSelf?.baseView?.githubItemListViewArray[0].resetCellDatas(cellDatas: repoCellDatas)
            } else {
                weakSelf?.baseView?.githubItemListViewArray[0].endRefreshWithError()
                guard let errorModel : ZLGithubRequestErrorModel = model.data as? ZLGithubRequestErrorModel else {
                    return
                }
                ZLToastView.showMessage("Query Trending Repo Failed errorMessage[\(errorModel.message)]")
            }
            
        })
    }
    
    func getTrendUser() -> Void {
        
        weak var weakSelf = self
        let dateRange = ZLSharedDataManager.sharedInstance().dateRangeForTrendingUser()
        let language = ZLSharedDataManager.sharedInstance().lanaguageForTrendingUser()
        ZLServiceManager.sharedInstance.searchServiceModel?.trending(with:.users, language: language, dateRange: dateRange, serialNumber: NSString.generateSerialNumber(), completeHandle: { (model:ZLOperationResultModel) in
            
            if model.result == true {
                guard let userArray : [ZLGithubUserModel] = model.data as?  [ZLGithubUserModel] else {
                    ZLLog_Info("ZLGithubUserModel transfer failed")
                    weakSelf?.baseView?.githubItemListViewArray[1].endRefreshWithError()
                    return
                }
                
                var userCellDatas : [ZLUserTableViewCellData] = []
                for item in userArray {
                    let cellData = ZLUserTableViewCellData.init(userModel: item)
                    weakSelf!.addSubViewModel(cellData)
                    userCellDatas.append(cellData)
                }
                
                weakSelf?.baseView?.githubItemListViewArray[1].resetCellDatas(cellDatas: userCellDatas)
            } else {
                weakSelf?.baseView?.githubItemListViewArray[1].endRefreshWithError()
                guard let errorModel : ZLGithubRequestErrorModel = model.data as? ZLGithubRequestErrorModel else {
                                   return
                               }
                ZLToastView.showMessage("Query Trending user Failed errorMessage[\(errorModel.message)]")
            }
            
        })
        
        
    }
}

extension ZLExploreBaseViewModel : ZLExploreBaseViewDelegate{
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {
        let tag = pullRequestListView.tag
        switch tag {
        case 0:do{
            self.getTrendRepo()
        }
        case 1:do{
            self.getTrendUser()
            }
        default: break
        }
        
    }
    
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        
    }
    
    
    func exploreTypeTitles() -> [String] {
        return [ZLLocalizedString(string: "repositories", comment: ""),ZLLocalizedString(string: "users", comment: "")]
    }
    
    func onSearchButtonClicked() -> Void {
        if let vc = ZLUIRouter.getVC(key: ZLUIRouter.SearchController){
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
      
    func onLanguageButtonClicked() -> Void {
        ZLLanguageSelectView.showLanguageSelectView(resultBlock: { (language : String?) in
           self.baseView!.languageLabel.text = language ?? "Any"
           switch self.baseView!.segmentedView.selectedIndex {
            case 0:do{
                ZLSharedDataManager.sharedInstance().setLanguageForTrendingRepo(language)
                self.baseView?.githubItemListViewArray[0].beginRefresh()
                }
            case 1:do{
                ZLSharedDataManager.sharedInstance().setLanguageForTrendingUser(language)
                self.baseView?.githubItemListViewArray[1].beginRefresh()
                }
            default:break
            }
            
        })
    }
      
    func onDateRangeButtonClicked() -> Void {
        
        switch self.baseView!.segmentedView.selectedIndex {
        case 0:do{
            ZLTrendingDateRangeSelectView.showTrendingDateRangeSelectView(initDateRange: ZLSharedDataManager.sharedInstance().dateRangeForTrendingRepo(), resultBlock: {(dateRange : ZLDateRange) in
                self.baseView?.dateRangeButton.setTitle(self.titleForDateRange(dateRange: dateRange), for: .normal)
                ZLSharedDataManager.sharedInstance().setDateRangeForTrendingRepo(dateRange)
                self.baseView?.githubItemListViewArray[0].beginRefresh()
            })
            }
        case 1:do{
            ZLTrendingDateRangeSelectView.showTrendingDateRangeSelectView(initDateRange: ZLSharedDataManager.sharedInstance().dateRangeForTrendingUser(), resultBlock: {(dateRange : ZLDateRange) in
                self.baseView?.dateRangeButton.setTitle(self.titleForDateRange(dateRange: dateRange), for: .normal)
                ZLSharedDataManager.sharedInstance().setDateRangeForTrendingUser(dateRange)
                self.baseView?.githubItemListViewArray[1].beginRefresh()
            })
            }
        default:break
        }
    }
    
    func onSegmentViewSelectedIndex(segmentView: JXSegmentedView, index : Int) -> Void {
        switch index {
        case 0:do{
            self.baseView!.languageLabel.text = ZLSharedDataManager.sharedInstance().lanaguageForTrendingRepo() ?? "Any"
            let title = self.titleForDateRange(dateRange: ZLSharedDataManager.sharedInstance().dateRangeForTrendingRepo())
            self.baseView!.dateRangeButton.setTitle(ZLLocalizedString(string: title, comment: ""), for: .normal)
            }
        case 1:do{
            self.baseView!.languageLabel.text = ZLSharedDataManager.sharedInstance().lanaguageForTrendingUser() ?? "Any"
            let title = self.titleForDateRange(dateRange: ZLSharedDataManager.sharedInstance().dateRangeForTrendingUser())
            self.baseView!.dateRangeButton.setTitle(ZLLocalizedString(string: title, comment: ""), for: .normal)
            }
        default:break
        }
    }
    
}
