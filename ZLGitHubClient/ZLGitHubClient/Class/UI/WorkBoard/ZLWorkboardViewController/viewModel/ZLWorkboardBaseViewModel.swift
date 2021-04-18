//
//  ZLWorkboardBaseViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/20.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLWorkboardBaseViewModel: ZLBaseViewModel,ZLWorkboardBaseViewDelegate {
    
    //
    weak var baseView : ZLWorkboardBaseView!
    
    // subViewModel
    var fixedRepos : [ZLGithubCollectedRepoModel] = []
    
    var sectionArray :  [ZLWorkboardClassicType]?
    var cellDataDic : [ZLWorkboardClassicType:[ZLWorkboardTableViewCellData]]?
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: ZLLanguageTypeChange_Notificaiton, object: nil)
        ZLServiceManager.sharedInstance.viewerServiceModel?.unRegisterObserver(self, name: ZLGetCurrentUserInfoResult_Notification)
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let view = targetView as? ZLWorkboardBaseView else {
            return
        }
        baseView = view
        baseView.delegate = self
        
 
        
        NotificationCenter.default.addObserver(self, selector: #selector(ZLWorkboardBaseViewModel.onNotificationArrived), name: ZLLanguageTypeChange_Notificaiton, object: nil)
        ZLServiceManager.sharedInstance.viewerServiceModel?.registerObserver(self, selector: #selector(ZLWorkboardBaseViewModel.onNotificationArrived), name: ZLGetCurrentUserInfoResult_Notification)
    }
    
    
    override func vcLifeCycle_viewWillAppear() {
        self.generateSubViewMode()
        self.baseView.resetData(sectionArray: self.sectionArray, cellDataDic: self.cellDataDic)
    }
    
    func generateSubViewMode(){
        
        for subViewModel in self.subViewModels{
            subViewModel.removeFromSuperViewModel()
        }
        
        let sectionArray : [ZLWorkboardClassicType] = [.work,.fixRepo]
        
        
        self.fixedRepos = ZLServiceManager.sharedInstance.viewerServiceModel?.fixedRepos as? [ZLGithubCollectedRepoModel] ?? []
        
  

        var cellDataArray1 =  [ZLWorkboardTableViewCellData]()
        for repo in self.fixedRepos {
            cellDataArray1.append(ZLWorkboardTableViewCellData(title: repo.full_name ?? "", avatarURL: repo.owner_avatarURL ?? "", type: .fixRepo))
        }
        
        let cellDataArray2 = [ZLWorkboardTableViewCellData(type: .issues),
                              ZLWorkboardTableViewCellData(type: .pullRequest),
                              ZLWorkboardTableViewCellData(type: .orgs),
                              ZLWorkboardTableViewCellData(type: .repos),
                              ZLWorkboardTableViewCellData(type: .starRepos),
                              ZLWorkboardTableViewCellData(type: .events)]
        for cellData in cellDataArray1{
            self.addSubViewModel(cellData)
        }
        for cellData in cellDataArray2{
            self.addSubViewModel(cellData)
        }
        let cellDataDic : [ZLWorkboardClassicType:[ZLWorkboardTableViewCellData]] = [.work:cellDataArray2,.fixRepo:cellDataArray1]
        
        self.sectionArray = sectionArray
        self.cellDataDic = cellDataDic
    }
    
    @objc func onNotificationArrived(notification : Notification) {
        if ZLLanguageTypeChange_Notificaiton == notification.name {
            self.viewController?.title = ZLLocalizedString(string: "Workboard", comment: "")
        } else if ZLGetCurrentUserInfoResult_Notification == notification.name {
            self.generateSubViewMode()
            self.baseView.resetData(sectionArray: self.sectionArray, cellDataDic: self.cellDataDic)
        }
    }
    
    func onEditFixedRepoButtonClicked() {
        if let vc = ZLUIRouter.getEditFixedRepoController(){
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
