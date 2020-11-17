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
    private var _eventDescrition : NSAttributedString?
    
    override func getEventDescrption() -> NSAttributedString {
        
        if let eventDescrition = self._eventDescrition {
            return eventDescrition
        }
        
        let str =  String.init(format: "%@ pushed to %@", self.eventModel.actor.display_login,self.eventModel.repo.name)
        
        let attributedString = NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(cgColor: UIColor.init(named: "ZLLabelColor3")!.cgColor),NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
        
        
        let loginNameRange = (str as NSString).range(of: self.eventModel.actor.display_login)
        weak var weakSelf = self
        attributedString.yy_setTextHighlight(loginNameRange, color: UIColor.init(cgColor: UIColor.init(named: "ZLLinkLabelColor1")!.cgColor), backgroundColor: UIColor.clear, tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
            let vc = ZLUserInfoController.init(loginName: weakSelf?.eventModel.actor.login ?? "", type: ZLGithubUserType_User)
            vc.hidesBottomBarWhenPushed = true
            weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
        })
        
        let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
        attributedString.yy_setTextHighlight(repoNameRange, color: UIColor.init(cgColor: UIColor.init(named: "ZLLinkLabelColor1")!.cgColor), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
               
            let repoModel = ZLGithubRepositoryModel.init()
            repoModel.full_name = weakSelf?.eventModel.repo.name ?? "";
            let vc = ZLRepoInfoController.init(repoInfoModel: repoModel)
            vc.hidesBottomBarWhenPushed = true
            weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
            
        })
        
        _eventDescrition = attributedString
        
        return attributedString
    }
    
    override func getCellHeight() -> CGFloat{
        return UITableView.automaticDimension
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLPushEventTableViewCell"
    }
    
    override func clearCache(){
        self._eventDescrition = nil
        self._commitInfoAttributedStr = nil
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
     
     
     func commitInfoAttributedStr() -> NSAttributedString{
        
         if let commitInfoAttributedStr = _commitInfoAttributedStr{
             return commitInfoAttributedStr
         }
         
         let str : NSMutableAttributedString  = NSMutableAttributedString()
         let paraghStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
         paraghStyle.lineSpacing = 5
         paraghStyle.lineBreakMode = .byClipping
         
        let commitNumStr : NSAttributedString = NSAttributedString.init(string: NSString.init(format: "%d commits to ", self.commitNum()) as String, attributes: [NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedString.Key.foregroundColor:UIColor.init(named: "ZLLabelColor3")!])
         str.append(commitNumStr)
         
        let branchStr : NSAttributedString = NSAttributedString.init(string:String.init(format: "%@\n", self.branch()),attributes:[NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedString.Key.foregroundColor:UIColor.init(named: "ZLLinkLabelColor2")!])
         str.append(branchStr)
         
         if(self.commitNum() > 0)
         {
             for i in 0...(min(1,self.commitNum() - 1))
             {
                 let str1 = NSAttributedString.init(string:String.init(format: "%@ ", self.commitShaForIndex(index:i)),attributes:[NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedString.Key.foregroundColor:UIColor.init(named: "ZLLinkLabelColor2")!])
                 str.append(str1)
                 
                 let str2 = NSAttributedString.init(string: String.init(format: "%@\n", self.commitMessageForIndex(index:i)), attributes: [NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedString.Key.foregroundColor:UIColor.init(named: "ZLLabelColor2")!])
                 str.append(str2)
             }
             
             if self.commitNum() > 2
             {
                 let str1 = NSAttributedString.init(string: String.init(format: "%d more commits >> \n", self.commitNum() - 2) , attributes: [NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15)!,NSAttributedString.Key.foregroundColor:UIColor.init(named: "ZLLabelColor3")!])
                     
                 str.append(str1)
             }
         }
         
         
         str.addAttribute(NSAttributedString.Key.paragraphStyle, value: paraghStyle, range: NSRange.init(location: 0, length: str.length))
         
         self._commitInfoAttributedStr = str
         
         return self._commitInfoAttributedStr!
     }
}
