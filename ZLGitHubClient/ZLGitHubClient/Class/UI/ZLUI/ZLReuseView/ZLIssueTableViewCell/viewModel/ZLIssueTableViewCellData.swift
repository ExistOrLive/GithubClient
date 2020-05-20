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
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let cell : ZLIssueTableViewCell = targetView as? ZLIssueTableViewCell else{
            return
        }
        cell.fillWithData(cellData: self)
    }
    
}


extension ZLIssueTableViewCellData{
    
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
    
    func getLabels() -> [String] {
        
        var labelArray : [String] = []
        
        for label in self.issueModel.labels {
            labelArray.append(label.name)
        }
        
        return labelArray
    }
    
    
}
