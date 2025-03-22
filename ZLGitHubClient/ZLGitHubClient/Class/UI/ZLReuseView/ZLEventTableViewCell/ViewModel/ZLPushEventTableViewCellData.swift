//
//  ZLPushEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/1.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLBaseExtension
import ZLGitRemoteService

class ZLPushEventTableViewCellData: ZLEventTableViewCellData {

    private var _commitInfoAttributedStr: NSAttributedString?
    private var _eventDescrition: NSAttributedString?

    override func getEventDescrption() -> NSAttributedString {

        if let eventDescrition = self._eventDescrition {
            return eventDescrition
        }

        let str =  String(format: "%@ pushed to %@", self.eventModel.actor.display_login, self.eventModel.repo.name)

        let attributedString = NSMutableAttributedString(string: str ,
                                                         attributes: [.foregroundColor: ZLRawLabelColor(name: "ZLLabelColor3"),
                                                                      .font: UIFont.zlRegularFont(withSize: 15)])

        let loginNameRange = (str as NSString).range(of: self.eventModel.actor.display_login)
        attributedString.yy_setTextHighlight(loginNameRange,
                                             color: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                             backgroundColor: UIColor.clear) {[weak self](_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

            if let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName: self?.eventModel.actor.login ?? "") {
                userInfoVC.hidesBottomBarWhenPushed = true
                self?.zm_viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
            }
        }

        let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
        attributedString.yy_setTextHighlight(repoNameRange,
                                             color: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                             backgroundColor: UIColor.clear) {[weak self](_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

            if let repoFullName = self?.eventModel.repo.name,
               let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                vc.hidesBottomBarWhenPushed = true
                self?.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }

        _eventDescrition = attributedString

        return attributedString
    }

    override var zm_cellReuseIdentifier: String {
        return "ZLPushEventTableViewCell"
    }

    override func zm_clearCache() {
        self._eventDescrition = nil
        self._commitInfoAttributedStr = nil
    }

}

extension ZLPushEventTableViewCellData {

     func commitNum() -> Int {
         guard let pushEventPayload: ZLPushEventPayloadModel  = self.eventModel.payload as? ZLPushEventPayloadModel else {
             return 0
         }

         return pushEventPayload.commits.count
     }

     func branch() -> String {
         guard let pushEventPayload: ZLPushEventPayloadModel  = self.eventModel.payload as? ZLPushEventPayloadModel else {
             return ""
         }
         return pushEventPayload.ref
     }

     func commitShaForIndex(index: Int) -> String {
         guard let pushEventPayload: ZLPushEventPayloadModel  = self.eventModel.payload as? ZLPushEventPayloadModel else {
             return ""
         }

         return String(pushEventPayload.commits[index].sha.prefix(7))
     }

     func commitMessageForIndex(index: Int) -> String {
         guard let pushEventPayload: ZLPushEventPayloadModel  = self.eventModel.payload as? ZLPushEventPayloadModel else {
             return ""
         }
         return pushEventPayload.commits[index].message
     }

     func commitAuthorForIndex(index: Int) -> String {
         guard let pushEventPayload: ZLPushEventPayloadModel  = self.eventModel.payload as? ZLPushEventPayloadModel else {
             return ""
         }
         return pushEventPayload.commits[index].author
     }

    func commitInfoAttributedStr() -> NSAttributedString {

        if let commitInfoAttributedStr = _commitInfoAttributedStr {
            return commitInfoAttributedStr
        }

        let str: NSMutableAttributedString  = NSMutableAttributedString()
        let paraghStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paraghStyle.lineSpacing = 5
        paraghStyle.lineBreakMode = .byClipping

        let commitNumStr = NSAttributedString(string: "\(self.commitNum()) commits to ",
                                              attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                           .foregroundColor: UIColor(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor)])
        str.append(commitNumStr)

        let branchStr: NSAttributedString = NSAttributedString(string: "\(self.branch())\n",
                                                                attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                                            .foregroundColor: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor2").cgColor)])
        str.append(branchStr)

        if self.commitNum() > 0 {

            for i in 0...(min(1, self.commitNum() - 1)) {

                let str1 = NSAttributedString(string: "\(self.commitShaForIndex(index: i)) ",
                                              attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                          .foregroundColor: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor2").cgColor)])
                str.append(str1)

                let str2 = NSAttributedString(string: "\(self.commitMessageForIndex(index: i))\n",
                                              attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                           .foregroundColor: UIColor(cgColor: UIColor.label(withName: "ZLLabelColor2").cgColor)])
                str.append(str2)
            }

            if self.commitNum() > 2 {

                let str1 = NSAttributedString(string: "\(self.commitNum() - 2) more commits >> \n",
                                              attributes: [.font: UIFont.zlRegularFont(withSize: 15),
                                                           .foregroundColor: UIColor(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor)])

                str.append(str1)
            }
        }

        str.addAttribute(NSAttributedString.Key.paragraphStyle,
                         value: paraghStyle,
                         range: NSRange.init(location: 0, length: str.length))

        self._commitInfoAttributedStr = str

        return str
    }
}
