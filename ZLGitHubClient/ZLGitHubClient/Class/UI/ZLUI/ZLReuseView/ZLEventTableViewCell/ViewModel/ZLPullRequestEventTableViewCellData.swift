//
//  ZLPullRequestEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLPullRequestEventTableViewCellData: ZLEventTableViewCellData {

    private var _eventDescription : NSAttributedString?
    private var _pullRequestBody : NSAttributedString?
    
    override func getEventDescrption() -> NSAttributedString {
        if _eventDescription != nil {
            return _eventDescription!
        }
        
        guard let payload : ZLPullRequestEventPayloadModel = self.eventModel.payload as? ZLPullRequestEventPayloadModel else {
            return super.getEventDescrption()
        }
        
        let str = "\(payload.action) pull request #\(payload.number)\n\n  \(payload.pull_request.title)\n\nin \(self.eventModel.repo.name)"
        let attributedStr =  NSMutableAttributedString.init(string: str , attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "#333333", alpha: 1.0)!,NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])

        weak var weakSelf = self
        
        let prNumberRange = (str as NSString).range(of: "#\(payload.number)")
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
        return "ZLPullRequestEventTableViewCell"
    }
    
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    override func onCellSingleTap() {
        
        guard let payload : ZLPullRequestEventPayloadModel = self.eventModel.payload as? ZLPullRequestEventPayloadModel else {
            return
        }
        
        let vc = ZLWebContentController.init()
        vc.hidesBottomBarWhenPushed = true
        vc.requestURL = URL.init(string: payload.pull_request.html_url)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ZLPullRequestEventTableViewCellData{
    func getPRBody() -> NSAttributedString {
        
        if self._pullRequestBody == nil {
            guard let payload : ZLPullRequestEventPayloadModel = self.eventModel.payload as? ZLPullRequestEventPayloadModel else {
                return NSAttributedString.init()
            }

            self._pullRequestBody = NSAttributedString.init(string: payload.pull_request.body, attributes: [NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        }

        return self._pullRequestBody ?? NSAttributedString.init()

    }
}
