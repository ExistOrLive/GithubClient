//
//  ZLRepositoryTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/10.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objcMembers class ZLRepositoryTableViewCellData: ZLGithubItemTableViewCellData {
    
    let data : ZLGithubRepositoryModel
    
    private var _cellHeight : CGFloat?
    
    init(data : ZLGithubRepositoryModel)
    {
        self.data = data;
        super.init()
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let cell : ZLRepositoryTableViewCell = targetView as? ZLRepositoryTableViewCell else
        {
            return
        }
        
        cell.fillWithData(data: self)
        cell.delegate = self
    }
    
    override func getCellHeight() -> CGFloat
    {
        if self._cellHeight != nil
        {
            return self._cellHeight!
        }
        
        let attributeStr = NSAttributedString.init(string: self.data.desc_Repo ?? "", attributes: [NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 12)!])
        let rect = attributeStr.boundingRect(with: CGSize.init(width: 250, height: ZLSCreenHeight), options: .usesLineFragmentOrigin, context: nil)
        
        self._cellHeight = rect.size.height + 150
      
        return self._cellHeight!
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLRepositoryTableViewCell"
    }
    
    
}


extension ZLRepositoryTableViewCellData
{
    func getOwnerAvatarURL() -> String?
    {
        return self.data.owner.avatar_url
    }
    
    func getRepoFullName() -> String?
    {
        return self.data.full_name
    }
    
    func getRepoName() -> String?
    {
        return self.data.name
    }
    
    func getOwnerName() -> String?
    {
        return self.data.owner.loginName
    }
    
    func getRepoMainLanguage() -> String?
    {
        return self.data.language
    }
    
    func getRepoDesc() -> String?
    {
        return self.data.desc_Repo
    }
    
    func isPriva() -> Bool
    {
        return self.data.isPriva
    }
    
    func starNum() -> Int
    {
        return Int(self.data.stargazers_count)
    }
    
    func forkNum() -> Int
    {
        return Int(self.data.forks)
    }
    
    
}


extension ZLRepositoryTableViewCellData : ZLRepositoryTableViewCellDelegate
{
    func onRepoAvaterClicked() {
        let userInfoVC = ZLUserInfoController.init(loginName: self.data.owner.loginName, type: self.data.owner.type)
        userInfoVC.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
    }
        
    func onRepoContainerViewClicked()
    {
        let repoInfoVC = ZLRepoInfoController.init(repoInfoModel: self.data)
        repoInfoVC.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(repoInfoVC, animated: true)
    }
}
