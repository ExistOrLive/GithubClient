//
//  ZLEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by ZM on 2019/11/26.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLBaseExtension
import ZLGitRemoteService
import ZLUtilities
import ZMMVVM

class ZLEventTableViewCellData: ZMBaseTableViewCellViewModel {

    let eventModel: ZLGithubEventModel

    init(eventModel: ZLGithubEventModel) {
        self.eventModel = eventModel
        super.init()
    }


    override var zm_cellReuseIdentifier: String {
        return "ZLEventTableViewCell"
    }


    override  func zm_onCellSingleTap() {
        if let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: self.eventModel.repo.name) {
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

// MARK: cellData
extension ZLEventTableViewCellData {
    func getActorAvaterURL() -> String {
        return self.eventModel.actor.avatar_url
    }

    func getActorName() -> String {
        return self.eventModel.actor.login
    }

    func getTimeStr() -> String {
        let timeStr = NSString.init(format: "%@", (self.eventModel.created_at as NSDate?)?.dateLocalStrSinceCurrentTime() ?? "")
        return timeStr as String
    }

    @objc func getEventDescrption() -> NSAttributedString {
        return NSAttributedString.init(string: self.eventModel.eventDescription ,
                                       attributes: [.foregroundColor: ZLRawLabelColor(name: "ZLLabelColor3"),
                                                    .font: UIFont.zlRegularFont(withSize: 15)])
    }
}

extension ZLEventTableViewCellData {
    func onAvatarClicked() {
        if let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName: self.eventModel.actor.login) {
            userInfoVC.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
        }
    }

    func onReportClicked() {
        let vc = ZLReportController.init()
        vc.loginName = self.eventModel.actor.login
        vc.hidesBottomBarWhenPushed = true
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    var showReportButton: Bool {
#if DEBUG
        return true
#else
        var showReportButton = ZLAGC().configAsBool(for: "Report_Function_Enabled")
        let currentLoginName = ZLServiceManager.sharedInstance.viewerServiceModel?.currentUserLoginName
        if  currentLoginName == "ExistOrLive1" ||
                currentLoginName == "existorlive3" ||
                currentLoginName == "existorlive11" {
            showReportButton = true
        }
        if currentLoginName == self.eventModel.actor.login {
            showReportButton = false
        }
        return showReportButton
#endif
    }

}
