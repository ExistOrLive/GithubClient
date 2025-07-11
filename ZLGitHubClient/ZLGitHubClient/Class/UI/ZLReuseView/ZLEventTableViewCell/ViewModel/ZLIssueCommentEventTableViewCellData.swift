//
//  ZLIssueCommentEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService

class ZLIssueCommentEventTableViewCellData: ZLEventTableViewCellData {

    private var _eventDescription: NSAttributedString?
    private var _commentBody: NSAttributedString?

    override func getEventDescrption() -> NSAttributedString {

        if let desc = _eventDescription {
            return desc
        }
        guard let payload: ZLIssueCommentEventPayloadModel = self.eventModel.payload as? ZLIssueCommentEventPayloadModel else {
            return super.getEventDescrption()
        }

        let str = "\(payload.action) comment on issue #\(payload.issue.number)\n\n  \(payload.issue.title)\n\nin \(self.eventModel.repo.name)"
        let attributedStr =  NSMutableAttributedString(string: str ,
                                                       attributes: [.foregroundColor: UIColor(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                    .font: UIFont.zlRegularFont(withSize: 15)])

        let issueRange = (str as NSString).range(of: "#\(payload.issue.number)")
        attributedStr.yy_setTextHighlight(issueRange,
                                          color: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                          backgroundColor: UIColor.clear) {(_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

            if let url = URL.init(string: payload.issue.html_url) {
                ZLUIRouter.openURL(url: url)
            }
        }

        let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
        attributedStr.yy_setTextHighlight(repoNameRange,
                                          color: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                          backgroundColor: UIColor.clear) {[weak weakSelf = self](_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

            if let repoFullName = weakSelf?.eventModel.repo.name,
               let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                vc.hidesBottomBarWhenPushed = true
                weakSelf?.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }

        _eventDescription = attributedStr

        return attributedStr
    }

    override var zm_cellReuseIdentifier: String {
        return "ZLIssueCommentEventTableViewCell"
    }

    override func zm_onCellSingleTap() {

        guard let payload: ZLIssueCommentEventPayloadModel = self.eventModel.payload as? ZLIssueCommentEventPayloadModel else {
            return
        }

        if let url = URL(string: payload.issue.html_url) {
            ZLUIRouter.openURL(url: url)
        }

    }

    override func zm_clearCache() {
        self._eventDescription = nil
        self._commentBody = nil
    }

}

extension ZLIssueCommentEventTableViewCellData {
    func getIssueCommentBody() -> NSAttributedString {

        if self._commentBody == nil {

              guard let payload: ZLIssueCommentEventPayloadModel = self.eventModel.payload as? ZLIssueCommentEventPayloadModel else {
                  return NSAttributedString.init()
              }

              self._commentBody = NSAttributedString.init(string: payload.comment.body ?? "",
                                                          attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                                       .foregroundColor: UIColor.lightGray])
          }

          return self._commentBody ?? NSAttributedString.init()

    }
}
