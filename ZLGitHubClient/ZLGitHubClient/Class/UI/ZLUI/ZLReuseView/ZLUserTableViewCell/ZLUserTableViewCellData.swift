//
//  ZLUserTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/9.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLUserTableViewCellData: ZLGithubItemTableViewCellData {
    
    let userModel : ZLGithubUserModel
    
    weak var cell : ZLUserTableViewCell?
    
    init(userModel : ZLGithubUserModel){
        self.userModel = userModel
        super.init()
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let cell : ZLUserTableViewCell = targetView as? ZLUserTableViewCell else
        {
            return
        }
        self.cell = cell
        cell.fillWithData(data: self)
        cell.delegate = self
    }
    
    override func getCellHeight() -> CGFloat
    {
        return 100.0
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLUserTableViewCell"
    }
}

extension ZLUserTableViewCellData{
    
    func getName() -> String? {
        return self.userModel.name
    }
    
    func getLoginName() -> String? {
        return self.userModel.loginName
    }
    
    func getAvatarUrl() -> String? {
        return self.userModel.avatar_url
    }
    
    func getCompany() -> String? {
        return self.userModel.company
    }
    
    func getLocation() -> String? {
        return self.userModel.location
    }
}


extension ZLUserTableViewCellData: ZLUserTableViewCellDelegate{
  
    func onUserContainerViewClicked() {
        let userInfoVC : ZLUserInfoController = ZLUserInfoController.init(loginName: self.userModel.loginName, type: self.userModel.type)
        userInfoVC.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
    }
}
