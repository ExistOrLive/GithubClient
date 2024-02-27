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

class ZLProfileContributionsCellData: ZLTableViewBaseCellData {
    
    private var data: ZLGithubUserModel
    
    init(userModel: ZLGithubUserModel) {
        self.data = userModel
        super.init()
        self.cellReuseIdentifier = "ZLProfileContributionsCell"
    }
}

extension ZLProfileContributionsCellData: ZLProfileContributionsCellDataSourceAndDelegate {
    var loginName: String {
        data.loginName ?? ""
    }
    
    func onAllUpdateButtonClicked() {
        let vc = ZLMyEventController()
        vc.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

