//
//  ZLWatchEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLWatchEventTableViewCellData: ZLEventTableViewCellData {
    
    private var _eventDescription : NSAttributedString?
    
    override func getEventDescrption() -> NSAttributedString {
        
        if _eventDescription != nil {
            return _eventDescription!
        }
                
        let str = "starred \(self.eventModel.repo.name)"
     
        let attributedStr =  NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(cgColor: UIColor.init(named: "ZLLabelColor3")!.cgColor),NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
                        
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
        return "ZLEventTableViewCell"
    }
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func clearCache() {
        self._eventDescription = nil
    }

}
