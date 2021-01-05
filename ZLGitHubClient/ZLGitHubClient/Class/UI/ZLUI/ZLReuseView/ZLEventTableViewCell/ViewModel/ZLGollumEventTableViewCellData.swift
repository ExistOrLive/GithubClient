//
//  ZLGollumEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLGollumEventTableViewCellData: ZLEventTableViewCellData {
    
    private var _eventDescription : NSAttributedString?
    
    override func getEventDescrption() -> NSAttributedString {
        if _eventDescription != nil {
            return _eventDescription!
        }
        
        guard let payload : ZLGollumEventPayloadModel = self.eventModel.payload as? ZLGollumEventPayloadModel else {
            return super.getEventDescrption()
        }
        
        let attributedStr : NSMutableAttributedString  = NSMutableAttributedString()
        weak var weakSelf = self
        for pageModel in payload.pages {
            
            let str = "\(pageModel.action) wiki page \(pageModel.page_name)\n"
            let tmpAttributedStr =  NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(cgColor: UIColor.init(named: "ZLLabelColor3")!.cgColor),NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
            
            let pageNameRange = (str as NSString).range(of: pageModel.page_name)
            tmpAttributedStr.yy_setTextHighlight(pageNameRange, color: UIColor.init(cgColor: UIColor.init(named: "ZLLinkLabelColor1")!.cgColor), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
                let vc = ZLWebContentController.init()
                vc.hidesBottomBarWhenPushed = true
                vc.requestURL = URL.init(string: pageModel.html_url)
                weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
            })
            attributedStr.append(tmpAttributedStr)
        }
        
        let str = "\nin \(self.eventModel.repo.name)"
        let tmpAttributedStr =  NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(cgColor: UIColor.init(named: "ZLLabelColor3")!.cgColor),NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
        
        let repoRange = (str as NSString).range(of: self.eventModel.repo.name)
        tmpAttributedStr.yy_setTextHighlight(repoRange, color: UIColor.init(cgColor: UIColor.init(named: "ZLLinkLabelColor1")!.cgColor), backgroundColor: UIColor.clear , tapAction: {[weak weakSelf = self](containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
            
            if let repoFullName = weakSelf?.eventModel.repo.name,let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                vc.hidesBottomBarWhenPushed = true
                weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
            
        })
        attributedStr.append(tmpAttributedStr)
        
        _eventDescription = attributedStr
        
        return attributedStr
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLEventTableViewCell"
    }
    
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func clearCache(){
        self._eventDescription = nil
    }
}
