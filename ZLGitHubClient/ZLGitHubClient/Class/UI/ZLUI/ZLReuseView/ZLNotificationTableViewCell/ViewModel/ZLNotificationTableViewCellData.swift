//
//  ZLNotificationTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/8.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLNotificationTableViewCellData: ZLGithubItemTableViewCellData {
    
    var data : ZLGithubNotificationModel
    
    var showAllNotification : Bool = false
    
    init(data : ZLGithubNotificationModel){
        self.data = data;
        super.init()
    }
        
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let cell : ZLNotificationTableViewCell = targetView as? ZLNotificationTableViewCell else{
            return
        }
        
        cell.fillWithData(data: self)
        cell.delegate = self
    }
    
    override func getCellHeight() -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLNotificationTableViewCell"
    }
    
    override func getCellSwipeActions() -> UISwipeActionsConfiguration? {
        if self.data.unread {
            
            let action : UIContextualAction = UIContextualAction.init(style: UIContextualAction.Style.destructive, title: "Done", handler: {(action : UIContextualAction, view : UIView , block : @escaping (Bool) -> Void) in
                
                if self.data.id_Notification != nil {
                    SVProgressHUD.show()
                    weak var weakSelf = self
                    ZLNotificationServiceModel.sharedInstance().markNotificationRead(notificationId: self.data.id_Notification!, serialNumber: NSString.generateSerialNumber(), completeHandle: {(result : ZLOperationResultModel) in
                        
                        block(true)
                        SVProgressHUD.dismiss()
                        if result.result == true {
                            weakSelf?.data.unread = false
                            guard let superViewModel : ZLNotificationViewModel = self.super as? ZLNotificationViewModel else {
                                return
                            }
                            superViewModel.deleteCellData(cellData: weakSelf!)
                        } else {
                            ZLToastView.showMessage("mark notification read failed")
                        }
                        
                    })
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
        var url : URL? = nil
        if "Issue" == self.data.subject?.type {
            let tmpurl = URL.init(string: self.data.subject?.url ?? "")
            let notificationNumber = tmpurl?.lastPathComponent ?? ""
            url = URL.init(string: "https://github.com/\(self.data.repository?.full_name ?? "")/issues/\(notificationNumber)")
        } else if "PullRequest" == self.data.subject?.type {
            let tmpurl = URL.init(string: self.data.subject?.url ?? "")
            let notificationNumber = tmpurl?.lastPathComponent ?? ""
            url = URL.init(string: "https://github.com/\(self.data.repository?.full_name ?? "")/pull/\(notificationNumber)")
        } else if "RepositoryVulnerabilityAlert" == self.data.subject?.type {
            url = URL.init(string: "https://github.com/\(self.data.repository?.full_name ?? "")/security")
        }
        let webVC = ZLWebContentController.init()
        webVC.requestURL = url
        webVC.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(webVC, animated: true)
    }
    
}


extension ZLNotificationTableViewCellData {
    
    func getNotificationTitle() -> NSAttributedString {
        
        let url = URL.init(string: self.data.subject?.url ?? "")
        let notificationNumber = url?.lastPathComponent ?? ""
        
        let attributedStr : NSMutableAttributedString = NSMutableAttributedString.init(string: self.data.repository?.full_name ?? "", attributes: [NSAttributedString.Key.foregroundColor:ZLRGBValue_H(colorValue: 0x333333),NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCSemiBold, size: 16) ?? UIFont.systemFont(ofSize: 16)])
        
        if "Issue" == self.data.subject?.type ||
            "PullRequest" == self.data.subject?.type{
            let numStr : NSAttributedString = NSMutableAttributedString.init(string: " #\(notificationNumber)", attributes: [NSAttributedString.Key.foregroundColor:ZLRGBValue_H(colorValue: 0x586069),NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCSemiBold, size: 16) ?? UIFont.systemFont(ofSize: 16)])
            
            attributedStr.append(numStr)
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

extension ZLNotificationTableViewCellData : ZLNotificationTableViewCellDelegate {
    func onNotificationTitleClicked() {
        let repovc = ZLRepoInfoController.init(repoFullName: self.data.repository?.full_name ?? "")
        repovc.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(repovc, animated: true)
    }
}
