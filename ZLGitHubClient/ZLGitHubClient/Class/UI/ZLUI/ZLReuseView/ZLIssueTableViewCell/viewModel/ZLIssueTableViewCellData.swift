//
//  ZLIssueTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/14.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLIssueTableViewCellData: ZLGithubItemTableViewCellData {

    let issueModel : ZLGithubIssueModel
    
    init(issueModel : ZLGithubIssueModel){
        self.issueModel = issueModel
        super.init()
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLIssueTableViewCell";
    }
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func onCellSingleTap() {
        // https://github.com/MengAndJie/GithubClient/issues/22
        if let url = URL(string: issueModel.html_url) {
            if url.pathComponents.count >= 5 && url.pathComponents[3] == "issues" {
                ZLUIRouter.navigateVC(key: ZLUIRouter.IssueInfoController,
                                      params: ["login":url.pathComponents[1],
                                               "repoName":url.pathComponents[2],
                                               "number":Int(url.pathComponents[4]) ?? 0])
            } else if url.pathComponents.count >= 5 && url.pathComponents[3] == "pull" {
                ZLUIRouter.navigateVC(key: ZLUIRouter.PRInfoController,
                                      params: ["login":url.pathComponents[1],
                                               "repoName":url.pathComponents[2],
                                               "number":Int(url.pathComponents[4]) ?? 0])
            } else {
                let vc = ZLWebContentController.init()
                vc.requestURL = url
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let cell : ZLIssueTableViewCell = targetView as? ZLIssueTableViewCell else{
            return
        }
        cell.fillWithData(cellData: self)
    }
    
}


extension ZLIssueTableViewCellData : ZLIssueTableViewCellDelegate{
    
    func getIssueTitleStr() -> String?{
        return self.issueModel.title
    }
    
    func isIssueClosed() -> Bool{
        return self.issueModel.state == "closed"
    }
    
    func getAssistStr() -> String?{
        
        if self.isIssueClosed() {
            
            return "#\(self.issueModel.number) \(self.issueModel.close_by.loginName) \(ZLLocalizedString(string: "closed at", comment: "")) \((self.issueModel.closed_at! as NSDate).dateLocalStrSinceCurrentTime())"
            
        } else {
            
             return "#\(self.issueModel.number) \(self.issueModel.user.loginName)  \(ZLLocalizedString(string: "opened at", comment: "")) \((self.issueModel.created_at! as NSDate).dateLocalStrSinceCurrentTime())"
        }
    }
    
    func getLabels() -> [(String,String)] {
        
        var labelArray : [(String,String)] = []
        
        for label in self.issueModel.labels {
            labelArray.append((label.name,label.color))
        }
        
        return labelArray
    }
}
