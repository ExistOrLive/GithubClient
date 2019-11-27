//
//  ZLEventTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by BeeCloud on 2019/11/26.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLEventTableViewCellData: ZLBaseViewModel {
    
    var eventModel : ZLGithubEventModel
    
    override init() {
        self.eventModel = ZLGithubEventModel()
        super.init()
    }
    
    convenience init(eventModel : ZLGithubEventModel)
    {
        self.init()
        self.eventModel = eventModel
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let cell : ZLEventTableViewCell = targetView as? ZLEventTableViewCell else {
            return
        }
        cell.fillWithData(cellData: self)
        cell.delegate = self
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
    
    func getEventDescrption() -> String
    {
        return self.eventModel.eventDescription
    }
}


extension ZLEventTableViewCellData : ZLEventTableViewCellDelegate
{
    func onAvatarClicked() {
        let vc = ZLUserInfoController.init(loginName: self.eventModel.actor.login, type: ZLGithubUserType_User)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onCellSingleTap() {
        let repoModel = ZLGithubRepositoryModel.init()
        repoModel.full_name = self.eventModel.repo.name;
        let vc = ZLRepoInfoController.init(repoInfoModel: repoModel)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
