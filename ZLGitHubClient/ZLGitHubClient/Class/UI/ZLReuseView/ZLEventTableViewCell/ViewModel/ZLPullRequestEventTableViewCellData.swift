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
        
        if let desc = _eventDescription  {
            return desc
        }
        
        guard let payload : ZLPullRequestEventPayloadModel = self.eventModel.payload as? ZLPullRequestEventPayloadModel else {
            return super.getEventDescrption()
        }
        
        
        let str = "\(payload.action) pull request #\(payload.number)\n\n  \(payload.pull_request.title)\n\nin \(self.eventModel.repo.name)"
        let attributedStr =  NSMutableAttributedString(string: str ,
                                                       attributes: [.foregroundColor:UIColor.init(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                    .font:UIFont.zlRegularFont(withSize: 15)])

        
        
        let prNumberRange = (str as NSString).range(of: "#\(payload.number)")
        attributedStr.yy_setTextHighlight(prNumberRange,
                                          color: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                          backgroundColor: UIColor.clear)
        {[weak weakSelf = self](containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
            let vc = ZLWebContentController.init()
            vc.hidesBottomBarWhenPushed = true
            vc.requestURL = URL.init(string: payload.pull_request.html_url)
            weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
        }

        let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
        attributedStr.yy_setTextHighlight(repoNameRange,
                                          color: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                          backgroundColor: UIColor.clear)
        {[weak weakSelf = self](containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in

            if let repoFullName = weakSelf?.eventModel.repo.name,
               let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                vc.hidesBottomBarWhenPushed = true
                weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }

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
                
        if let url = URL(string: payload.pull_request.html_url) {
            if url.pathComponents.count >= 5 && url.pathComponents[3] == "pull" {
                ZLUIRouter.navigateVC(key: ZLUIRouter.PRInfoController,
                                      params: ["login":url.pathComponents[1],
                                               "repoName":url.pathComponents[2],
                                               "number":Int(url.pathComponents[4]) ?? 0])
            } else {
                let vc = ZLWebContentController.init()
                vc.hidesBottomBarWhenPushed = true
                vc.requestURL = url
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
        
    }
    
    override func clearCache(){
        self._eventDescription = nil
        self._pullRequestBody = nil
    }
    
}

extension ZLPullRequestEventTableViewCellData{
    func getPRBody() -> NSAttributedString {
        
        if self._pullRequestBody == nil {
            guard let payload : ZLPullRequestEventPayloadModel = self.eventModel.payload as? ZLPullRequestEventPayloadModel else {
                return NSAttributedString.init()
            }

            self._pullRequestBody = NSAttributedString.init(string: payload.pull_request.body,
                                                            attributes: [.font:UIFont.zlRegularFont(withSize: 14),
                                                                         .foregroundColor:UIColor.lightGray])
        }

        return self._pullRequestBody ?? NSAttributedString.init()

    }
}
