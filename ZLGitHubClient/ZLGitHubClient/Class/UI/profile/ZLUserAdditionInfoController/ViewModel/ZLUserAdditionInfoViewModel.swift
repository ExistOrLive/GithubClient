//
//  ZLUserAdditionInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLUserAdditionInfoViewModel: ZLBaseViewModel {
    
    static let per_page: UInt = 10                            // 每页多少记录
    
    // model
    var type : ZLUserAdditionInfoType!             // info类型
    var login : String!                            // 用户信息
    var currentPage : Int  =  0                     // 当前页号
    
    // view
    var itemListView: ZLGithubItemListView!

    
    
    deinit {
        // 注销监听
    }

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
       
        //1、 保存baseView 和 model 
        if !(targetView is ZLGithubItemListView)
        {
            ZLLog_Warn("targetView is not ZLUserAdditionInfoView")
            return;
        }
        self.itemListView = targetView as? ZLGithubItemListView;
        self.itemListView.delegate = self
        
        guard  let (type,login) = targetModel as? (ZLUserAdditionInfoType,String) else {
            ZLLog_Warn("targetModel is not valid")
            return;
        }
        self.type = type
        self.login = login
        
        self.itemListView.beginRefresh()
        
        switch type
        {
        case .repositories:do{
            self.viewController?.title = ZLLocalizedString(string: "repositories", comment: "仓库")
            }
        case .gists:do{
            self.viewController?.title = ZLLocalizedString(string: "gists", comment: "代码片段")
            }
        case .followers:do{
            self.viewController?.title = ZLLocalizedString(string: "followers", comment: "粉丝")
            }
        case .following:do{
            self.viewController?.title = ZLLocalizedString(string: "following", comment: "关注")
            }
        case .starredRepos:do
        {
            self.viewController?.title = ZLLocalizedString(string: "stars", comment: "标星")
            }
        @unknown default:do {
            }
        }
        
        
    }
    
    
}




//MARK:

extension ZLUserAdditionInfoViewModel : ZLGithubItemListViewDelegate {
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void{
        ZLServiceManager.sharedInstance.userServiceModel?.getAdditionInfo(forUser: login,
                                                                          infoType: type,
                                                                          page: 1,
                                                                          per_page: ZLUserAdditionInfoViewModel.per_page,
                                                                          serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel) in
            if resultModel.result == true,let itemArray = resultModel.data as? [Any] {
                
                var cellDataArray: [ZLGithubItemTableViewCellData] = []
                
                for item in itemArray {
                    let cellData = ZLGithubItemTableViewCellData.getCellDataWithData(data: item)
                    if cellData != nil {
                        cellDataArray.append(cellData!)
                        self?.addSubViewModel(cellData!)
                    }
                }
                self?.itemListView.resetCellDatas(cellDatas:cellDataArray)
                self?.currentPage = 1
               
            } else if let errorModel = resultModel.data as? ZLGithubRequestErrorModel{
                ZLToastView.showMessage(errorModel.message)
                self?.itemListView.endRefreshWithError()
            } else {
                ZLToastView.showMessage("data format error")
                self?.itemListView.endRefreshWithError()
            }
        }
    }
    
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) -> Void{
        ZLServiceManager.sharedInstance.userServiceModel?.getAdditionInfo(forUser: login,
                                                                          infoType: type,
                                                                          page: UInt(currentPage + 1),
                                                                          per_page: ZLUserAdditionInfoViewModel.per_page,
                                                                          serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel) in
            
            if resultModel.result == true,let itemArray = resultModel.data as? [Any] {
                
                var cellDataArray: [ZLGithubItemTableViewCellData] = []
                
                for item in itemArray {
                    let cellData = ZLGithubItemTableViewCellData.getCellDataWithData(data: item)
                    if cellData != nil {
                        cellDataArray.append(cellData!)
                        self?.addSubViewModel(cellData!)
                    }
                }
                self?.itemListView.appendCellDatas(cellDatas:cellDataArray)
                self?.currentPage = (self?.currentPage ?? 0) + 1
               
            } else if let errorModel = resultModel.data as? ZLGithubRequestErrorModel{
                ZLToastView.showMessage(errorModel.message)
                self?.itemListView.endRefreshWithError()
            } else {
                ZLToastView.showMessage("data format error")
                self?.itemListView.endRefreshWithError()
            }
        }
    }
}
