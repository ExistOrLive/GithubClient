//
//  ZLNotificationTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/8.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLNotificationTableViewCellData: ZLGithubItemTableViewCellData {

    // model
    var data: ZLGithubNotificationModel

    var attributedNotificationTitle: NSAttributedString?

    init(data: ZLGithubNotificationModel) {
        self.data = data
        super.init()
    }

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {

        guard let cell: ZLNotificationTableViewCell = targetView as? ZLNotificationTableViewCell else {
            return
        }

        cell.fillWithData(data: self)
        cell.delegate = self
    }

    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }

    override func getCellReuseIdentifier() -> String {
        return "ZLNotificationTableViewCell"
    }

    override func getCellSwipeActions() -> UISwipeActionsConfiguration? {
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
                            guard let superViewModel: ZLNotificationViewModel = self.super as? ZLNotificationViewModel else {
                                return
                            }
                            superViewModel.deleteCellData(cellData: self)
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

    override func onCellSingleTap() {
        guard let originURL = URL.init(string: self.data.subject?.url ?? "") else {
            return
        }

        var url: URL?

        if "Issue" == self.data.subject?.type {
            let notificationNumber = Int(originURL.lastPathComponent) ?? 0
            ZLUIRouter.navigateVC(key: ZLUIRouter.IssueInfoController,
                                  params: ["login": self.data.repository?.owner?.loginName ?? "" ,
                                           "repoName": self.data.repository?.name ?? "",
                                           "number": notificationNumber])
            return
        } else if "PullRequest" == self.data.subject?.type {
            let notificationNumber = Int(originURL.lastPathComponent) ?? 0
            ZLUIRouter.navigateVC(key: ZLUIRouter.PRInfoController,
                                  params: ["login": self.data.repository?.owner?.loginName ?? "" ,
                                           "repoName": self.data.repository?.name ?? "",
                                           "number": notificationNumber])
            return
        } else if "RepositoryVulnerabilityAlert" == self.data.subject?.type {
            url = URL.init(string: "https://github.com/\(self.data.repository?.full_name ?? "")/security")
        } else if "Discussion" == self.data.subject?.type {
            let discussionNumber = originURL.lastPathComponent
            url = URL.init(string: "https://github.com/\(self.data.repository?.full_name ?? "")/discussions/\(discussionNumber)")
        } else if "Release" == self.data.subject?.type {
            url = URL.init(string: "https://github.com/\(self.data.repository?.full_name ?? "")/releases")
        } else if "Commit" == self.data.subject?.type {
            let commitIndex = originURL.lastPathComponent
            url = URL.init(string: "https://github.com/\(self.data.repository?.full_name ?? "")/commit/\(commitIndex)")
        }

        if let url = url {
            ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,
                                  params: ["requestURL": url])
        }
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
                weakSelf?.viewController?.navigationController?.pushViewController(vc, animated: true)
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

}

extension ZLNotificationTableViewCellData: ZLNotificationTableViewCellDelegate {
    func onNotificationTitleClicked() {
        if let repoFullName = self.data.repository?.full_name,
           let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
