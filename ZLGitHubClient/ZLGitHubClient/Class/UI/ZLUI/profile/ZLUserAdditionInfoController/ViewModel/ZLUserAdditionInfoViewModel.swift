//
//  ZLUserAdditionInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLUserAdditionInfoViewModel: ZLBaseViewModel {
    
    static let per_page: UInt = 10                            // 每页多少记录
    
    // model
    var type : ZLUserAdditionInfoType?              // info类型
    var userInfo : ZLGithubUserModel?               // 用户信息
    var array : [Any]?                              // repo信息/gist信息/following信息
    var currentPage : Int  =  0                     // 当前页号
    var serialNumber: String?                       // 当前请求的流水号
    
    // view
    var baseView : ZLUserAdditionInfoView?
    
    var refreshManager : ZMRefreshManager?           // refresh管理器
    
    
    deinit {
        // 注销监听
        ZLAdditionInfoServiceModel.shared().unRegisterObserver(self, name:ZLGetReposResult_Notification);
        ZLAdditionInfoServiceModel.shared().unRegisterObserver(self, name:ZLGetFollowingResult_Notification);
        ZLAdditionInfoServiceModel.shared().unRegisterObserver(self, name:ZLGetFollowersResult_Notification);
        self.refreshManager?.free()
    }

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
       
        //1、 保存baseView 和 model 
        if !(targetView is ZLUserAdditionInfoView)
        {
            ZLLog_Warn("targetView is not ZLUserAdditionInfoView")
            return;
        }
        self.baseView = targetView as? ZLUserAdditionInfoView;
        self.refreshManager = ZMRefreshManager.init(scrollView: self.baseView!.tableView, addHeaderView: false, addFooterView: true);
        self.refreshManager?.delegate = self
        
        if targetModel == nil || !(targetModel! is [String : Any])
        {
            ZLLog_Warn("targetModel is not valid")
            return;
        }
        
        let dic: [String : Any] = targetModel as! [String : Any]
        self.type = dic["type"] as? ZLUserAdditionInfoType
        self.userInfo = dic["userInfo"] as? ZLGithubUserModel
        
        // 2、 注册对于 ZLAdditionInfoServiceModel 通知的监听
        ZLAdditionInfoServiceModel.shared().registerObserver(self, selector: #selector(self.onNotificationArrived(notification:)), name: ZLGetReposResult_Notification)
        ZLAdditionInfoServiceModel.shared().registerObserver(self, selector: #selector(self.onNotificationArrived(notification:)), name: ZLGetFollowingResult_Notification)
        ZLAdditionInfoServiceModel.shared().registerObserver(self, selector: #selector(self.onNotificationArrived(notification:)), name: ZLGetFollowersResult_Notification)
        
        self.serialNumber = NSString.generateSerialNumber()
        ZLAdditionInfoServiceModel.shared().getAdditionInfo(forUser: self.userInfo!.loginName, infoType: self.type!, page:UInt(self.currentPage + 1), per_page:ZLUserAdditionInfoViewModel.per_page, serialNumber:self.serialNumber!);
        
        // 根据model 更新 UI
        self.setViewDataForUserAdditionInfoView(userInfo: self.userInfo!, type: self.type!, view: self.baseView!);
    }
    
    
    @IBAction func onBackButtonClicked(_ sender: Any) {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
    
}


extension ZLUserAdditionInfoViewModel
{
    func setViewDataForUserAdditionInfoView(userInfo:ZLGithubUserModel,type:ZLUserAdditionInfoType, view:ZLUserAdditionInfoView)
    {
        view.tableView.delegate = self;
        view.tableView.dataSource = self;
        
        view.headImageView.sd_setImage(with: URL.init(string: userInfo.avatar_url), placeholderImage: nil);
        
        switch type
        {
        case .repositories:do{
            view.titleLabel.text = ZLLocalizedString(string: "repositories", comment: "仓库")
            view.infoLabel.text = ZLLocalizedString(string: "repositories", comment: "仓库")
            view.numLabel.text = "\(userInfo.public_repos + userInfo.total_private_repos)"
            view.viewType = .repositories
            }
        case .gists:do{
            view.titleLabel.text = ZLLocalizedString(string: "gists", comment: "代码片段")
            view.infoLabel.text = ZLLocalizedString(string: "gists", comment: "代码片段")
            view.numLabel.text = "\(userInfo.public_gists + userInfo.private_gists)"
            }
        case .followers:do{
            view.titleLabel.text = ZLLocalizedString(string: "followers", comment: "粉丝")
            view.infoLabel.text = ZLLocalizedString(string: "followers", comment: "粉丝")
            view.numLabel.text = "\(userInfo.followers)"
            view.viewType = .users
            }
        case .following:do{
            view.titleLabel.text = ZLLocalizedString(string: "following", comment: "关注")
            view.infoLabel.text = ZLLocalizedString(string: "following", comment: "关注")
            view.numLabel.text = "\(userInfo.following)"
            view.viewType = .users
            }
        case .stars:do
        {
            view.titleLabel.text = ZLLocalizedString(string: "stars", comment: "标星")
            view.infoLabel.text = ZLLocalizedString(string: "stars", comment: "标星")
            view.viewType = .repositories
            }
            
        }
    }
}

extension ZLUserAdditionInfoViewModel
{
    @objc func onNotificationArrived(notification: Notification)
    {
        ZLLog_Info("onNotificationArrived: notification[\(notification.name)]")
        
        switch(notification.name)
        {
        case ZLGetReposResult_Notification:
            fallthrough
        case ZLGetGistsResult_Notification:
            fallthrough
        case ZLGetFollowersResult_Notification:
            fallthrough
        case ZLGetFollowingResult_Notification:do{
            
            guard let notiPara: ZLOperationResultModel  = notification.params as? ZLOperationResultModel else
            {
                return
            }
            
            if self.serialNumber == nil || notiPara.serialNumber != self.serialNumber!
            {
                return;
            }
            self.serialNumber = nil;
            self.baseView?.indicatorView.isHidden = true
            
            if notiPara.result == true
            {
                let itemArray: [Any]? = notiPara.data as? [Any]
                
                if itemArray != nil && itemArray!.count > 0
                {
                    self.currentPage = self.currentPage + 1
                    self.refreshManager?.setFooterViewRefreshEnd()
                }
                else
                {
                    self.refreshManager?.setFooterViewNoMoreFresh()
                    return;
                }
                
                if self.array == nil
                {
                    self.array = (itemArray! as NSArray).mutableCopy() as? [Any]
                }
                else
                {
                    self.array?.append(contentsOf: itemArray!)
                }
                self.baseView?.tableView.reloadData();
                
            }
            else
            {
                self.refreshManager?.setFooterViewRefreshEnd()
                guard let errorModel : ZLGithubRequestErrorModel = notiPara.data as? ZLGithubRequestErrorModel else
                {
                    return;
                }
                
                ZLLog_Warn("get repos failed statusCode[\(errorModel.statusCode)] message[\(errorModel.message)]")
            }
        }
        
        default:
            break;
        }
    }
}

extension ZLUserAdditionInfoViewModel: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.baseView!.viewType
        {
        case .repositories:do{
            return 170;
            }
        case .gists:do{
            return 170;
            }
        case .users:do{
            return 100;
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.baseView!.viewType
        {
        case .repositories:do{
            
            let data = self.array?[indexPath.row] as? ZLGithubRepositoryModel
            
            guard let tableViewCell: ZLRepositoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLRepositoryTableViewCell", for: indexPath) as? ZLRepositoryTableViewCell else
            {
                return UITableViewCell()
            }
            
            if data?.isPriva ?? false
            {
                tableViewCell.privateLabel.isHidden = false
            }
            else
            {
                tableViewCell.privateLabel.isHidden = true
            }
            tableViewCell.headImageView.sd_setImage(with: URL.init(string: data?.owner.avatar_url ?? ""), placeholderImage: nil);
            tableViewCell.repostitoryNameLabel.text = data?.name
            tableViewCell.languageLabel.text = data?.language
            tableViewCell.descriptionLabel.text = data?.desc_Repo
            tableViewCell.forkNumLabel.text = "\(data?.forks ?? 0)"
            tableViewCell.starNumLabel.text = "\(data?.stargazers_count ?? 0)"
            tableViewCell.ownerNameLabel.text = data?.owner.loginName
            
            return tableViewCell
            }
        case .gists:do{
            
            let data = self.array?[indexPath.row] as? ZLGithubRepositoryModel
            
            guard let tableViewCell: ZLRepositoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLRepositoryTableViewCell", for: indexPath) as? ZLRepositoryTableViewCell else
            {
                return UITableViewCell()
            }
            
            if data?.isPriva ?? false
            {
                tableViewCell.privateLabel.isHidden = false
            }
            else
            {
                tableViewCell.privateLabel.isHidden = true
            }
            tableViewCell.headImageView.sd_setImage(with: URL.init(string: data?.owner.avatar_url ?? ""), placeholderImage: nil);
            tableViewCell.repostitoryNameLabel.text = data?.name
            tableViewCell.languageLabel.text = data?.language
            tableViewCell.descriptionLabel.text = data?.desc_Repo
            tableViewCell.forkNumLabel.text = "\(data?.forks ?? 0)"
            tableViewCell.starNumLabel.text = "\(data?.stargazers_count ?? 0)"
            
            return tableViewCell
            
            }
        case .users:do{
            
            let data = self.array?[indexPath.row] as? ZLGithubUserModel
            
            guard let tableViewCell: ZLUserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLUserTableViewCell", for: indexPath) as? ZLUserTableViewCell else
            {
                return UITableViewCell()
            }
          
            tableViewCell.headImageView.sd_setImage(with: URL.init(string: data?.avatar_url ?? ""), placeholderImage: nil);
            tableViewCell.nameLabel.text = data?.name
            tableViewCell.loginNameLabel.text = data?.loginName
            tableViewCell.companyLabel.text = data?.company
            tableViewCell.locationLabel.text = data?.location
            
            return tableViewCell
            
            }
        }
        
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.baseView!.viewType
        {
        case .repositories:do{
            
            let data = self.array?[indexPath.row] as? ZLGithubRepositoryModel
            if data != nil
            {
                let vc = ZLRepoInfoController.init(repoInfoModel: data!)
                self.viewController?.navigationController?.pushViewController(vc, animated: false)
            }
        }
        case .gists:do{
            break;
            }
        case .users:do{
            let data = self.array?[indexPath.row] as? ZLGithubUserModel
            if data != nil
            {
                let vc = ZLUserInfoController.init(userInfoModel: data!)
                self.viewController?.navigationController?.pushViewController(vc, animated: false)
            }
            
        }
        }
    }
}

extension ZLUserAdditionInfoViewModel : ZMRefreshManagerDelegate
{
    func zmRefreshIsDragUp(_ isDragUp: Bool, refreshView: UIView!) {
        
        self.serialNumber = NSString.generateSerialNumber()
        
        ZLAdditionInfoServiceModel.shared().getAdditionInfo(forUser: self.userInfo!.loginName, infoType: self.type!, page:UInt(self.currentPage + 1), per_page:ZLUserAdditionInfoViewModel.per_page, serialNumber: self.serialNumber!);
    }
}
