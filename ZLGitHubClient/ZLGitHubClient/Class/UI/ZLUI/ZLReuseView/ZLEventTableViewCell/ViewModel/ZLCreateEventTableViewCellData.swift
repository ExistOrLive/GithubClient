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
    
    
    override func getEventDescrption() -> NSAttributedString {
        
        if _eventDescription != nil {
            return _eventDescription!
        }
        
        guard let payload : ZLCreateEventPayloadModel = self.eventModel.payload as? ZLCreateEventPayloadModel else {
            return super.getEventDescrption()
        }
        
        if payload.ref_type == .repository {
            
            let str =  "created repository \(self.eventModel.repo.name)"
            let attributedString = NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "#333333", alpha: 1.0)!,NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
            
            let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
            attributedString.yy_setTextHighlight(repoNameRange, color: ZLRGBValue_H(colorValue: 0x0666D6), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
                
                let repoModel = ZLGithubRepositoryModel.init()
                repoModel.full_name = self.eventModel.repo.name;
                let vc = ZLRepoInfoController.init(repoInfoModel: repoModel)
                vc.hidesBottomBarWhenPushed = true
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
                
            })
            
            self._eventDescription = attributedString
            return attributedString
            
        } else if payload.ref_type == .tag {
            
            let str =  "created tag \(payload.ref) in \(self.eventModel.repo.name)"
            let attributedString = NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "#333333", alpha: 1.0)!,NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
            
            let refRange = (str as NSString).range(of: payload.ref)
            attributedString.yy_setTextHighlight(refRange, color: ZLRGBValue_H(colorValue: 0x0666D6), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
                
                let url = "https://github.com/\(self.eventModel.repo.name)/releases/tag/\(payload.ref)"
                let vc = ZLWebContentController.init()
                vc.hidesBottomBarWhenPushed = true
                vc.requestURL = URL.init(string: url)
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
                
            })
            
            let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
            attributedString.yy_setTextHighlight(repoNameRange, color: ZLRGBValue_H(colorValue: 0x0666D6), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
                
                let repoModel = ZLGithubRepositoryModel.init()
                repoModel.full_name = self.eventModel.repo.name;
                let vc = ZLRepoInfoController.init(repoInfoModel: repoModel)
                vc.hidesBottomBarWhenPushed = true
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
                
            })
            
            
            self._eventDescription = attributedString
            return attributedString
            
        } else if payload.ref_type == .branch {
            
            let str =  "created branch \(payload.ref)  in \(self.eventModel.repo.name)"
            let attributedString = NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "#333333", alpha: 1.0)!,NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
            
            let refRange = (str as NSString).range(of: payload.ref)
            attributedString.yy_setTextHighlight(refRange, color: ZLRGBValue_H(colorValue: 0x0666D6), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
            })
            
            let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
            attributedString.yy_setTextHighlight(repoNameRange, color: ZLRGBValue_H(colorValue: 0x0666D6), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
                
                let repoModel = ZLGithubRepositoryModel.init()
                repoModel.full_name = self.eventModel.repo.name;
                let vc = ZLRepoInfoController.init(repoInfoModel: repoModel)
                vc.hidesBottomBarWhenPushed = true
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
                
            })
            
            
            self._eventDescription = attributedString
            return attributedString
            
        } else {
            return super.getEventDescrption()
        }
    }
    
}
