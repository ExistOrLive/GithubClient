//
//  ZLPullRequestReviewCommentEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLPullRequestReviewCommentEventTableViewCellData: ZLEventTableViewCellData {
    
    private var _eventDescription : NSAttributedString?
    
    override func getEventDescrption() -> NSAttributedString {
        if _eventDescription != nil {
            return _eventDescription!
        }
        
        guard let payload : ZLPullRequestReviewCommentEventPayloadModel = self.eventModel.payload as? ZLPullRequestReviewCommentEventPayloadModel else {
            return super.getEventDescrption()
        }
        
        weak var weakSelf = self
        
        let str = "\(payload.action) comment on pull request #\(payload.pull_request.number)\n\n  #\(payload.pull_request.title)\n\nin \(self.eventModel.repo.name)"
        let attributedStr =  NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "#333333", alpha: 1.0)!,NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])

        let prNumberRange = (str as NSString).range(of: "#\(payload.pull_request.number)")
        attributedStr.yy_setTextHighlight(prNumberRange, color: ZLRGBValue_H(colorValue: 0x0666D6), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
            let vc = ZLWebContentController.init()
            vc.hidesBottomBarWhenPushed = true
            vc.requestURL = URL.init(string: payload.pull_request.html_url)
            weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
        })

        let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
        attributedStr.yy_setTextHighlight(repoNameRange, color: ZLRGBValue_H(colorValue: 0x0666D6), backgroundColor: UIColor.clear , tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in

            let repoModel = ZLGithubRepositoryModel.init()
            repoModel.full_name = weakSelf?.eventModel.repo.name ?? "";
            let vc = ZLRepoInfoController.init(repoInfoModel: repoModel)
            vc.hidesBottomBarWhenPushed = true
            weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)

        })

        _eventDescription = attributedStr
        
        return attributedStr
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLEventTableViewCellData"
    }
    
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }

}
