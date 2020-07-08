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
        for pageModel in payload.pages {
            
            let str = "\(pageModel.action) wiki page \(pageModel.page_name)\n"
            let tmpAttributedStr =  NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "#333333", alpha: 1.0)!,NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
            
            let pageNameRange = (str as NSString).range(of: pageModel.page_name)
            tmpAttributedStr.yy_setTextHighlight(pageNameRange, color: ZLRGBValue_H(colorValue: 0x0666D6), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
                let vc = ZLWebContentController.init()
                vc.hidesBottomBarWhenPushed = true
                vc.requestURL = URL.init(string: pageModel.html_url)
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
            })
            attributedStr.append(tmpAttributedStr)
        }
        
        let str = "\nin \(self.eventModel.repo.name)"
        let tmpAttributedStr =  NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "#333333", alpha: 1.0)!,NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
        
        let repoRange = (str as NSString).range(of: self.eventModel.repo.name)
        tmpAttributedStr.yy_setTextHighlight(repoRange, color: ZLRGBValue_H(colorValue: 0x0666D6), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
            let repoModel = ZLGithubRepositoryModel.init()
            repoModel.full_name = self.eventModel.repo.name;
            let vc = ZLRepoInfoController.init(repoInfoModel: repoModel)
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
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
    
    

}
