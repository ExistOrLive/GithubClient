//
//  ZLIssueTableViewCellDataForViewerIssue.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/23.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLIssueTableViewCellDataForViewerIssue: ZLGithubItemTableViewCellData {
    
    let data : ViewerIssuesQuery.Data.Viewer.Issue.Node
    
    private var labels : [String]?
    
    
    init(data :  ViewerIssuesQuery.Data.Viewer.Issue.Node){
        self.data = data
        super.init()
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLIssueTableViewCell";
    }
    
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func onCellSingleTap() {
        let vc = ZLWebContentController.init()
        vc.requestURL = URL.init(string: data.url)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let cell : ZLIssueTableViewCell = targetView as? ZLIssueTableViewCell else{
            return
        }
        cell.fillWithData(cellData: self)
    }
    
    
}

extension ZLIssueTableViewCellDataForViewerIssue : ZLIssueTableViewCellDelegate {
    func getIssueTitleStr() -> String? {
        return data.title
    }
    
    func isIssueClosed() -> Bool {
        return data.state == .closed
    }
    
    func getAssistStr() -> String? {
        if self.isIssueClosed() {
            return "#\(data.number) \(data.author?.login ?? "") \(ZLLocalizedString(string: "closed at", comment: "")) \(NSDate.getLocalStrSinceCurrentTime(withGithubTime: data.createdAt))"
        } else {
            
             return "#\(data.number) \(data.author?.login ?? "")  \(ZLLocalizedString(string: "opened at", comment: "")) \(NSDate.getLocalStrSinceCurrentTime(withGithubTime: data.createdAt))"
        }
    }
    
    func getLabels() -> [String] {
        if self.labels == nil {
            if data.labels?.nodes != nil {
                self.labels = []
                for label in data.labels!.nodes! {
                    self.labels?.append(label?.name ?? "")
                }
            }
        }
        return self.labels ?? []
    }
    
    
}
