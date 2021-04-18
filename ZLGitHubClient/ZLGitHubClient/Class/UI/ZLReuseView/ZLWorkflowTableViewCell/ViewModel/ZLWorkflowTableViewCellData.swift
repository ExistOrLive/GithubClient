//
//  ZLWorkflowTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLWorkflowTableViewCellData: ZLGithubItemTableViewCellData {
    var data : ZLGithubRepoWorkflowModel
    
    var repoFullName : String = ""
    
    init(data : ZLGithubRepoWorkflowModel) {
        self.data = data
        super.init()
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let tableViewCell : ZLWorkflowTableViewCell = targetView as? ZLWorkflowTableViewCell else {
            return
        }
        tableViewCell.fillWithData(cellData: self)
        tableViewCell.delegate = self
    }
    
    override func getCellReuseIdentifier() -> String {
           return "ZLWorkflowTableViewCell"
    }
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func onCellSingleTap() {
        let workflowRunVc = ZLRepoWorkflowRunsController.init()
        workflowRunVc.fullName = self.repoFullName
        workflowRunVc.workflow_id = self.data.id_workflow ?? ""
        workflowRunVc.workflowTitle = self.data.name ?? ""
        self.viewController?.navigationController?.pushViewController(workflowRunVc, animated: true)
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
        let webVC = ZLWebContentController.init()
        webVC.requestURL = URL.init(string: data.html_url ?? "")
        self.viewController?.navigationController?.pushViewController(webVC, animated: true)
    }
}
