//
//  ZLMemberEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService

class ZLMemberEventTableViewCellData: ZLEventTableViewCellData {

    private var _eventDescription: NSAttributedString?

    override func getEventDescrption() -> NSAttributedString {

        if let desc = _eventDescription {
            return desc
        }

        guard let payload: ZLMemberEventPayloadModel = self.eventModel.payload as? ZLMemberEventPayloadModel else {
            return super.getEventDescrption()
        }

        let str = "\(payload.action) collaborator \(payload.member.loginName ?? "")\n\nto \(self.eventModel.repo.name)"
        let attributedStr =  NSMutableAttributedString(string: str ,
                                                       attributes: [.foregroundColor: UIColor(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                    .font: UIFont.zlRegularFont(withSize: 15)])

        let memberRange = (str as NSString).range(of: "\(payload.member.loginName ?? "")")
        attributedStr.yy_setTextHighlight(memberRange,
                                          color: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                          backgroundColor: UIColor.clear) {[weak self](_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

            if let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName: payload.member.loginName ?? "") {

                userInfoVC.hidesBottomBarWhenPushed = true
                self?.zm_viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
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

    override func zm_clearCache() {
        self._eventDescription = nil
    }

}
