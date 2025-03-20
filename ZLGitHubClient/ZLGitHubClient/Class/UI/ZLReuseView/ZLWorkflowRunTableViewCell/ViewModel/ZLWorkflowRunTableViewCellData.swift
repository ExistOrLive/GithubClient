//
//  ZLWorkflowRunTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/11.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLBaseExtension
import ZLGitRemoteService
import ZMMVVM

class ZLWorkflowRunTableViewCellData: ZMBaseTableViewCellViewModel {

    // 
    var data: ZLGithubRepoWorkflowRunModel
    var workFlowTitle: String = ""
    var repoFullName: String = ""

    // model
    var branchStr: NSAttributedString?

    init(data: ZLGithubRepoWorkflowRunModel) {
        self.data = data
        super.init()
    }


    override var zm_cellReuseIdentifier: String {
        return "ZLWorkflowRunTableViewCell"
    }


    override func zm_onCellSingleTap() {
        if let url = URL.init(string: self.data.html_url ?? "") {
            ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,
                                  params: ["requestURL": url])
        }
    }

}

extension ZLWorkflowRunTableViewCellData: ZLWorkflowRunTableViewCellDelegate {
    func onMoreButtonClicked(button: UIButton) {

//        let vProperty = FWMenuViewProperty()
//        vProperty.popupCustomAlignment = .topCenter
//        vProperty.popupAnimationType = .scale
//        vProperty.popupArrowStyle = .round
//        vProperty.touchWildToHide = "1"
//        vProperty.topBottomMargin = 0
//        vProperty.maskViewColor = UIColor(white: 0, alpha: 0.3)
//
//        if self.data.status == "completed" {
//            let menuView = FWMenuView.menu(itemTitles: ["rerun","view log"], itemImageNames:nil, itemBlock: { (popupView, index, title) in
//
//                if index == 0 {
//                    ZLProgressHUD.show()
//                    ZLServiceManager.sharedInstance.repoServiceModel?.rerunRepoWorkflowRun(withFullName: self.repoFullName, workflowRunId: self.data.id_workflowrun ?? "", serialNumber: NSString.generateSerialNumber()) { (result : ZLOperationResultModel) in
//                        ZLProgressHUD.dismiss()
//                        if result.result == true {
//                            ZLToastView.showMessage("rerun success,please refresh")
//                        } else {
//                            ZLToastView.showMessage("rerun fail")
//                        }
//                    }
//                } else if index == 1 {
//
//                }
//
//            }, property: vProperty)
//            menuView.attachedView = button
//            menuView.show()
//        } else if self.data.status == "in_progress" {
//            let menuView = FWMenuView.menu(itemTitles: ["cancel","view log"], itemImageNames:nil, itemBlock: { (popupView, index, title) in
//
//                if index == 0 {
//                    ZLProgressHUD.show()
//                    ZLServiceManager.sharedInstance.repoServiceModel?.cancelRepoWorkflowRun(withFullName: self.repoFullName, workflowRunId: self.data.id_workflowrun ?? "", serialNumber: NSString.generateSerialNumber()) { (result : ZLOperationResultModel) in
//                        ZLProgressHUD.dismiss()
//                        if result.result == true {
//                            ZLToastView.showMessage("cancel success,please refresh")
//                        } else {
//                            ZLToastView.showMessage("cancel fail")
//                        }
//                    }
//                } else if index == 1 {
//
//                }
//            }, property: vProperty)
//            menuView.attachedView = button
//            menuView.show()
//        }

    }
}

extension ZLWorkflowRunTableViewCellData {
    func getWorkflowRunTitle() -> String {
        self.data.head_commit?.message ?? ""
    }

    func getTimeStr() -> String {
        if let date = self.data.created_at {
            return (date as NSDate).dateLocalStrSinceCurrentTime()
        } else if let date = self.data.updated_at {
            return (date as NSDate).dateLocalStrSinceCurrentTime()
        }
        return ""
    }

    func getWorkflowRunDesc() -> String {
        return "\(self.workFlowTitle) #\(self.data.run_number)"
    }

    func getBranchStr() -> NSAttributedString {
        let str = NSMutableAttributedString.init(string: "\(self.data.head_repository?.full_name ?? "" ):\(self.data.head_branch ?? "")", attributes: [NSAttributedString.Key.foregroundColor: ZLRawColor(name: "ZLLinkLabelColor1") ?? UIColor.blue, NSAttributedString.Key.font: UIFont.init(name: Font_PingFangSCRegular, size: 13) ?? UIFont.systemFont(ofSize: 12)])
        str.yy_setTextHighlight(NSRange.init(location: 0, length: str.length), color: ZLRawColor(name: "ZLLinkLabelColor1") ?? UIColor.blue, backgroundColor: UIColor.clear) {[weak weakSelf = self](_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

            if let repoFullName = weakSelf?.data.head_repository?.full_name, let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                vc.hidesBottomBarWhenPushed = true
                weakSelf?.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return str
    }

    func getConclusion() -> String {
        return self.data.conclusion ?? "success"
    }

    func getStatus() -> String {
        return self.data.status ?? "completed"
    }
}
