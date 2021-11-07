//
//  ZLDeleteEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/5.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLDeleteEventTableViewCellData: ZLEventTableViewCellData {
    
    private var _eventDescription : NSAttributedString?
    
    override func getCellReuseIdentifier() -> String{
        return "ZLEventTableViewCell"
    }
    
    override func getCellHeight() -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    override func clearCache(){
        self._eventDescription = nil
    }
    
    override func getEventDescrption() -> NSAttributedString {
        
        if let desc = _eventDescription{
            return desc
        }
        
        guard let payload : ZLDeleteEventPayloadModel = self.eventModel.payload as? ZLDeleteEventPayloadModel else {
            return super.getEventDescrption()
        }
        
        if payload.ref_type == .repository {
            
            let str =  "deleted repository \(self.eventModel.repo.name)"
            let attributedString = NSMutableAttributedString(string: str ,
                                                             attributes: [.foregroundColor:UIColor.init(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                          .font:UIFont.zlRegularFont(withSize: 15)])
            
            let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
            attributedString.yy_setTextHighlight(repoNameRange,
                                                 color: UIColor.init(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                                 backgroundColor: UIColor.clear)
            {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
                
//                if let repoFullName = self?.eventModel.repo.name,
//                   let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
//                    vc.hidesBottomBarWhenPushed = true
//                    self?.viewController?.navigationController?.pushViewController(vc, animated: true)
//                }
                            
            }
            
            self._eventDescription = attributedString
            return attributedString
            
        } else if payload.ref_type == .tag {
            
            let str =  "deleted tag \(payload.ref)\n\nin \(self.eventModel.repo.name)"
            let attributedString = NSMutableAttributedString(string: str ,
                                                             attributes: [.foregroundColor:UIColor.init(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                          .font:UIFont.zlRegularFont(withSize: 15)])
            
            let refRange = (str as NSString).range(of: payload.ref)
            attributedString.yy_setTextHighlight(refRange,
                                                 color: UIColor.init(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                                 backgroundColor: UIColor.clear)
            {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
            }
            
            let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
            attributedString.yy_setTextHighlight(repoNameRange,
                                                 color: UIColor.init(cgColor: UIColor.linkColor(withName:"ZLLinkLabelColor1").cgColor),
                                                 backgroundColor: UIColor.clear)
            {[weak self ](containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
                
                if let repoFullName = self?.eventModel.repo.name,
                   let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                    vc.hidesBottomBarWhenPushed = true
                    self?.viewController?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            
            self._eventDescription = attributedString
            return attributedString
            
        } else if payload.ref_type == .branch {
            
            let str =  "deleted branch \(payload.ref)\n\nin \(self.eventModel.repo.name)"
            let attributedString = NSMutableAttributedString(string: str ,
                                                             attributes: [.foregroundColor:UIColor.init(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                          .font:UIFont.zlRegularFont(withSize: 15)])
            
            let refRange = (str as NSString).range(of: payload.ref)
            attributedString.yy_setTextHighlight(refRange,
                                                 color: UIColor.init(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                                 backgroundColor: UIColor.clear)
            {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
            }
            
            let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
            attributedString.yy_setTextHighlight(repoNameRange,
                                                color: UIColor.init(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                                 backgroundColor: UIColor.clear)
            {[weak self](containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
                
                if let repoFullName = self?.eventModel.repo.name,
                   let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                    
                    vc.hidesBottomBarWhenPushed = true
                    self?.viewController?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            
            self._eventDescription = attributedString
            return attributedString
            
        } else {
            return super.getEventDescrption()
        }
    }
    
}
