//
//  ZLForkEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/5.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService

class ZLForkEventTableViewCellData: ZLEventTableViewCellData {

    private var _eventDescription: NSAttributedString?

    override func getCellReuseIdentifier() -> String {
        return "ZLEventTableViewCell"
    }

    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }

    override func clearCache() {
        self._eventDescription = nil
    }

    override func getEventDescrption() -> NSAttributedString {

        if let desc = _eventDescription {
            return desc
        }

        guard let payload: ZLForkEventPayloadModel = self.eventModel.payload as? ZLForkEventPayloadModel else {
            return super.getEventDescrption()
        }

        let str = "forked \(payload.forkee.full_name ?? "")\n\nfrom \(self.eventModel.repo.name)"

        let attributedString = NSMutableAttributedString(string: str ,
                                                         attributes: [.foregroundColor: UIColor.init(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                      .font: UIFont.zlRegularFont(withSize: 15)])

        let repoNameRange = (str as NSString).range(of: self.eventModel.repo.name)
        attributedString.yy_setTextHighlight(repoNameRange,
                                             color: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                             backgroundColor: UIColor.clear) {[weak self](_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

            if let repoFullName = self?.eventModel.repo.name,
               let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {

                vc.hidesBottomBarWhenPushed = true
                self?.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }

        let forkeeRepoNameRange = (str as NSString).range(of: payload.forkee.full_name ?? "")
        attributedString.yy_setTextHighlight(forkeeRepoNameRange,
                                             color: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                             backgroundColor: UIColor.clear) {[weak self](_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in
            
            if let repoFullName = payload.forkee.full_name,
               let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                vc.hidesBottomBarWhenPushed = true
                self?.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }

        self._eventDescription = attributedString
        return attributedString

    }

}
