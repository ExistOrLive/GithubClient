//
//  ZLIssueCommentEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLIssueCommentEventTableViewCellData: ZLEventTableViewCellData {
    
    private var _eventDescription : NSAttributedString?
    private var _commentBody : NSAttributedString?
    
    override func getEventDescrption() -> NSAttributedString {
        if _eventDescription != nil {
            return _eventDescription!
        }
        
        guard let payload : ZLIssueCommentEventPayloadModel = self.eventModel.payload as? ZLIssueCommentEventPayloadModel else {
            return super.getEventDescrption()
        }
        
        let str = "\(payload.action) comment on issue #\(payload.issue.number)\n\n  \(payload.issue.title)\n\nin \(self.eventModel.repo.name)"
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
        return "ZLIssueCommentEventTableViewCell"
    }
    
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func onCellSingleTap() {
        
        guard let payload : ZLIssueCommentEventPayloadModel = self.eventModel.payload as? ZLIssueCommentEventPayloadModel else {
            return
        }
        
        let vc = ZLWebContentController.init()
        vc.hidesBottomBarWhenPushed = true
        vc.requestURL = URL.init(string: payload.issue.html_url)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func clearCache(){
        self._eventDescription = nil
        self._commentBody = nil
    }
    
}

extension ZLIssueCommentEventTableViewCellData{
    func getIssueCommentBody() -> NSAttributedString {
        
        if self._commentBody == nil {
              guard let payload : ZLIssueCommentEventPayloadModel = self.eventModel.payload as? ZLIssueCommentEventPayloadModel else {
                  return NSAttributedString.init()
              }
              
              self._commentBody = NSAttributedString.init(string: payload.comment.body ?? "", attributes: [NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedString.Key.foregroundColor:UIColor.lightGray])
          }
          
          return self._commentBody ?? NSAttributedString.init()
        
    }
}
