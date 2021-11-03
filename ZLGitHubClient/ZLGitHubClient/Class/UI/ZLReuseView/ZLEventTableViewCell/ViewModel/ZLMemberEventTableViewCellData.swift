//
//  ZLMemberEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLMemberEventTableViewCellData: ZLEventTableViewCellData {
    
    private var _eventDescription : NSAttributedString?
    
    override func getEventDescrption() -> NSAttributedString {
      
        if let desc = _eventDescription {
            return desc
        }
        
        guard let payload : ZLMemberEventPayloadModel = self.eventModel.payload as? ZLMemberEventPayloadModel else {
            return super.getEventDescrption()
        }
        
        
        let str = "\(payload.action) collaborator \(payload.member.loginName ?? "")\n\nto \(self.eventModel.repo.name)"
        let attributedStr =  NSMutableAttributedString(string: str ,
                                                       attributes: [.foregroundColor:UIColor(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                    .font:UIFont.zlRegularFont(withSize: 15)])
                
        let memberRange = (str as NSString).range(of: "\(payload.member.loginName ?? "")")
        attributedStr.yy_setTextHighlight(memberRange,
                                          color: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                          backgroundColor: UIColor.clear)
        {[weak self](containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
           
            if let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName:payload.member.loginName ?? ""){
                
                userInfoVC.hidesBottomBarWhenPushed = true
                self?.viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
            }
            
        }
        
        let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
        attributedStr.yy_setTextHighlight(repoNameRange,
                                          color: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
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
        return "ZLEventTableViewCell"
    }
    
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func clearCache() {
        self._eventDescription = nil
    }
    
    
}
