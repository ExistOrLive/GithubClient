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
    private var _cellHeight : CGFloat?
    
    
    override func getEventDescrption() -> String {
        
        return  String.init(format: "%@ pushed to %@", self.eventModel.actor.display_login,self.eventModel.repo.name);
    }
    
    override func getCellHeight() -> CGFloat
    {
        if self._cellHeight != nil
        {
            return self._cellHeight!
        }
        
        let height : CGFloat = super.getCellHeight()
        
        let bounds = self.commitInfoAttributedStr().boundingRect(with: CGSize(width: ZLScreenWidth - 60 , height: ZLSCreenHeight), options: .usesLineFragmentOrigin, context: nil)
        
        self._cellHeight = bounds.size.height + height + 15;
        
        return self._cellHeight!;
    }
    

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
        
        let commitNumStr : NSAttributedString = NSAttributedString.init(string: NSString.init(format: "%d commits to ", self.commitNum()) as String, attributes: [NSAttributedStringKey.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedStringKey.foregroundColor:UIColor.black])
        str.append(commitNumStr)
        
        let branchStr : NSAttributedString = NSAttributedString.init(string:String.init(format: "%@\n", self.branch()),attributes:[NSAttributedStringKey.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedStringKey.foregroundColor:UIColor.init("199BFF")])
        str.append(branchStr)
        
        if(self.commitNum() > 0)
        {
            for i in 0...(min(1,self.commitNum() - 1))
            {
                let str1 = NSAttributedString.init(string:String.init(format: "%@ ", self.commitShaForIndex(index:i)),attributes:[NSAttributedStringKey.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedStringKey.foregroundColor:UIColor.init("199BFF")])
                str.append(str1)
                
                let str2 = NSAttributedString.init(string: String.init(format: "%@\n", self.commitMessageForIndex(index:i)), attributes: [NSAttributedStringKey.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedStringKey.foregroundColor:UIColor.lightGray])
                str.append(str2)
            }
            
            if self.commitNum() > 2
            {
                let str1 = NSAttributedString.init(string: String.init(format: "%d more commits >> \n", self.commitNum() - 2) , attributes: [NSAttributedStringKey.font:UIFont.init(name: Font_PingFangSCRegular, size: 15)!,NSAttributedStringKey.foregroundColor:UIColor.init("333333")])
                    
                str.append(str1)
            }
        }
        
        
        str.addAttribute(NSAttributedStringKey.paragraphStyle, value: paraghStyle, range: NSRange.init(location: 0, length: str.length))
        
        self._commitInfoAttributedStr = str
        
        return self._commitInfoAttributedStr!
    }
}
