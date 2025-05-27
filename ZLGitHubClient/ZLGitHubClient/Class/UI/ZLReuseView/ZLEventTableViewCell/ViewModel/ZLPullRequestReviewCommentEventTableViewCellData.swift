//
//  ZLPullRequestReviewCommentEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService

class ZLPullRequestReviewCommentEventTableViewCellData: ZLEventTableViewCellData {

    private var _eventDescription: NSAttributedString?

    override func getEventDescrption() -> NSAttributedString {

        if let desc = _eventDescription {
            return desc
        }

        guard let payload: ZLPullRequestReviewCommentEventPayloadModel = self.eventModel.payload as? ZLPullRequestReviewCommentEventPayloadModel else {
            return super.getEventDescrption()
        }

        let str = "\(payload.action) comment on pull request #\(payload.pull_request.number)\n\n  #\(payload.pull_request.title)\n\nin \(self.eventModel.repo.name)"

        let attributedStr =  NSMutableAttributedString(string: str ,
                                                       attributes: [.foregroundColor: UIColor.init(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                    .font: UIFont.zlRegularFont(withSize: 15)])

        let prNumberRange = (str as NSString).range(of: "#\(payload.pull_request.number)")
        attributedStr.yy_setTextHighlight(prNumberRange,
                                          color: UIColor.init(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                          backgroundColor: UIColor.clear) {(_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

            if let url = URL.init(string: payload.pull_request.html_url) {
                ZLUIRouter.openURL(url: url)
            }
        }

        let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
        attributedStr.yy_setTextHighlight(repoNameRange,
                                          color: UIColor.init(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                          backgroundColor: UIColor.clear) {[weak self](_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

            if let repoFullName = self?.eventModel.repo.name,
               let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                vc.hidesBottomBarWhenPushed = true
                self?.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }

        _eventDescription = attributedStr

        return attributedStr
    }

    override func zm_onCellSingleTap()  {

        guard let payload: ZLPullRequestReviewCommentEventPayloadModel = self.eventModel.payload as? ZLPullRequestReviewCommentEventPayloadModel else {
            return
        }

        if let url = URL(string: payload.pull_request.html_url) {
            ZLUIRouter.openURL(url: url)
        }

    }

    override func zm_clearCache() {
        self._eventDescription = nil
    }

}
