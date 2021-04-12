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
        if _eventDescription != nil {
            return _eventDescription!
        }
        
        guard let payload : ZLIssueEventPayloadModel = self.eventModel.payload as? ZLIssueEventPayloadModel else {
            return super.getEventDescrption()
        }
        
        let str = "\(payload.action) issue #\(payload.issue.number)\n\n  \(payload.issue.title)\n\nin \(self.eventModel.repo.name)"
        let attributedStr =  NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(cgColor: UIColor.init(named: "ZLLabelColor3")!.cgColor),NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
        
        let issueRange = (str as NSString).range(of: "#\(payload.issue.number)")
        attributedStr.yy_setTextHighlight(issueRange, color: UIColor.init(cgColor: UIColor.init(named: "ZLLinkLabelColor1")!.cgColor), backgroundColor: UIColor.clear , tapAction: {[weak weakSelf = self](containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
            let vc = ZLWebContentController.init()
            vc.hidesBottomBarWhenPushed = true
            vc.requestURL = URL.init(string: payload.issue.html_url)
            weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
        })

        let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
        attributedStr.yy_setTextHighlight(repoNameRange, color: UIColor.init(cgColor: UIColor.init(named: "ZLLinkLabelColor1")!.cgColor), backgroundColor: UIColor.clear , tapAction: {[weak weakSelf = self](containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in

            if let repoFullName = weakSelf?.eventModel.repo.name,let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                vc.hidesBottomBarWhenPushed = true
                weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        })

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
                let vc = ZLWebContentController.init()
                vc.requestURL = url
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
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

            self._issueBody = NSAttributedString.init(string: payload.issue.body, attributes: [NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        }

        return self._issueBody ?? NSAttributedString.init()

    }
}
