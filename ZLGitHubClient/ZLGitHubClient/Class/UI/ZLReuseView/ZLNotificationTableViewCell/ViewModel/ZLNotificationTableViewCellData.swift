//
//  ZLNotificationTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/8.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZLUIUtilities
import ZLBaseExtension
import ZMMVVM

class ZLNotificationTableViewCellData: ZMBaseTableViewCellViewModel {

    // model
    let data: ZLGithubNotificationModel

    var attributedNotificationTitle: NSAttributedString?

    init(data: ZLGithubNotificationModel) {
        self.data = data
        super.init()
    }

   
    override var zm_cellReuseIdentifier: String {
        return "ZLNotificationTableViewCell"
    }

    override var zm_cellSwipeActions: UISwipeActionsConfiguration? {
        if self.data.unread {

            let action: UIContextualAction = UIContextualAction.init(style: UIContextualAction.Style.destructive, title: "Done", handler: {(_: UIContextualAction, _: UIView, block : @escaping (Bool) -> Void) in

                if let notificationId = self.data.id_Notification {

                    ZLProgressHUD.show()
                    ZLServiceManager.sharedInstance.eventServiceModel?.markNotificationReaded(withNotificationId: notificationId,
                                                                                              serialNumber: NSString.generateSerialNumber()) { [weak self](result: ZLOperationResultModel) in

                        block(true)
                        ZLProgressHUD.dismiss()

                        guard let self = self else {
                            return
                        }

                        if result.result == true {
                            self.data.unread = false
                            (zm_viewController as? ZLNotificationController)?.deleteCellData(cellData: self)
                        } else {
                            ZLToastView.showMessage("mark notification read failed")
                        }

                    }
                } else {
                    block(true)
                }
            })
            return UISwipeActionsConfiguration.init(actions: [action])

        } else {
            return nil
        }
    }

    override func zm_onCellSingleTap() {
        guard let apiURL = self.data.subject?.url,
              let view = zm_viewController?.view else {
            return
        }
        view.showProgressHUD()
        ZLServiceManager().additionServiceModel?.getHtmlURL(withApi: apiURL,
                                                            serialNumber: NSString.generateSerialNumber(),
                                                            completeHandle: { [weak view] result in
            guard let view else { return }
            view.dismissProgressHUD()
            if result.result,
                let htmlURL = (result.data as? [String:Any])?["html_url"] as? String,
               let url = URL(string: htmlURL){
                ZLUIRouter.openURL(url: url, animated: true)
            } else {
                if let errorModel = result.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
            }
        })
    }

}

extension ZLNotificationTableViewCellData {

    func getNotificationTitle() -> NSAttributedString {

        if let title = attributedNotificationTitle {
            return title
        }

        let url = URL.init(string: self.data.subject?.url ?? "")
        let notificationNumber = url?.lastPathComponent ?? ""
        UIColor.label(withName: "ZLLabelColor3")
        let attributedStr = NSMutableAttributedString(string: self.data.repository?.full_name ?? "",
                                                      attributes: [.foregroundColor: UIColor.init(cgColor: UIColor.label(withName: "ZLLabelColor3").cgColor),
                                                                   .font: UIFont.zlSemiBoldFont(withSize: 16)])

        if "Issue" == self.data.subject?.type ||
            "PullRequest" == self.data.subject?.type {
            let numStr  = NSMutableAttributedString(string: " #\(notificationNumber)",
                                                    attributes: [.foregroundColor: UIColor.init(cgColor: UIColor.label(withName: "ZLLabelColor4").cgColor),
                                                                 .font: UIFont.zlSemiBoldFont(withSize: 16)])

            attributedStr.append(numStr)
        }

        attributedStr.yy_setTextHighlight(NSRange.init(location: 0, length: attributedStr.length),
                                          color: nil ,
                                          backgroundColor: UIColor.init(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor)) {[weak weakSelf = self](_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in

            if let repoFullName = weakSelf?.data.repository?.full_name,
               let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
                vc.hidesBottomBarWhenPushed = true
                weakSelf?.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }

        return attributedStr
    }

    func getNotificationSubjectTitle() -> String {
        return self.data.subject?.title ?? ""
    }

    func getNotificationReason() -> String {
        return self.data.reason
    }

    func getNotificationTimeStr() -> String {
        return (self.data.updated_at as NSDate?)?.dateLocalStrSinceCurrentTime() ?? ""
    }

    func getNotificationSubjectType() -> String {
        return self.data.subject?.type ?? ""
    }
    
    func onNotificationTitleClicked() {
        if let repoFullName = self.data.repository?.full_name,
           let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

