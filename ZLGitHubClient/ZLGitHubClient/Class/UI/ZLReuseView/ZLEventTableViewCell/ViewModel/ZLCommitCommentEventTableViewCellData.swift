//
//  ZLCommitCommentEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/5.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService

class ZLCommitCommentEventTableViewCellData: ZLEventTableViewCellData {

    private var _eventDescription: NSAttributedString?

    private var _commitBody: NSAttributedString?

    override func getEventDescrption() -> NSAttributedString {

        if let desc = _eventDescription {
            return desc
        }

        guard let payload = self.eventModel.payload as? ZLCommitCommentEventPayloadModel else {
            return super.getEventDescrption()
        }

        let loginName = payload.comment.user.loginName ?? ""
        let commit_id = String(payload.comment.commit_id.prefix(7))
        let repoFullName = self.eventModel.repo.name
        let str =  "\(loginName) commented on commit \(commit_id)\n\nin \(repoFullName)"

        let attributedString = NSMutableAttributedString(string: str ,
                                                         attributes: [.foregroundColor: UIColor(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                      .font: UIFont.zlRegularFont(withSize: 15)])

        let loginNameRange = (str as NSString).range(of: loginName)
        attributedString.yy_setTextHighlight(loginNameRange,
                                             color: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                             backgroundColor: UIColor.clear) {[weak self](_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

            if let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName: loginName) {
                userInfoVC.hidesBottomBarWhenPushed = true
                self?.zm_viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
            }
        }

        let commitRange = (str as NSString).range(of: commit_id)
        attributedString.yy_setTextHighlight(commitRange,
                                             color: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                             backgroundColor: UIColor.clear) {(_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

            let urlStr = "https://github.com/\(repoFullName)/commit/\(payload.comment.commit_id.urlPathEncoding)"
            if let url = URL(string: urlStr) {
                ZLUIRouter.openURL(url: url)
            }
        }

        let repoNameRange = (str as NSString).range(of: repoFullName)
        attributedString.yy_setTextHighlight(repoNameRange,
                                             color: UIColor.init(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                             backgroundColor: UIColor.clear) {[weak self](_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

            if let repoFullName = self?.eventModel.repo.name,
               let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                vc.hidesBottomBarWhenPushed = true
                self?.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }

        self._eventDescription = attributedString

        return attributedString
    }

    override var zm_cellReuseIdentifier: String {
        return "ZLCommitCommentEventTableViewCell"
    }

    override func zm_onCellSingleTap() {
        guard let payload = self.eventModel.payload as? ZLCommitCommentEventPayloadModel,
              let url =  URL.init(string: payload.comment.html_url) else {
            return
        }
        ZLUIRouter.openURL(url: url)
    }

    override func zm_clearCache() {
        self._eventDescription = nil
        self._commitBody = nil
    }

}

extension ZLCommitCommentEventTableViewCellData {

    func getCommitBody() -> NSAttributedString {

        if self._commitBody == nil {
            guard let payload  = self.eventModel.payload as? ZLCommitCommentEventPayloadModel else {
                return NSAttributedString.init()
            }

            self._commitBody = NSAttributedString(string: payload.comment.body ?? "",
                                                  attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                               .foregroundColor: UIColor(cgColor: UIColor.label(withName: "ZLLabelColor2").cgColor)])
        }

        return self._commitBody ?? NSAttributedString.init()
    }
}
