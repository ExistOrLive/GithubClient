//
//  ZLProfileContributionsCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/10/7.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import ZLUIUtilities
import ZLGitRemoteService
import ZMMVVM

class ZLProfileContributionsCellData: ZMBaseTableViewCellViewModel {
    
    private var data: ZLGithubUserModel
    
    init(userModel: ZLGithubUserModel) {
        self.data = userModel
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLProfileContributionsCell"
    }
}

extension ZLProfileContributionsCellData: ZLProfileContributionsCellDataSourceAndDelegate {
    var loginName: String {
        data.loginName ?? ""
    }
    
    func onAllUpdateButtonClicked() {
        let vc = ZLMyEventController()
        vc.hidesBottomBarWhenPushed = true
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

