//
//  ZLRepositoryTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/10.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objcMembers class ZLRepositoryTableViewCellData: ZLGithubItemTableViewCellData {
    
    var data : ZLGithubRepositoryModel
    let needPullData : Bool
    
    // view
    weak var cell : ZLRepositoryTableViewCell?
    
    init(data : ZLGithubRepositoryModel, needPullData : Bool){
        self.needPullData = needPullData;
        self.data = data;
        super.init()
        if self.needPullData == true {
            self.getRepoInfoFromServer()
        }
    }
    
    convenience init(data : ZLGithubRepositoryModel){
        self.init(data: data, needPullData: false)
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let cell : ZLRepositoryTableViewCell = targetView as? ZLRepositoryTableViewCell else{
            return
        }
        
        cell.fillWithData(data: self)
        self.cell = cell
    }
    
    override func getCellHeight() -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLRepositoryTableViewCell"
    }
    
    override func onCellSingleTap() {
        if let vc = ZLUIRouter.getRepoInfoViewController(self.data) {
            vc.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func getOwnerAvatarFromServer() {
        ZLServiceManager.sharedInstance.userServiceModel?.getUserAvatar(withLoginName: self.data.owner?.loginName ?? "", serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel) in
            if let self = self,
               resultModel.result == true,
               let avatarUrl = resultModel.data as? String {
                self.data.owner?.avatar_url = avatarUrl
                if self.cell?.delegate === self{
                    self.cell?.fillWithData(data: self)
                }
                
            }
        }
    }
    
    
    func getRepoInfoFromServer() {
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoInfo(withFullName: self.data.full_name ?? "",
                                                                      serialNumber: NSString.generateSerialNumber())
        {[weak self](resultModel : ZLOperationResultModel) in
            
            if let self = self,
               resultModel.result == true,
               let model : ZLGithubRepositoryModel = resultModel.data as? ZLGithubRepositoryModel {
                self.data = model
                if self.cell?.delegate === self{
                    self.cell?.fillWithData(data: self)
                }
            }
        }
    }
    
    
}


extension ZLRepositoryTableViewCellData : ZLRepositoryTableViewCellDelegate
{
    func onRepoAvaterClicked() {
        
        if let login = data.owner?.loginName,
           let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName: login){
            userInfoVC.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
        }
    }
    
    func getOwnerAvatarURL() -> String?
    {
        return self.data.owner?.avatar_url
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
        return self.data.owner?.loginName
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
        return Int(self.data.forks_count)
    }
    
    func hasLongPressAction() -> Bool {
        if let html_url = data.html_url,
           let _ = URL(string: html_url) {
            return true
        }
        return false
    }
    
    func longPressAction(view: UIView) {
        if let html_url = data.html_url,
           let url = URL(string: html_url),
        let vc = viewController {
            view.showShareMenu(title: html_url, url: url, sourceViewController: vc)
        }
    }
    
}
