//
//  ZLWorkflowTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZMMVVM

class ZLWorkflowTableViewCellData: ZMBaseTableViewCellViewModel {
    var data: ZLGithubRepoWorkflowModel

    var repoFullName: String = ""

    init(data: ZLGithubRepoWorkflowModel) {
        self.data = data
        super.init()
    }


    override var zm_cellReuseIdentifier: String {
           return "ZLWorkflowTableViewCell"
    }


    override func zm_onCellSingleTap() {
        let workflowRunVc = ZLRepoWorkflowRunsController.init()
        workflowRunVc.fullName = self.repoFullName
        workflowRunVc.workflow_id = self.data.id_workflow ?? ""
        workflowRunVc.workflowTitle = self.data.name ?? ""
        zm_viewController?.navigationController?.pushViewController(workflowRunVc, animated: true)
    }
}

extension ZLWorkflowTableViewCellData {
    func getWorkflowTitle() -> String {
        return data.name ?? ""
    }

    func getWorkflowState() -> String {
        return data.state
    }
}

extension ZLWorkflowTableViewCellData: ZLWorkflowTableViewCellDelegate {
    func onConfigButtonClicked() {
        if let url = URL.init(string: self.data.html_url ?? "") {
            ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,
                                  params: ["requestURL": url])
        }
    }
}
