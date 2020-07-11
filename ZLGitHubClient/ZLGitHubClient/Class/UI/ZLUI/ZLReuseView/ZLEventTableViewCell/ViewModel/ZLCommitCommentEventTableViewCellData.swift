//
//  ZLCommitCommentEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/5.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLCommitCommentEventTableViewCellData: ZLEventTableViewCellData {
    
    private var _eventDescription : NSAttributedString?
    
    private var _commitBody : NSAttributedString?
    
    override func getEventDescrption() -> NSAttributedString {
        
        if _eventDescription != nil {
            return _eventDescription!
        }
        
        guard let payload : ZLCommitCommentEventPayloadModel = self.eventModel.payload as? ZLCommitCommentEventPayloadModel else {
            return super.getEventDescrption()
        }
        
        let loginName = payload.comment.user.loginName
        let commit_id = String(payload.comment.commit_id.prefix(7))
        let repoFullName = self.eventModel.repo.name
        let str =  "\(loginName) commented on commit \(commit_id)\n\nin \(repoFullName)"
        
        let attributedString = NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "#333333", alpha: 1.0)!,NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
        
        let loginNameRange = (str as NSString).range(of: loginName)
        attributedString.yy_setTextHighlight(loginNameRange, color: ZLRGBValue_H(colorValue: 0x0666D6), backgroundColor: UIColor.clear, tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
           let vc = ZLUserInfoController.init(loginName: payload.comment.user.loginName, type: payload.comment.user.type)
           vc.hidesBottomBarWhenPushed = true
           self.viewController?.navigationController?.pushViewController(vc, animated: true)
        })
        
        
        let commitRange = (str as NSString).range(of: commit_id)
        attributedString.yy_setTextHighlight(commitRange, color: ZLRGBValue_H(colorValue: 0x0666D6), backgroundColor: UIColor.clear, tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
             let url = "https://github.com/\(repoFullName)/commit/\(payload.comment.commit_id)"
             let vc = ZLWebContentController.init()
             vc.hidesBottomBarWhenPushed = true
             vc.requestURL = URL.init(string: url)
             self.viewController?.navigationController?.pushViewController(vc, animated: true)
        })
        
    
        let repoNameRange = (str as NSString).range(of: repoFullName)
        attributedString.yy_setTextHighlight(repoNameRange, color: ZLRGBValue_H(colorValue: 0x0666D6), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
            let repoModel = ZLGithubRepositoryModel.init()
            repoModel.full_name = self.eventModel.repo.name;
            let vc = ZLRepoInfoController.init(repoInfoModel: repoModel)
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        })
        
        self._eventDescription = attributedString
        
        return attributedString
    }
    
    override func getCellHeight() -> CGFloat{
        return UITableView.automaticDimension
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLCommitCommentEventTableViewCell"
    }
    
    override func onCellSingleTap() {
        guard let payload : ZLCommitCommentEventPayloadModel = self.eventModel.payload as? ZLCommitCommentEventPayloadModel else {
            return
        }
        
        let vc = ZLWebContentController.init()
        vc.hidesBottomBarWhenPushed = true
        vc.requestURL = URL.init(string: payload.comment.html_url)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}


extension ZLCommitCommentEventTableViewCellData {
    
    func getCommitBody() -> NSAttributedString {
        
        if self._commitBody == nil {
            guard let payload : ZLCommitCommentEventPayloadModel = self.eventModel.payload as? ZLCommitCommentEventPayloadModel else {
                return NSAttributedString.init()
            }
            
            self._commitBody = NSAttributedString.init(string: payload.comment.body ?? "", attributes: [NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        }
        
        return self._commitBody ?? NSAttributedString.init()
    }
}
