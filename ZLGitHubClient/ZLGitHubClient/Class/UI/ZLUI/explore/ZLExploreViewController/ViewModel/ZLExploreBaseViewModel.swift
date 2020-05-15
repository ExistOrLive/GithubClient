//
//  ZLExploreBaseViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/3.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLExploreBaseViewModel: ZLBaseViewModel {
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notication:)), name: ZLLanguageTypeChange_Notificaiton, object: nil)
        
        self.getTrendRepo()
    }
    

    @IBAction func onSearchButtonClicked(_ sender: Any) {
       let vc = ZLSearchController()
       vc.hidesBottomBarWhenPushed = true
       self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    

    @objc func onNotificationArrived(notication: Notification)
    {
        ZLLog_Info("notificaition[\(notication) arrived]")
        
        switch notication.name
        {
        case ZLLanguageTypeChange_Notificaiton:do
        {
            self.baseView?.justReloadView()
            }
        default:
            break;
        }
        
    }
}

extension ZLExploreBaseViewModel{
    func getTrendRepo() -> Void {
        weak var weakSelf = self
        
        ZLSearchServiceModel.shared().trending(with:.repositories, language: nil, dateRange: ZLDateRangeDaily, serialNumber: NSString.generateSerialNumber(), completeHandle: { (model:ZLOperationResultModel) in
            
            if model.result == true {
                guard let repoArray : [ZLGithubRepositoryModel] = model.data as?  [ZLGithubRepositoryModel] else {
                    ZLLocalizedString(string: "ZLGithubRepositoryModel transfer failed", comment: "")
                    
                    return
                }
                
                var repoCellDatas : [ZLRepositoryTableViewCellData] = []
                for item in repoArray {
                    let cellData = ZLRepositoryTableViewCellData.init(data: item, needPullData: true)
                    self.addSubViewModel(cellData)
                    repoCellDatas.append(cellData)
                }
                
                weakSelf?.baseView?.listView.resetCellDatas(cellDatas: repoCellDatas)
                
            } else {
                
                ZLLocalizedString(string: "ZLGithubRepositoryModel transfer failed", comment: "")
            }
            
        })
    }
}
