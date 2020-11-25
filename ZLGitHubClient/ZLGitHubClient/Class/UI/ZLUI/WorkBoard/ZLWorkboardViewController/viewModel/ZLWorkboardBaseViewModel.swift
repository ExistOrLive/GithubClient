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
    var sectionArray :  [ZLWorkboardClassicType]?
    var cellDataDic : [ZLWorkboardClassicType:[ZLWorkboardTableViewCellData]]?
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: ZLLanguageTypeChange_Notificaiton, object: nil)
    }
    
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let view = targetView as? ZLWorkboardBaseView else {
            return
        }
        baseView = view
        baseView.delegate = self
        
        self.generateSubViewMode()
        self.baseView.resetData(sectionArray: self.sectionArray, cellDataDic: self.cellDataDic)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ZLWorkboardBaseViewModel.onNotificationArrived), name: ZLLanguageTypeChange_Notificaiton, object: nil)
        
    }
    
    
    func generateSubViewMode(){
        let sectionArray : [ZLWorkboardClassicType] = [.work,.fixRepo]
        let cellDataArray1 = [ZLWorkboardTableViewCellData(type: .issues),
                              ZLWorkboardTableViewCellData(type: .pullRequest),
                              ZLWorkboardTableViewCellData(type: .orgs),
                              ZLWorkboardTableViewCellData(type: .repos),
                              ZLWorkboardTableViewCellData(type: .starRepos),
                              ZLWorkboardTableViewCellData(type: .events)]
        for cellData in cellDataArray1{
            self.addSubViewModel(cellData)
        }
        let cellDataDic : [ZLWorkboardClassicType:[ZLWorkboardTableViewCellData]] = [.work:cellDataArray1,.fixRepo:[]]
        
        self.sectionArray = sectionArray
        self.cellDataDic = cellDataDic
    }
    
    @objc func onNotificationArrived(notification : Notification) {
        if ZLLanguageTypeChange_Notificaiton == notification.name {
            self.viewController?.title = ZLLocalizedString(string: "Workboard", comment: "")
        }
    }
    
    func onEditFixedRepoButtonClicked() {
        if let vc = SYDCentralPivotUIAdapter.getEditFixedRepoController(){
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
