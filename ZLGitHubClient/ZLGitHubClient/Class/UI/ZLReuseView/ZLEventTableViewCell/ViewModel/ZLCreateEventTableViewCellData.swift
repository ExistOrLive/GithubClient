//
//  ZLCreateEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/5.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

/**
 master_branch = "master";
 pusher_type = "user";
 description = "Github客户端 iOS";
 ref_type = "tag";
 ref = "V1.0.1.7";
 */
class ZLCreateEventTableViewCellData: ZLEventTableViewCellData {
    
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
        
        if _eventDescription != nil {
            return _eventDescription!
        }
        
        guard let payload : ZLCreateEventPayloadModel = self.eventModel.payload as? ZLCreateEventPayloadModel else {
            return super.getEventDescrption()
        }
        
        weak var weakSelf = self
        
        if payload.ref_type == .repository {
            
            let str =  "created repository \(self.eventModel.repo.name)"
            let attributedString = NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(cgColor: UIColor.init(named: "ZLLabelColor3")!.cgColor),NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
            
            let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
            attributedString.yy_setTextHighlight(repoNameRange, color: UIColor.init(cgColor: UIColor.init(named: "ZLLinkLabelColor1")!.cgColor), backgroundColor: UIColor.clear , tapAction: {[weak weakSelf = self](containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
                
                if let repoFullName = weakSelf?.eventModel.repo.name,let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                    vc.hidesBottomBarWhenPushed = true
                    weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
                }
            })
            
            self._eventDescription = attributedString
            return attributedString
            
        } else if payload.ref_type == .tag {
            
            let str =  "created tag \(payload.ref)\n\nin \(self.eventModel.repo.name)"
            let attributedString = NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(cgColor: UIColor.init(named: "ZLLabelColor3")!.cgColor),NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
            
            let refRange = (str as NSString).range(of: payload.ref)
            attributedString.yy_setTextHighlight(refRange, color: UIColor.init(cgColor: UIColor.init(named: "ZLLinkLabelColor1")!.cgColor), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
                
                let url = "https://github.com/\(weakSelf?.eventModel.repo.name ?? "")/releases/tag/\(payload.ref)"
                let vc = ZLWebContentController.init()
                vc.hidesBottomBarWhenPushed = true
                vc.requestURL = URL.init(string: url)
                weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
                
            })
            
            let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
            attributedString.yy_setTextHighlight(repoNameRange, color: UIColor.init(cgColor: UIColor.init(named: "ZLLinkLabelColor1")!.cgColor), backgroundColor: UIColor.clear , tapAction: {[weak weakSelf = self](containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
                
                if let repoFullName = weakSelf?.eventModel.repo.name,let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                    vc.hidesBottomBarWhenPushed = true
                    weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
                }
            })
            
            
            self._eventDescription = attributedString
            return attributedString
            
        } else if payload.ref_type == .branch {
            
            let str =  "created branch \(payload.ref)\n\nin \(self.eventModel.repo.name)"
            let attributedString = NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(cgColor: UIColor.init(named: "ZLLabelColor3")!.cgColor),NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
            
            let refRange = (str as NSString).range(of: payload.ref)
            attributedString.yy_setTextHighlight(refRange, color: UIColor.init(cgColor: UIColor.init(named: "ZLLinkLabelColor1")!.cgColor), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
            })
            
            let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
            attributedString.yy_setTextHighlight(repoNameRange, color: UIColor.init(cgColor: UIColor.init(named: "ZLLinkLabelColor1")!.cgColor), backgroundColor: UIColor.clear , tapAction: {[weak weakSelf = self](containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
                
                if let repoFullName = weakSelf?.eventModel.repo.name,let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                    vc.hidesBottomBarWhenPushed = true
                    weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
                }
                
            })
            
            
            self._eventDescription = attributedString
            return attributedString
            
        } else {
            return super.getEventDescrption()
        }
    }
    
}
