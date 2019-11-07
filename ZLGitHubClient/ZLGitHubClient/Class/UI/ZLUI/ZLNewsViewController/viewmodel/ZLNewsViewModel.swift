//
//  ZLNewsViewModel.swift
//  ZLGitHubClient
//
//  Created by LongMac on 2019/8/30.
//  Copyright © 2019年 ZM. All rights reserved.
//

import UIKit

class ZLNewsViewModel: ZLBaseViewModel {

    private weak var newsBaseView: ZLNewsBaseView?
    var receivedEventArray: [Any]?
    
    var currentPage: Int = 0
    var per_page: Int = 10

    var curLoginName: String?
    var userInfo: ZLGithubUserModel?
    private var serialNumber: String?
    
    var refreshManager: ZMRefreshManager?
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView)
    {
        if !(targetView is ZLNewsBaseView)
        {
            ZLLog_Info("targetView is invalid")
        }
        
        self.newsBaseView = targetView as? ZLNewsBaseView
        self.newsBaseView?.tableView.delegate = self
        self.newsBaseView?.tableView.dataSource = self
        
        //刷新组件
        self.refreshManager = ZMRefreshManager.init(scrollView: self.newsBaseView!.tableView, addHeaderView: false, addFooterView: true);
        self.refreshManager?.delegate = self
        self.refreshManager?.setFooterViewRefreshing()
        
        // 注册事件监听
        ZLEventServiceModel.shareInstance().registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name:ZLGetUserReceivedEventResult_Notification)
        ZLUserServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLGetCurrentUserInfoResult_Notification)
        ZLUserServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLGetSpecifiedUserInfoResult_Notification)
    }
    
    deinit {
        ZLEventServiceModel.shareInstance().unRegisterObserver(self, name: ZLGetUserReceivedEventResult_Notification)
        ZLUserServiceModel.shared().unRegisterObserver(self, name: ZLGetCurrentUserInfoResult_Notification)
        ZLUserServiceModel.shared().unRegisterObserver(self, name: ZLGetSpecifiedUserInfoResult_Notification)
        self.refreshManager?.free()
    }
    
    override func vcLifeCycle_viewWillAppear() {
        super.vcLifeCycle_viewWillAppear()
        
        self.newsBaseView?.navTitle.text = ZLLocalizedString(string: "news", comment: "动态")
        
        //每次界面将要展示时，更新数据
        guard self.userInfo != nil else
        {
            return;
        }

        self.serialNumber = NSString.generateSerialNumber();
        
        ZLEventServiceModel.shareInstance().getReceivedEvents(forUser: userInfo?.loginName, page: UInt(self.currentPage + 1), per_page: UInt(self.per_page), serialNumber: self.serialNumber)
    }
}

// MARK: onNotificationArrived
extension ZLNewsViewModel
{
    @objc func onNotificationArrived(notification: Notification)
    {
        ZLLog_Info("onNotificationArrived: notification[\(notification.name)]")
        
        switch notification.name
        {
            case ZLGetUserReceivedEventResult_Notification:do
            {
                guard let resultModel: ZLOperationResultModel = notification.params as? ZLOperationResultModel else
                {
                    self.refreshManager?.setFooterViewRefreshEnd()
                    return
                }
                
                guard resultModel.result == true else
                {
                    self.refreshManager?.setFooterViewRefreshEnd()
                    guard let errorModel : ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel else
                    {
                        return;
                    }
                    
                    ZLLog_Warn("get received event failed statusCode[\(errorModel.statusCode)] message[\(errorModel.message)]")
                    
                    return
                }
                
                let itemArray: [Any]? = resultModel.data as? [Any]
                
                guard itemArray != nil && itemArray!.count > 0 else
                {
                    self.refreshManager?.setFooterViewNoMoreFresh()
                    ZLLog_Info("itemArray is nil or itemArray count < 0, so return")
                    return
                }
                
                self.currentPage = self.currentPage + 1
                self.refreshManager?.setFooterViewRefreshEnd()
                
                if self.receivedEventArray == nil
                {
                    self.receivedEventArray = (itemArray! as NSArray).mutableCopy() as? [Any]
                }
                else
                {
                    self.receivedEventArray?.append(contentsOf: itemArray!)
                }
                self.newsBaseView?.tableView.reloadData()
            }
            case ZLGetCurrentUserInfoResult_Notification:do
            {
                let operationResultModel : ZLOperationResultModel = notification.params as! ZLOperationResultModel
                
                guard let userInfo : ZLGithubUserModel = operationResultModel.data as? ZLGithubUserModel else
                {
                    ZLLog_Warn("data of operationResultModel is not ZLGithubUserModel,so return")
                    return
                }
                
                self.userInfo = userInfo
                self.serialNumber = NSString.generateSerialNumber()
                
                ZLEventServiceModel.shareInstance().getReceivedEvents(forUser: self.userInfo?.loginName, page: UInt(self.currentPage + 1), per_page: UInt(self.per_page), serialNumber: self.serialNumber)
            }
            case ZLGetSpecifiedUserInfoResult_Notification: do
            {
                let operationResultModel : ZLOperationResultModel = notification.params as! ZLOperationResultModel
                
                guard self.serialNumber == operationResultModel.serialNumber else
                {
                    ZLLog_Warn("serialNumber is not equal, this response will discard")
                    return
                }
                
                guard let userInfo : ZLGithubUserModel = operationResultModel.data as? ZLGithubUserModel else
                {
                    ZLLog_Warn("data of operationResultModel is not ZLGithubUserModel,so return")
                    return
                }

                let vc = ZLUserInfoController.init(userInfoModel: userInfo)
                vc.hidesBottomBarWhenPushed = true
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
            default:
                ZLLog_Info("event have no deal")
        }
    }
}

// MARK: UITableViewDelegate
extension ZLNewsViewModel: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.receivedEventArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data: ZLReceivedEventModel? = self.receivedEventArray?[indexPath.row] as? ZLReceivedEventModel
        
        guard let eventType: ZLReceivedEventType = data?.type else
        {
            ZLLog_Info("eventType isn't ZLReceivedEventType")
            return 0
        }
        
        switch eventType
        {
            case .createEvent: do
            {
                 return 140
            }
            case .pushEvent: do
            {
                let payload: ZLPayloadModel? = data?.payload as? ZLPayloadModel
                let commitItems: [ZLCommitInfoModel]? = payload?.commits as? [ZLCommitInfoModel]
        
                let commitCount: Int = commitItems?.count ?? 0
                let cellHeight = 140 + commitCount * 35;
                return CGFloat.init(cellHeight);
            }
            case .pullRequestEvent: do
            {
                return 140
            }
            case .watchEvent: do
            {
                return 140
            }
            case .unKnow: do
            {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data: ZLReceivedEventModel? = self.receivedEventArray?[indexPath.row] as? ZLReceivedEventModel

        guard let tableViewCell: ZLNewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLNewsTableViewCell", for: indexPath) as? ZLNewsTableViewCell else
        {
            return UITableViewCell()
        }
        
        tableViewCell.autoresizingMask = UIViewAutoresizing.init(rawValue: 0)
        tableViewCell.backgroundColor = UIColor.clear
        tableViewCell.selectionStyle = UITableViewCellSelectionStyle.none
        tableViewCell.avatarImageView.sd_setImage(with: URL.init(string: data?.actor.avatar_url ?? ""), placeholderImage: nil);
        tableViewCell.userNameLabel.text = data?.actor.login ?? "";

        let timeStr = NSString.init(format: "%@",(data?.created_at as NSDate?)?.dateLocalStrSinceCurrentTime() ?? "")
        tableViewCell.dateLabel.text = timeStr as String;
        
        tableViewCell.containView.layer.cornerRadius = 2
        tableViewCell.containView.layer.masksToBounds = true
        
        //添加手势
        let tapGestureRecognizer1 = UITapGestureRecognizer.init(target: self, action: #selector(onSingleTapEvent(tapGesture:)))
        let tapGestureRecognizer2 = UITapGestureRecognizer.init(target: self, action: #selector(onSingleTapEvent(tapGesture:)))
        if tableViewCell.avatarImageView.gestureRecognizers == nil
        {
            tableViewCell.avatarImageView.addGestureRecognizer(tapGestureRecognizer1)
        }
        if tableViewCell.userNameLabel.gestureRecognizers == nil
        {
            tableViewCell.userNameLabel.addGestureRecognizer(tapGestureRecognizer2)
        }
        
        if let eventType: ZLReceivedEventType = data?.type
        {
            switch eventType
            {
                case .createEvent: do
                {
                    let createPayLoad: ZLCreateEventPayloadModel = data?.payload as! ZLCreateEventPayloadModel
                    let refType: ZLReferenceType = createPayLoad.ref_type as ZLReferenceType
                    let repoName: String = data?.repo.name ?? ""
                    let mainContent: String
                    
                    if refType == ZLReferenceType.repository
                    {
                        mainContent = "Created repository " + repoName
                    }
                    else
                    {
                        mainContent = "Create tag " + repoName
                    }

                    tableViewCell.contentLabel.text = mainContent
                }
                case .pushEvent: do
                {
                    let repoName: String = data?.repo.name ?? ""
                    
                    let payload: ZLPayloadModel? = data?.payload as? ZLPayloadModel
                    let items: [String] = payload?.ref.components(separatedBy: "/") ?? [String]()
                    let branch: String = items.last ?? ""
                    
                    let mainContent: String = "Push to " + branch + " at " + repoName
                
                    guard let commitItems: [ZLCommitInfoModel] = payload?.commits as? [ZLCommitInfoModel] else
                    {
                        ZLLog_Info("unWrap fail")
                        return tableViewCell
                    }
                    
                    let detailInfo: NSMutableAttributedString = NSMutableAttributedString.init()
                    
                    for (_, value) in commitItems.enumerated()
                    {
                        let commit = value as ZLCommitInfoModel
                        var commit_sha: String = commit.sha as String
                        let commit_message: String = commit.message as String
                        
                        if commit_sha.count > 6
                        {
                            commit_sha = String(commit_sha.suffix(6))
                        }
    
                        let shaAttriStr = NSMutableAttributedString(text: (commit_sha), font: UIFont.init(name: "PingFangSC-Regular", size: 14), textForegroundColor: UIColor.init("199BFF"), paragraphStyle: NSParagraphStyle.init())
                        
                        let messageAttriStr = NSMutableAttributedString(text: (" - " + commit_message + "\n"), font: UIFont.init(name: "PingFangSC-Regular", size: 16), textForegroundColor: UIColor.black, paragraphStyle: NSParagraphStyle.init())
        
                        detailInfo.append(shaAttriStr!)
                        detailInfo.append(messageAttriStr!)
                    }
                    
                    let mainContentAttriStr :NSMutableAttributedString = NSMutableAttributedString(text: (mainContent + "\n"), font: UIFont.init(name: "PingFangSC-Medium", size: 17), textForegroundColor: UIColor.black, paragraphStyle: NSParagraphStyle.init())
                    
                    mainContentAttriStr.append(detailInfo)
                    tableViewCell.contentLabel.attributedText = mainContentAttriStr
                }
                case .pullRequestEvent: do
                {
                    let dic: [String:Any]? = data?.payload as? [String: Any]
                    let operationType: String? = dic?["action"] as? String
                    if operationType == "opened"
                    {
                        tableViewCell.contentLabel.text = "Opened pull request " + (data?.repo.name)!
                    }
                    else if operationType == "closed"
                    {
                        tableViewCell.contentLabel.text = "Closed pull request " + (data?.repo.name)!
                    }
                }
                case .watchEvent: do
                {
                    let watchPayLoad: ZLWatchEventPayloadModel = data?.payload as! ZLWatchEventPayloadModel
                    let repoName: String = data?.repo.name ?? ""
                    let mainContent: String
                    
                    if watchPayLoad.action == "started"
                    {
                        mainContent = "Starred " + repoName
                    }
                    else
                    {
                        mainContent = "UnKnow operation"
                    }
                
                    tableViewCell.contentLabel.text = mainContent
                }
                case .unKnow: do
                {
                    ZLLog_Info("")
                }
            }
        }
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let data: ZLReceivedEventModel? = self.receivedEventArray?[indexPath.row] as? ZLReceivedEventModel
    
//        self.serialNumber = NSString.generateSerialNumber()
//        ZLUserServiceModel.shared().getUserInfo(withLoginName: data?.actor.login ?? "", userType: ZLGithubUserType_User, serialNumber: self.serialNumber!)
    }
    
}

extension ZLNewsViewModel
{
    @objc func onSingleTapEvent(tapGesture: UITapGestureRecognizer)
    {
        let point: CGPoint = tapGesture.location(in: self.newsBaseView?.tableView)
        let indexPath: IndexPath? = self.newsBaseView?.tableView.indexPathForRow(at: point)
        guard let tableViewCell: ZLNewsTableViewCell = self.newsBaseView?.tableView.cellForRow(at: indexPath!) as? ZLNewsTableViewCell else
        {
            return
        }
        
        self.serialNumber = NSString.generateSerialNumber()
        ZLUserServiceModel.shared().getUserInfo(withLoginName: tableViewCell.userNameLabel.text ?? "", userType: ZLGithubUserType_User, serialNumber: self.serialNumber!)
    } 
}

extension ZLNewsViewModel : ZMRefreshManagerDelegate
{
    func zmRefreshIsDragUp(_ isDragUp: Bool, refreshView: UIView!) {
        
        self.serialNumber = NSString.generateSerialNumber()
        ZLEventServiceModel.shareInstance().getReceivedEvents(forUser: userInfo?.loginName, page: UInt(self.currentPage + 1), per_page: UInt(self.per_page), serialNumber: self.serialNumber)
    }
}
