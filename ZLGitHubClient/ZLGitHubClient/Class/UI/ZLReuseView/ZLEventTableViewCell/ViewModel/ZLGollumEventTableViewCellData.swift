//
//  ZLGollumEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLGollumEventTableViewCellData: ZLEventTableViewCellData {

    private var _eventDescription: NSAttributedString?

    override func getEventDescrption() -> NSAttributedString {

        if let desc = _eventDescription {
            return desc
        }

        guard let payload: ZLGollumEventPayloadModel = self.eventModel.payload as? ZLGollumEventPayloadModel else {
            return super.getEventDescrption()
        }

        let attributedStr: NSMutableAttributedString  = NSMutableAttributedString()

        for pageModel in payload.pages {

            let str = "\(pageModel.action) wiki page \(pageModel.page_name)\n"
            let tmpAttributedStr =  NSMutableAttributedString.init(string: str ,
                                                                   attributes: [.foregroundColor: UIColor(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                                .font: UIFont.zlRegularFont(withSize: 15)])

            let pageNameRange = (str as NSString).range(of: pageModel.page_name)
            tmpAttributedStr.yy_setTextHighlight(pageNameRange,
                                                 color: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                                 backgroundColor: UIColor.clear) {(_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

                if let url = URL.init(string: pageModel.html_url) {
                    ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,
                                          params: ["requestURL": url])
                }
            }
            attributedStr.append(tmpAttributedStr)
        }

        let str = "\nin \(self.eventModel.repo.name)"
        let tmpAttributedStr =  NSMutableAttributedString(string: str ,
                                                          attributes: [.foregroundColor: UIColor(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                       .font: UIFont.zlRegularFont(withSize: 15)])

        let repoRange = (str as NSString).range(of: self.eventModel.repo.name)
        tmpAttributedStr.yy_setTextHighlight(repoRange,
                                             color: UIColor.init(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor),
                                             backgroundColor: UIColor.clear) {[weak self](_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

            if let repoFullName = self?.eventModel.repo.name,
               let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {

                vc.hidesBottomBarWhenPushed = true
                self?.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        attributedStr.append(tmpAttributedStr)

        _eventDescription = attributedStr

        return attributedStr
    }

    override func getCellReuseIdentifier() -> String {
        return "ZLEventTableViewCell"
    }

    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }

    override func clearCache() {
        self._eventDescription = nil
    }
}
