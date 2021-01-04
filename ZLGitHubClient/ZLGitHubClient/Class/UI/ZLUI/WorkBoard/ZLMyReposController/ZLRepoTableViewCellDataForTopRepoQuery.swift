//
//  ZLRepoTableViewCellDataForTopRepoQuery.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/24.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoTableViewCellDataForTopRepoQuery: ZLGithubItemTableViewCellData {
    
    var data : ViewerTopRepositoriesQuery.Data.Viewer.TopRepository.Node
    
    // view
    weak var cell : ZLRepositoryTableViewCell?
    
    init(data : ViewerTopRepositoriesQuery.Data.Viewer.TopRepository.Node){
        self.data = data;
        super.init()
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
        let repoInfoVC = ZLRepoInfoController(repoFullName: data.nameWithOwner)
        repoInfoVC.hidesBottomBarWhenPushed = true
        self.viewController?.navigationController?.pushViewController(repoInfoVC, animated: true)
    }
}

extension ZLRepoTableViewCellDataForTopRepoQuery : ZLRepositoryTableViewCellDelegate {
    
    func onRepoAvaterClicked() -> Void{
        if let userInfoVC = ZLUIRouter.getUserInfoViewController(self.data.owner.login,type: ZLGithubUserType_User){
            userInfoVC.hidesBottomBarWhenPushed = true
            self.viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
        }
    }
    
    func getOwnerAvatarURL() -> String?{
        return self.data.owner.avatarUrl
    }

    func getRepoFullName() -> String?{
        return self.data.nameWithOwner
    }
    
    func getRepoName() -> String?{
        return self.data.name
    }
    
    func getOwnerName() -> String?{
        return self.data.owner.login
    }
    
    func getRepoMainLanguage() -> String?{
        return self.data.primaryLanguage?.name
    }
    
    func getRepoDesc() -> String?{
        return self.data.description
    }
    
    func isPriva() -> Bool{
        return self.data.isPrivate
    }
    func starNum() -> Int{
        return self.data.stargazerCount
    }
    
    func forkNum() -> Int{
        return self.data.forkCount
    }
    
}
