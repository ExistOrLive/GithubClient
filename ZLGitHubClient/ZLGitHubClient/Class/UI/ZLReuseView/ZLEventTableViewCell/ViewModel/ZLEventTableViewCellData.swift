//
//  ZLEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by ZM on 2019/11/26.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLEventTableViewCellData: ZLGithubItemTableViewCellData {
    
    let eventModel : ZLGithubEventModel
    
    init(eventModel : ZLGithubEventModel)
    {
        self.eventModel = eventModel
        super.init()
    }
    
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let cell : ZLEventTableViewCell = targetView as? ZLEventTableViewCell else {
            return
        }
        
        var  showReportButton = ZLSharedDataManager.sharedInstance().configModel?.ReportFunction ?? true
        let currentLoginName = ZLServiceManager.sharedInstance.viewerServiceModel?.currentUserLoginName
        if  currentLoginName == "ExistOrLive1" ||
                currentLoginName == "existorlive3" ||
                currentLoginName == "existorlive11"{
            showReportButton = true
        }
        if currentLoginName == self.eventModel.actor.login {
            showReportButton = false
        }
        
        cell.hiddenReportButton(hidden: !showReportButton)
    
        cell.fillWithData(cellData: self)
        cell.delegate = self
    }
    
    override func getCellReuseIdentifier() -> String{
        return "ZLEventTableViewCell"
    }
    
    override func getCellHeight() -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    override  func onCellSingleTap() {
        if let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: self.eventModel.repo.name) {
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
}

// MARK : cellData
extension ZLEventTableViewCellData
{
    func getActorAvaterURL() -> String
    {
        return self.eventModel.actor.avatar_url
    }
    
    func getActorName() -> String
    {
        return self.eventModel.actor.login
    }
    
    func getTimeStr() -> String
    {
        let timeStr = NSString.init(format: "%@",(self.eventModel.created_at as NSDate?)?.dateLocalStrSinceCurrentTime() ?? "")
        return timeStr as String
    }
    
    @objc func getEventDescrption() -> NSAttributedString{
        return NSAttributedString.init(string: self.eventModel.eventDescription , attributes: [NSAttributedString.Key.foregroundColor:ZLRawColor(name: "ZLLabelColor3")!,NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 15.0)!])
    }
}


extension ZLEventTableViewCellData : ZLEventTableViewCellDelegate
{
    func onAvatarClicked() {
        if let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName:self.eventModel.actor.login){
            userInfoVC.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
        }
    }
    
    func onReportClicked() {
        let vc = ZLReportController.init()
        vc.loginName = self.eventModel.actor.login
        vc.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }


}
