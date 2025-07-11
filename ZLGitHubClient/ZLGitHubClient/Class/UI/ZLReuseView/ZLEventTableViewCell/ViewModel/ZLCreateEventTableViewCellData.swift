//
//  ZLCreateEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/5.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService

/**
 master_branch = "master";
 pusher_type = "user";
 description = "Github客户端 iOS";
 ref_type = "tag";
 ref = "V1.0.1.7";
 */
class ZLCreateEventTableViewCellData: ZLEventTableViewCellData {

    private var _eventDescription: NSAttributedString?

    override var zm_cellReuseIdentifier: String {
        return "ZLEventTableViewCell"
    }

    override func zm_clearCache() {
        self._eventDescription = nil
    }

    override func getEventDescrption() -> NSAttributedString {

        if let desc = _eventDescription {
            return desc
        }

        guard let payload: ZLCreateEventPayloadModel = self.eventModel.payload as? ZLCreateEventPayloadModel else {
            return super.getEventDescrption()
        }

        if payload.ref_type == .repository {

            let str =  "created repository \(self.eventModel.repo.name)"
            let attributedString = NSMutableAttributedString(string: str ,
                                                             attributes: [.foregroundColor: UIColor(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                          .font: UIFont.zlRegularFont(withSize: 15)])

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

            self._eventDescription = attributedString
            return attributedString

        } else if payload.ref_type == .tag {

            let str =  "created tag \(payload.ref)\n\nin \(self.eventModel.repo.name)"
            let attributedString = NSMutableAttributedString.init(string: str ,
                                                                  attributes: [.foregroundColor: UIColor(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                               .font: UIFont.zlRegularFont(withSize: 15)])

            let refRange = (str as NSString).range(of: payload.ref)
            attributedString.yy_setTextHighlight(refRange,
                                                 color: UIColor.init(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                                 backgroundColor: UIColor.clear) {[weak self](_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

                let urlStr = "https://github.com/\(self?.eventModel.repo.name ?? "")/releases/tag/\(payload.ref.urlPathEncoding)"
                if let url = URL(string: urlStr) {
                    ZLUIRouter.openURL(url: url)
                }
            }

            let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
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

        } else if payload.ref_type == .branch {

            let str =  "created branch \(payload.ref)\n\nin \(self.eventModel.repo.name)"
            let attributedString = NSMutableAttributedString(string: str ,
                                                             attributes: [.foregroundColor: UIColor.init(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                          .font: UIFont.zlRegularFont(withSize: 15)])

            let refRange = (str as NSString).range(of: payload.ref)
            attributedString.yy_setTextHighlight(refRange,
                                                 color: UIColor.init(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                                 backgroundColor: UIColor.clear) {(_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in
            }

            let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
            attributedString.yy_setTextHighlight(repoNameRange,
                                                 color: UIColor.init(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                                 backgroundColor: UIColor.clear) {[weak weakSelf = self](_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

                if let repoFullName = weakSelf?.eventModel.repo.name,
                   let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                    vc.hidesBottomBarWhenPushed = true
                    weakSelf?.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
                }
            }

            self._eventDescription = attributedString
            return attributedString

        } else {
            return super.getEventDescrption()
        }
    }

}
