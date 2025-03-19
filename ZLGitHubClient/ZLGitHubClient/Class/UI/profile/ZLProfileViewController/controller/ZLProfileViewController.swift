//
//  ZLProfileViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/21.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLBaseExtension
import ZLUIUtilities
import SnapKit
import ZLGitRemoteService
import ZMMVVM

 
class ZLProfileViewController: ZMTableViewController {
    
    // model
    private var currentUserInfo: ZLGithubUserModel?
    
    @objc init() {
        super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 注册监听
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 每次界面将要展示时，更新数据
        guard let currentUserInfo = ZLServiceManager.sharedInstance.viewerServiceModel?.currentUserModel else {
            return
        }
        self.currentUserInfo = currentUserInfo
        self.reloadCellDatas()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func setupUI() {
        super.setupUI()
        
        isZmNavigationBarHidden = true
        
        setRefreshViews(types: [.header])

        tableView.addSubview(backView)
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.insetsLayoutMarginsFromSafeArea = true
        tableView.register(ZLProfileHeaderCell.self,
                           forCellReuseIdentifier: "ZLProfileHeaderCell")
        tableView.register(ZLProfileContributionsCell.self,
                           forCellReuseIdentifier: "ZLProfileContributionsCell")
        tableView.register(ZLCommonTableViewCell.self,
                           forCellReuseIdentifier: "ZLCommonTableViewCell")
        tableView.register(ZLCommonSectionHeaderFooterView.self,
                           forHeaderFooterViewReuseIdentifier: "ZLCommonSectionHeaderFooterView")
        
        backView.snp.makeConstraints { make in
            make.left.equalTo(tableView.contentLayoutGuide.snp.left)
            make.bottom.equalTo(tableView.contentLayoutGuide.snp.top)
            make.size.equalTo(tableView.frameLayoutGuide.snp.size)
        }
    }
        
    private lazy var backView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    override func refreshLoadNewData() {
        endRefreshViews()
        guard let userInfo = ZLServiceManager.sharedInstance.viewerServiceModel?.getCurrentUserModelFromServer() else {
            self.reloadCellDatas()
            return
        }
        currentUserInfo = userInfo
        reloadCellDatas()
        
    }
}

// MARK: - cellDatas
extension ZLProfileViewController {
    
    func reloadCellDatas() {
        
        self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
        self.sectionDataArray.removeAll()
  
        guard let userModel = currentUserInfo else {
           
            return
        }
        
        // header
        let headerCellData = ZLProfileHeaderCellData(userModel: userModel)
        // contribution
        let contributionsCellData = ZLProfileContributionsCellData(userModel: userModel)
        
        let headerSectionFooterData = ZLCommonSectionHeaderFooterViewDataV2(backColor: .clear,
                                                                            viewHeight: 20)
        let headerSectionData = ZMBaseTableViewSectionData(cellDatas: [headerCellData,
                                                                       contributionsCellData],
                                                           footerData: headerSectionFooterData)
        
        // info
        let companyCellData = ZLCommonTableViewCellDataV3(canClick: false,
                                                          title: { ZLLocalizedString(string: "company", comment: "公司")},
                                                          info: { userModel.company ?? "" },
                                                          cellHeight: 50,
                                                          showSeparateLine: true)

        
        let locationCellData = ZLCommonTableViewCellDataV3(canClick: false,
                                                           title: { ZLLocalizedString(string: "location", comment: "地址")},
                                                           info: { userModel.location ?? "" },
                                                           cellHeight: 50,
                                                           showSeparateLine: true)

        
        let emailCellData = ZLCommonTableViewCellDataV3(canClick: false,
                                                        title: { ZLLocalizedString(string: "email", comment: "邮箱")},
                                                        info: { userModel.email ?? "" },
                                                        cellHeight: 50,
                                                        showSeparateLine: true)

        
        let blogCellData = ZLCommonTableViewCellDataV3(canClick: !(userModel.blog?.isEmpty ?? true),
                                                       title: { ZLLocalizedString(string: "blog", comment: "博客")},
                                                       info: { userModel.blog ?? "" },
                                                       cellHeight: 50) {
            if let blog = userModel.blog,
               !blog.isEmpty,
               let url = URL.init(string: blog) {
                ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,
                                      params: ["requestURL": url],
                                      animated: true)
            }
        }
                                                          
        let infoSectionFooterData = ZLCommonSectionHeaderFooterViewDataV2(backColor: .clear,
                                                                          viewHeight: 20)
        
        let infoSectionData = ZMBaseTableViewSectionData(cellDatas: [companyCellData,
                                                                     locationCellData,
                                                                     emailCellData,
                                                                     blogCellData],
                                                         footerData: infoSectionFooterData)
        
        
        // setting
        let settingCellData = ZLCommonTableViewCellDataV3(canClick: true,
                                                          title: { ZLLocalizedString(string: "setting", comment: "设置")},
                                                          info: { "" },
                                                          cellHeight: 50,
                                                          showSeparateLine: true) { [weak self] in
            if let vc = ZLUIRouter.getVC(key: ZLUIRouter.SettingController) {
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        let aboutCellData = ZLCommonTableViewCellDataV3(canClick: true,
                                                        title: { ZLLocalizedString(string: "about", comment: "关于")},
                                                        info: { "" },
                                                        cellHeight: 50,
                                                        showSeparateLine: true) { [weak self] in
            if let vc = ZLUIRouter.getZLAboutViewController() {
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        let feedbackCellData = ZLCommonTableViewCellDataV3(canClick: true,
                                                           title: { ZLLocalizedString(string: "feedback", comment: "反馈")},
                                                           info: { "" },
                                                           cellHeight: 50) { [weak self] in
            let vc = ZLFeedbackController.init()
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
  
        
        let settingSectionFooterData = ZLCommonSectionHeaderFooterViewDataV2(backColor: .clear,
                                                                          viewHeight: 20)
        let settingSectionData = ZMBaseTableViewSectionData(cellDatas: [settingCellData,
                                                                        aboutCellData,
                                                                        feedbackCellData],
                                                            footerData: settingSectionFooterData)
 
        self.sectionDataArray = [headerSectionData,infoSectionData,settingSectionData]
        self.sectionDataArray.forEach { $0.zm_addSuperViewModel(self) }
        
        self.tableView.reloadData()
    }
    
}

// MARK: - onNotificationArrived
extension ZLProfileViewController {
    func addObservers() {
        ZLServiceManager.sharedInstance.viewerServiceModel?.registerObserver(self, selector: #selector(onNotificationArrived(notication:)), name: ZLGetCurrentUserInfoResult_Notification)
        ZLServiceManager.sharedInstance.viewerServiceModel?.registerObserver(self, selector: #selector(onNotificationArrived(notication:)), name: ZLUpdateUserPublicProfileInfoResult_Notification)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notication:)), name: ZLLanguageTypeChange_Notificaiton, object: nil)
    }

    func removeObservers() {
        // 注销监听
        ZLServiceManager.sharedInstance.viewerServiceModel?.unRegisterObserver(self, name: ZLGetCurrentUserInfoResult_Notification)
        ZLServiceManager.sharedInstance.viewerServiceModel?.unRegisterObserver(self, name: ZLUpdateUserPublicProfileInfoResult_Notification)
        NotificationCenter.default.removeObserver(self, name: ZLLanguageTypeChange_Notificaiton, object: nil)
    }

    @objc func onNotificationArrived(notication: Notification) {
        ZLLog_Info("notificaition[\(notication) arrived]")

        switch notication.name {
        case ZLGetCurrentUserInfoResult_Notification: do {
            
            guard let resultModel: ZLOperationResultModel = notication.params as? ZLOperationResultModel else {
                ZLLog_Info("notificaition.params is nil]")
                return
            }
            
            guard let model: ZLGithubUserModel = resultModel.data as? ZLGithubUserModel else {
                ZLLog_Info("the data of ZLOperationResultModel is ZLGithubUserModel")
                return
            }
            
            currentUserInfo = model
            reloadCellDatas()
        }
        case ZLUpdateUserPublicProfileInfoResult_Notification:do {
            guard let model: ZLGithubUserModel =  ZLServiceManager.sharedInstance.viewerServiceModel?.currentUserModel else {
                return
            }
            currentUserInfo = model
            reloadCellDatas()
        }
        case ZLLanguageTypeChange_Notificaiton:do {
            self.justReloadRefreshView()
            self.tableView.reloadData()
            }
        default:
            break
        }

    }
}
