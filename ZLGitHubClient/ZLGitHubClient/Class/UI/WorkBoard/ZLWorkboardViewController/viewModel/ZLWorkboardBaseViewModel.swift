//
//  ZLWorkboardBaseViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/20.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZMMVVM

class ZLWorkboardBaseViewModel: ZMBaseViewModel {


    // subViewModel
    var sectionDataArray: [ZMBaseTableViewSectionData] = []
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: ZLLanguageTypeChange_Notificaiton, object: nil)
        ZLServiceManager.sharedInstance.viewerServiceModel?.unRegisterObserver(self, name: ZLGetCurrentUserInfoResult_Notification)
    }

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(ZLWorkboardBaseViewModel.onNotificationArrived), name: ZLLanguageTypeChange_Notificaiton, object: nil)
        ZLServiceManager.sharedInstance.viewerServiceModel?.registerObserver(self, selector: #selector(ZLWorkboardBaseViewModel.onNotificationArrived), name: ZLGetCurrentUserInfoResult_Notification)
    }
    
    override func zm_viewWillAppear() {
        super.zm_viewWillAppear()
        self.generateSubViewMode()
        self.zm_reloadView()
    }

    func generateSubViewMode() {

        sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
        sectionDataArray.removeAll()
        
         /// 工作项
        let workSection = ZMBaseTableViewSectionData(zm_sectionID: ZLWorkboardClassicType.work)
        workSection.headerData = ZLWorkboardTableViewSectionHeaderData(classicType: .work)
        workSection.cellDatas = [ZLWorkboardTableViewCellData(type: .issues),
                                 ZLWorkboardTableViewCellData(type: .pullRequest),
                                 ZLWorkboardTableViewCellData(type: .orgs),
                                 ZLWorkboardTableViewCellData(type: .repos),
                                 ZLWorkboardTableViewCellData(type: .starRepos),
                                 ZLWorkboardTableViewCellData(type: .events),
                                 ZLWorkboardTableViewCellData(type: .discussions)]
        sectionDataArray.append(workSection)
        
        /// 收藏仓库
        let fixRepoSection = ZMBaseTableViewSectionData(zm_sectionID: ZLWorkboardClassicType.fixRepo)
        fixRepoSection.headerData = ZLWorkboardTableViewSectionHeaderData(classicType: .fixRepo)
        let fixedRepos = ZLServiceManager.sharedInstance.viewerServiceModel?.fixedRepos as? [ZLGithubCollectedRepoModel] ?? []
        fixRepoSection.cellDatas = fixedRepos.map({
            ZLWorkboardTableViewCellData(title: $0.full_name ?? "",
                                         avatarURL: $0.owner_avatarURL ?? "",
                                         type: .fixRepo(repo: $0.full_name ?? ""))
        })
        if fixedRepos.isEmpty {
            fixRepoSection.footerData = ZLWorkboardFixedRepoPlaceHolderViewData()
        }
        sectionDataArray.append(fixRepoSection)
        
        sectionDataArray.forEach({ $0.zm_addSuperViewModel(self)})
    }

    @objc func onNotificationArrived(notification: Notification) {
        if ZLLanguageTypeChange_Notificaiton == notification.name {
            zm_viewController?.title = ZLLocalizedString(string: "Workboard", comment: "")
        } else if ZLGetCurrentUserInfoResult_Notification == notification.name {
            self.generateSubViewMode()
            self.zm_reloadView()
        }
    }
}
