//
//  ZLExploreBaseViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/3.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import JXSegmentedView
import ZLUIUtilities
import ZLGitRemoteService
import ZMMVVM

class ZLExploreBaseViewModel: ZMBaseViewModel {
    
    // subvc
    lazy var childVC: [ZLExploreChildListController] = {
        var array = [ZLExploreChildListController]()
        for type in ZLExploreChildListType.allCases {
            array.append(ZLExploreChildListController(type: type, superVC: zm_viewController))
        }
        return array
    }()

    deinit {
        NotificationCenter.default.removeObserver(self, name: ZLLanguageTypeChange_Notificaiton, object: nil)
    }
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notication:)), name: ZLLanguageTypeChange_Notificaiton, object: nil)
    }

    @objc func onNotificationArrived(notication: Notification) {
        ZLLog_Info("notificaition[\(notication) arrived]")

        switch notication.name {
        case ZLLanguageTypeChange_Notificaiton:do {
            self.zm_reloadView()
            }
        default:
            break
        }

    }
}


extension ZLExploreBaseViewModel: ZLExploreBaseViewDelegate {
    
    func onSegmentViewSelectedIndex(segmentView: JXSegmentedView, index: Int) {
        // to do
    }
    
    
    func segmentedListContainerViewListDelegate() -> [JXSegmentedListContainerViewListDelegate] {
        childVC
    }
    
    func exploreTypeTitles() -> [String] {
        return [ZLLocalizedString(string: "repositories", comment: ""),
                ZLLocalizedString(string: "users", comment: "")]
    }

    func onSearchButtonClicked() {
        if let vc = ZLUIRouter.getVC(key: .SearchController) {
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
