//
//  ZLForkEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/5.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLForkEventTableViewCellData: ZLEventTableViewCellData {
    
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
        
        guard let payload : ZLForkEventPayloadModel = self.eventModel.payload as? ZLForkEventPayloadModel else {
            return super.getEventDescrption()
        }
        
        
        let str = "forked \(payload.forkee.full_name)\n\nfrom \(self.eventModel.repo.name)"
        
        let attributedString = NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(cgColor: UIColor.init(named: "ZLLabelColor3")!.cgColor),NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
        
        weak var weakSelf = self
        let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
        attributedString.yy_setTextHighlight(repoNameRange, color:UIColor.init(cgColor: UIColor.init(named: "ZLLinkLabelColor1")!.cgColor), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
            
            let repoModel = ZLGithubRepositoryModel.init()
            repoModel.full_name = weakSelf?.eventModel.repo.name ?? "";
            let vc = ZLRepoInfoController.init(repoInfoModel: repoModel)
            vc.hidesBottomBarWhenPushed = true
            weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
            
        })
        
        let forkeeRepoNameRange = (str as NSString).range(of: payload.forkee.full_name)
        attributedString.yy_setTextHighlight(forkeeRepoNameRange, color: UIColor.init(cgColor: UIColor.init(named: "ZLLinkLabelColor1")!.cgColor), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
            
            let repoModel = ZLGithubRepositoryModel.init()
            repoModel.full_name = payload.forkee.full_name;
            let vc = ZLRepoInfoController.init(repoInfoModel: repoModel)
            vc.hidesBottomBarWhenPushed = true
            weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
            
        })
        
        
        self._eventDescription = attributedString
        return attributedString
        
        
    }
    
    

}
