//
//  ZLWorkflowRunTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/11.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import FWPopupView

class ZLWorkflowRunTableViewCellData: ZLGithubItemTableViewCellData {
    
    // 
    var data : ZLGithubRepoWorkflowRunModel
    var workFlowTitle : String = ""
    var repoFullName : String = ""
    
    // model
    var branchStr : NSAttributedString?
    
    init(data : ZLGithubRepoWorkflowRunModel) {
        self.data = data
        super.init()
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let cell : ZLWorkflowRunTableViewCell = targetView as? ZLWorkflowRunTableViewCell else {
            return
        }
        cell.delegate = self
        cell.fillWithData(data: self)
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLWorkflowRunTableViewCell"
    }
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func onCellSingleTap() {
        let webVc = ZLWebContentController.init()
        webVc.requestURL = URL.init(string: self.data.html_url ?? "")
        webVc.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(webVc, animated: true)
    }
    
}

extension ZLWorkflowRunTableViewCellData : ZLWorkflowRunTableViewCellDelegate {
    func onMoreButtonClicked(button:UIButton) -> Void{
        
        let vProperty = FWMenuViewProperty()
        vProperty.popupCustomAlignment = .topCenter
        vProperty.popupAnimationType = .scale
        vProperty.popupArrowStyle = .round
        vProperty.touchWildToHide = "1"
        vProperty.topBottomMargin = 0
        vProperty.maskViewColor = UIColor(white: 0, alpha: 0.3)
        
        if self.data.status == "completed" {
            let menuView = FWMenuView.menu(itemTitles: ["rerun","view log"], itemImageNames:nil, itemBlock: { (popupView, index, title) in
                
                if index == 0 {
                    SVProgressHUD.show()
                    ZLRepoServiceModel.shared().rerunRepoWorkflowRun(withFullName: self.repoFullName, workflowRunId: self.data.id_workflowrun ?? "", serialNumber: NSString.generateSerialNumber()) { (result : ZLOperationResultModel) in
                        SVProgressHUD.dismiss()
                        if result.result == true {
                            ZLToastView.showMessage("rerun success,please refresh")
                        } else {
                            ZLToastView.showMessage("rerun fail")
                        }
                    }
                } else if index == 1 {
                    
                }
                
            }, property: vProperty)
            menuView.attachedView = button
            menuView.show()
        } else if self.data.status == "in_progress" {
            let menuView = FWMenuView.menu(itemTitles: ["cancel","view log"], itemImageNames:nil, itemBlock: { (popupView, index, title) in
                
                if index == 0 {
                    SVProgressHUD.show()
                    ZLRepoServiceModel.shared().cancelRepoWorkflowRun(withFullName: self.repoFullName, workflowRunId: self.data.id_workflowrun ?? "", serialNumber: NSString.generateSerialNumber()) { (result : ZLOperationResultModel) in
                        SVProgressHUD.dismiss()
                        if result.result == true {
                            ZLToastView.showMessage("cancel success,please refresh")
                        } else {
                            ZLToastView.showMessage("cancel fail")
                        }
                    }
                } else if index == 1 {
                    
                }
            }, property: vProperty)
            menuView.attachedView = button
            menuView.show()
        }
        
    }
}


extension ZLWorkflowRunTableViewCellData {
    func getWorkflowRunTitle() -> String {
        self.data.head_commit?.message ?? ""
    }
    
    func getTimeStr() -> String {
        if self.data.created_at != nil {
            return (self.data.created_at! as NSDate).dateLocalStrSinceCurrentTime()
        } else if self.data.updated_at != nil {
            return (self.data.updated_at! as NSDate).dateLocalStrSinceCurrentTime()
        }
        return ""
    }
    
    func getWorkflowRunDesc() -> NSAttributedString {
        let str = NSAttributedString.init(string: "\(self.workFlowTitle) #\(self.data.run_number)", attributes: [NSAttributedString.Key.foregroundColor: ZLRawColor(name: "ZLLabelColor4") ?? UIColor.lightGray,NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 14) ?? UIFont.systemFont(ofSize: 14)])
        return str
    }
    
    func getBranchStr() -> NSAttributedString {
        let str = NSMutableAttributedString.init(string: "\(self.data.head_repository?.full_name ?? "" ):\(self.data.head_branch ?? "")", attributes: [NSAttributedString.Key.foregroundColor:ZLRawColor(name: "ZLLinkLabelColor1") ?? UIColor.blue,NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 13) ?? UIFont.systemFont(ofSize: 12)])
        str.yy_setTextHighlight(NSRange.init(location: 0, length: str.length), color: ZLRawColor(name: "ZLLinkLabelColor1") ?? UIColor.blue, backgroundColor: UIColor.clear) {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
             
            let vc = ZLRepoInfoController.init(repoFullName: self.data.head_repository?.full_name ?? "")
             vc.hidesBottomBarWhenPushed = true
             self.viewController?.navigationController?.pushViewController(vc, animated: true)
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
