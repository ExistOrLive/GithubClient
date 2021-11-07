//
//  ZLIssueEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLIssueEventTableViewCellData: ZLEventTableViewCellData {
    
    private var _eventDescription : NSAttributedString?
    private var _issueBody : NSAttributedString?
    
    override func getEventDescrption() -> NSAttributedString {
        
        if let desc = _eventDescription{
            return desc
        }
        
        guard let payload : ZLIssueEventPayloadModel = self.eventModel.payload as? ZLIssueEventPayloadModel else {
            return super.getEventDescrption()
        }
        
        let str = "\(payload.action) issue #\(payload.issue.number)\n\n  \(payload.issue.title)\n\nin \(self.eventModel.repo.name)"
        let attributedStr =  NSMutableAttributedString(string: str ,
                                                       attributes: [.foregroundColor:UIColor.init(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                    .font:UIFont.zlRegularFont(withSize: 15)])
        
        let issueRange = (str as NSString).range(of: "#\(payload.issue.number)")
        attributedStr.yy_setTextHighlight(issueRange,
                                          color: UIColor.init(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                          backgroundColor: UIColor.clear)
        {[weak self](containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
            
            if let repoFullName = self?.eventModel.repo.name{
                
                let array = repoFullName.split(separator: "/")
                if array.count == 2 {
                    let login = String(array[0])
                    let name = String(array[1])
                    ZLUIRouter.navigateVC(key: ZLUIRouter.IssueInfoController,
                                          params: ["login":login,
                                                   "repoName":name,
                                                   "number":payload.issue.number])
                }
                
            } else if let url = URL.init(string: payload.issue.html_url) {
                
                ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,
                                      params: ["requestURL":url])
            }
                
        }

        let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
        attributedStr.yy_setTextHighlight(repoNameRange,
                                          color: UIColor.init(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                          backgroundColor: UIColor.clear)
        {[weak weakSelf = self](containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in

            if let repoFullName = weakSelf?.eventModel.repo.name,
               let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                vc.hidesBottomBarWhenPushed = true
                weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }

        _eventDescription = attributedStr
        
        return attributedStr
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLIssueEventTableViewCell"
    }
    
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func onCellSingleTap() {
        
        guard let payload : ZLIssueEventPayloadModel = self.eventModel.payload as? ZLIssueEventPayloadModel else {
            return
        }
        
        if let url = URL(string: payload.issue.html_url) {
            
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
                
                ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,
                                      params: ["requestURL":url])
            }
            
        }
    }
    
    override func clearCache(){
        self._eventDescription = nil
        self._issueBody = nil
    }
    
}

extension ZLIssueEventTableViewCellData{
    func getIssueBody() -> NSAttributedString {
        
        if self._issueBody == nil {
            guard let payload : ZLIssueEventPayloadModel = self.eventModel.payload as? ZLIssueEventPayloadModel else {
                return NSAttributedString.init()
            }

            self._issueBody = NSAttributedString(string: payload.issue.body,
                                                 attributes: [.font:UIFont.zlRegularFont(withSize: 14),
                                                              .foregroundColor:UIColor.lightGray])
        }

        return self._issueBody ?? NSAttributedString.init()

    }
}
