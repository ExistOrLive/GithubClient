//
//  ZLPushEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/1.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLPushEventTableViewCellData: ZLEventTableViewCellData {
    
    private var _commitInfoAttributedStr : NSAttributedString?
    
    override func getEventDescrption() -> NSAttributedString {
        
        let str =  String.init(format: "%@ pushed to %@", self.eventModel.actor.display_login,self.eventModel.repo.name)
        
        let attributedString = NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "#333333", alpha: 1.0)!,NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
        
        let loginNameRange = (str as NSString).range(of: self.eventModel.actor.display_login)
        weak var weakSelf = self
        attributedString.yy_setTextHighlight(loginNameRange, color: ZLRGBValue_H(colorValue: 0x0666D6), backgroundColor: UIColor.clear, tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
            let vc = ZLUserInfoController.init(loginName: weakSelf?.eventModel.actor.login ?? "", type: ZLGithubUserType_User)
            vc.hidesBottomBarWhenPushed = true
            weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
        })
        
        let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
        attributedString.yy_setTextHighlight(repoNameRange, color: ZLRGBValue_H(colorValue: 0x0666D6), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
               
            let repoModel = ZLGithubRepositoryModel.init()
            repoModel.full_name = weakSelf?.eventModel.repo.name ?? "";
            let vc = ZLRepoInfoController.init(repoInfoModel: repoModel)
            vc.hidesBottomBarWhenPushed = true
            weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
            
        })
        
        return attributedString
    }
    
    override func getCellHeight() -> CGFloat{
        return UITableView.automaticDimension
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLPushEventTableViewCell"
    }
    
}

extension ZLPushEventTableViewCellData {
    
     func commitNum() -> Int
     {
         guard let pushEventPayload : ZLPushEventPayloadModel  = self.eventModel.payload as? ZLPushEventPayloadModel else
         {
             return 0;
         }
         
         return pushEventPayload.commits.count
     }
     
     func branch() -> String
     {
         guard let pushEventPayload : ZLPushEventPayloadModel  = self.eventModel.payload as? ZLPushEventPayloadModel else
         {
             return ""
         }
         return pushEventPayload.ref
     }
     
     func commitShaForIndex(index: Int) -> String
     {
         guard let pushEventPayload : ZLPushEventPayloadModel  = self.eventModel.payload as? ZLPushEventPayloadModel else
         {
             return ""
         }
         
         
         return String(pushEventPayload.commits[index].sha.prefix(7))
     }
     
     func commitMessageForIndex(index: Int) -> String
     {
         guard let pushEventPayload : ZLPushEventPayloadModel  = self.eventModel.payload as? ZLPushEventPayloadModel else
         {
             return ""
         }
         return pushEventPayload.commits[index].message
     }
     
     func commitAuthorForIndex(index: Int) -> String
     {
         guard let pushEventPayload : ZLPushEventPayloadModel  = self.eventModel.payload as? ZLPushEventPayloadModel else
         {
             return ""
         }
         return pushEventPayload.commits[index].author
     }
     
     
     func commitInfoAttributedStr() -> NSAttributedString
     {
         if self._commitInfoAttributedStr != nil
         {
             return self._commitInfoAttributedStr!
         }
         
         let str : NSMutableAttributedString  = NSMutableAttributedString()
         let paraghStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
         paraghStyle.lineSpacing = 5
         paraghStyle.lineBreakMode = .byClipping
         
         let commitNumStr : NSAttributedString = NSAttributedString.init(string: NSString.init(format: "%d commits to ", self.commitNum()) as String, attributes: [NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedString.Key.foregroundColor:UIColor.black])
         str.append(commitNumStr)
         
         let branchStr : NSAttributedString = NSAttributedString.init(string:String.init(format: "%@\n", self.branch()),attributes:[NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedString.Key.foregroundColor:UIColor.init("199BFF")])
         str.append(branchStr)
         
         if(self.commitNum() > 0)
         {
             for i in 0...(min(1,self.commitNum() - 1))
             {
                 let str1 = NSAttributedString.init(string:String.init(format: "%@ ", self.commitShaForIndex(index:i)),attributes:[NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedString.Key.foregroundColor:UIColor.init("199BFF")])
                 str.append(str1)
                 
                 let str2 = NSAttributedString.init(string: String.init(format: "%@\n", self.commitMessageForIndex(index:i)), attributes: [NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedString.Key.foregroundColor:UIColor.lightGray])
                 str.append(str2)
             }
             
             if self.commitNum() > 2
             {
                 let str1 = NSAttributedString.init(string: String.init(format: "%d more commits >> \n", self.commitNum() - 2) , attributes: [NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15)!,NSAttributedString.Key.foregroundColor:UIColor.init("333333")])
                     
                 str.append(str1)
             }
         }
         
         
         str.addAttribute(NSAttributedString.Key.paragraphStyle, value: paraghStyle, range: NSRange.init(location: 0, length: str.length))
         
         self._commitInfoAttributedStr = str
         
         return self._commitInfoAttributedStr!
     }
}
