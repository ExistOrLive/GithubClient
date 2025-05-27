//
//  ZLIssueEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService

class ZLIssueEventTableViewCellData: ZLEventTableViewCellData {

    private var _eventDescription: NSAttributedString?
    private var _issueBody: NSAttributedString?

    override func getEventDescrption() -> NSAttributedString {

        if let desc = _eventDescription {
            return desc
        }

        guard let payload: ZLIssueEventPayloadModel = self.eventModel.payload as? ZLIssueEventPayloadModel else {
            return super.getEventDescrption()
        }

        let str = "\(payload.action) issue #\(payload.issue.number)\n\n  \(payload.issue.title)\n\nin \(self.eventModel.repo.name)"
        let attributedStr =  NSMutableAttributedString(string: str ,
                                                       attributes: [.foregroundColor: UIColor.init(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                    .font: UIFont.zlRegularFont(withSize: 15)])

        let issueRange = (str as NSString).range(of: "#\(payload.issue.number)")
        attributedStr.yy_setTextHighlight(issueRange,
                                          color: UIColor.init(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                          backgroundColor: UIColor.clear) {[weak self](_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

            if let url = URL.init(string: payload.issue.html_url) {
                ZLUIRouter.openURL(url: url)
            }

        }

        let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
        attributedStr.yy_setTextHighlight(repoNameRange,
                                          color: UIColor.init(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
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
        return "ZLIssueEventTableViewCell"
    }


    override func zm_onCellSingleTap() {

        guard let payload: ZLIssueEventPayloadModel = self.eventModel.payload as? ZLIssueEventPayloadModel else {
            return
        }

        if let url = URL(string: payload.issue.html_url) {
            ZLUIRouter.openURL(url: url)
        }
    }

    override func zm_clearCache() {
        self._eventDescription = nil
        self._issueBody = nil
    }

}

extension ZLIssueEventTableViewCellData {
    func getIssueBody() -> NSAttributedString {

        if self._issueBody == nil {
            guard let payload: ZLIssueEventPayloadModel = self.eventModel.payload as? ZLIssueEventPayloadModel else {
                return NSAttributedString.init()
            }

            self._issueBody = NSAttributedString(string: payload.issue.body,
                                                 attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                              .foregroundColor: UIColor.lightGray])
        }

        return self._issueBody ?? NSAttributedString.init()

    }
}
