//
//  ZLUserTableViewCellDataForViewerOrgs.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/22.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLUserTableViewCellDataForViewerOrgs: ZLGithubItemTableViewCellData {

    let data : ViewerOrgsQuery.Data.Viewer.Organization.Edge.Node
    
    init(data :  ViewerOrgsQuery.Data.Viewer.Organization.Edge.Node){
        self.data = data
        super.init()
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let cell : ZLUserTableViewCell = targetView as? ZLUserTableViewCell else
        {
            return
        }
        cell.fillWithData(data: self)
        cell.delegate = self
    }
    
    
    override func getCellReuseIdentifier() -> String {
        return "ZLUserTableViewCell";
    }
    
    override func getCellHeight() -> CGFloat {
        return 100.0;
    }
    
    override func onCellSingleTap() {
        if let orgInfoVC = ZLUIRouter.getUserInfoViewController(loginName: data.login){
            orgInfoVC.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(orgInfoVC, animated: true)
        }
    }
    
    override func getCellSwipeActions() -> UISwipeActionsConfiguration?{
        return nil
    }
    
    override func clearCache(){
        
    }
    
    
}

extension ZLUserTableViewCellDataForViewerOrgs : ZLUserTableViewCellDelegate {
    func getName() -> String? {
        return nil
    }
    
    func getLoginName() -> String? {
        return data.login
    }
    
    func getAvatarUrl() -> String? {
        return data.avatarUrl
    }
    
    func getCompany() -> String? {
        return nil
    }
    
    func getLocation() -> String? {
        return data.location
    }
    
    
}
