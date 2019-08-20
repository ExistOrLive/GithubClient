//
//  ZLRepoInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

enum ZLRepoInfoItemType : Int {
    case file                   // 仓库文件
    case pullRequest            // pullrequest
    case branch                 // 分支
}

class ZLRepoInfoViewModel: ZLBaseViewModel {
    
    // view
    private var repoInfoView : ZLRepoInfoView?
    
    // model
    private var repoInfoModel : ZLGithubRepositoryModel?
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if !(targetView is ZLRepoInfoView)
        {
            ZLLog_Warn("targetView is not ZLRepoInfoView")
            return
        }
        
        self.repoInfoView = targetView as? ZLRepoInfoView
        self.repoInfoView?.tableView.delegate = self
        self.repoInfoView?.tableView.dataSource = self
        
        guard let repoInfoModel: ZLGithubRepositoryModel = targetModel as? ZLGithubRepositoryModel else
        {
            ZLLog_Warn("targetModel is not ZLGithubRepositoryModel,so return")
            return
        }
        
        self.setViewDataForRepoInfoView(model: repoInfoModel, view: self.repoInfoView!)
        
    }
    
    
    @IBAction func onBackButtonClicked(_ sender: Any) {
        
        self.viewController?.navigationController?.popViewController(animated: true)
        
    }
}


extension ZLRepoInfoViewModel
{
    func setViewDataForRepoInfoView(model:ZLGithubRepositoryModel, view:ZLRepoInfoView)
    {
        self.repoInfoModel = model
        
        view.headerView?.headImageView.sd_setImage(with: URL.init(string: model.owner.avatar_url), placeholderImage: nil);
        view.headerView?.repoNameLabel.text = model.name
        view.headerView?.descLabel.text = model.desc_Repo
        view.headerView?.issuesNumLabel.text = "\(model.open_issues)"
        view.headerView?.watchersNumLabel.text = "\(model.watchers)"
        view.headerView?.starsNumLabel.text = "\(model.stargazers_count)"
        view.headerView?.forksNumLabel.text = "\(model.forks)"
    }
}

// MARK: UITableViewDelegate,UITableViewDataSource
extension ZLRepoInfoViewModel: UITableViewDelegate,UITableViewDataSource
{
    static let itemsTypes: [ZLRepoInfoItemType] = [.file, .pullRequest, .branch]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ZLRepoInfoViewModel.itemsTypes.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell : ZLRepoInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLRepoInfoTableViewCell", for: indexPath) as! ZLRepoInfoTableViewCell
        
        if(indexPath.row == ZLRepoInfoViewModel.itemsTypes.count - 1)
        {
           tableViewCell.singleLineView.isHidden = true
        }
        else
        {
            tableViewCell.singleLineView.isHidden = false
        }
        
        let itemType = ZLRepoInfoViewModel.itemsTypes[indexPath.row]
        
        switch(itemType)
        {
        case .file:do{
            tableViewCell.repoInfoTypeLabel.text = ZLLocalizedString(string: "文件", comment: "file")
            tableViewCell.repoInfoDetailLabel.text = self.repoInfoModel?.language
            }
        case .pullRequest:do{
            tableViewCell.repoInfoTypeLabel.text = ZLLocalizedString(string: "拉取请求", comment: "pull request")
            tableViewCell.repoInfoDetailLabel.text = ""
            }
        case .branch:do{
            tableViewCell.repoInfoTypeLabel.text = ZLLocalizedString(string: "分支", comment: "file")
            tableViewCell.repoInfoDetailLabel.text = self.repoInfoModel?.default_branch
            }
        }
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
}
