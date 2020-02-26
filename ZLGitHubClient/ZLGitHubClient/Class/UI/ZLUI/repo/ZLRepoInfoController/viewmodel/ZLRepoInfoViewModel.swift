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
    
    // 当前repo请求流水号
    private var serialNumber: String?
    
    
    deinit {
        ZLRepoServiceModel.shared().unRegisterObserver(self, name: ZLGetSpecifiedRepoInfoResult_Notification)
    }
    
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
        
        ZLRepoServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLGetSpecifiedRepoInfoResult_Notification)
        
        
        // 获取仓库的详细信息
        SVProgressHUD.show()
        self.serialNumber = NSString.generateSerialNumber() as String
        ZLRepoServiceModel.shared().getRepoInfo(withFullName: repoInfoModel.full_name, serialNumber: self.serialNumber!)
        
        // 加载readme
        self.loadREADME()
        
    }
}


extension ZLRepoInfoViewModel
{
    func setViewDataForRepoInfoView(model:ZLGithubRepositoryModel, view:ZLRepoInfoView)
    {
        self.repoInfoModel = model
        
        self.viewController?.title = model.name == nil ? "Repo" : model.name
        
        view.headerView?.headImageView.sd_setImage(with: URL.init(string: model.owner.avatar_url), placeholderImage: UIImage.init(named: "default_avatar"));
        view.headerView?.repoNameLabel.text = model.full_name
        view.headerView?.descLabel.text = model.desc_Repo
        view.headerView?.issuesNumLabel.text = "\(model.open_issues_count)"
        view.headerView?.watchersNumLabel.text = "\(model.subscribers_count)"
        view.headerView?.starsNumLabel.text = "\(model.stargazers_count)"
        view.headerView?.forksNumLabel.text = "\(model.forks_count)"
        
        guard let date : NSDate = model.updated_at as NSDate? else
        {
            return
        }
        
        let timeStr = NSString.init(format: "%@%@", ZLLocalizedString(string: "update at", comment: "更新于"),date.dateLocalStrSinceCurrentTime())
        view.headerView?.timeLabel.text = timeStr as String
        
    }
}

// MARK: README
extension ZLRepoInfoViewModel : UIWebViewDelegate
{
    func loadREADME()
    {
        guard let fullName = self.repoInfoModel?.full_name else
        {
            return;
        }
        
        ZLRepoServiceModel.shared().getRepoReadMeInfo(withFullName:fullName , serialNumber: NSString.generateSerialNumber(), completeHandle: { (resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false
            {
                let errorModel : ZLGithubRequestErrorModel = resultModel.data as! ZLGithubRequestErrorModel
                self.repoInfoView?.footerView?.markdownView.load(markdown: errorModel.message, enableImage: true)
            }
            else
            {
                let readModel : ZLGithubRepositoryReadMeModel = resultModel.data as! ZLGithubRepositoryReadMeModel
                guard let data : Data = Data.init(base64Encoded: readModel.content, options: .ignoreUnknownCharacters) else
                {
                    self.repoInfoView?.footerView?.markdownView.load(markdown: "parse error", enableImage: true)
                    return
                }
                
                let readMeStr = String.init(data: data, encoding: .utf8)
                self.repoInfoView?.footerView?.markdownView.load(markdown: readMeStr, enableImage: true)
            }
        })
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
            tableViewCell.repoInfoTypeLabel.text = ZLLocalizedString(string: "code", comment: "代码")
            tableViewCell.repoInfoDetailLabel.text = self.repoInfoModel?.language
            }
        case .pullRequest:do{
            tableViewCell.repoInfoTypeLabel.text = ZLLocalizedString(string: "pull request", comment: "合并请求")
            //tableViewCell.repoInfoDetailLabel.text = "\(self.repoInfoModel)"
            }
        case .branch:do{
            tableViewCell.repoInfoTypeLabel.text = ZLLocalizedString(string: "branch", comment: "分支")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}


extension ZLRepoInfoViewModel
{
    @objc func onNotificationArrived(notification: Notification)
    {
        switch(notification.name)
        {
        case ZLGetSpecifiedRepoInfoResult_Notification:do
        {
            let operationResultModel : ZLOperationResultModel = notification.params as! ZLOperationResultModel
            
            if operationResultModel.serialNumber != operationResultModel.serialNumber
            {
                return;
            }
            
            SVProgressHUD.dismiss()
            
            guard let repoInfo : ZLGithubRepositoryModel = operationResultModel.data as? ZLGithubRepositoryModel else
            {
                ZLLog_Warn("data of operationResultModel is not ZLGithubRepositoryModel,so return")
                return
            }
            
            self.setViewDataForRepoInfoView(model: repoInfo, view: self.repoInfoView!)
            }
        default:
            break;
        }
        
      
    }
}
