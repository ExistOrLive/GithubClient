//
//  ZLProfileViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/21.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLBaseExtension
import ZLUIUtilities
import SnapKit
import ZLGitRemoteService

class ZLProfileViewController: ZLBaseViewController {
    
    // model
    private var currentUserInfo: ZLGithubUserModel?
    
    // sectionDatas
    private var sectionDatas: [ZLTableViewBaseSectionData] = []
    
    deinit {
        removeObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
    
    func setupUI() {
        zlNavigationBar.backgroundColor = .black
        setZLNavigationBarHidden(true)
        
        contentView.addSubview(tableContainerView)
        tableContainerView.tableView.addSubview(backView)
        
        tableContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backView.snp.makeConstraints { make in
            make.left.equalTo(tableContainerView.tableView.contentLayoutGuide.snp.left)
            make.bottom.equalTo(tableContainerView.tableView.contentLayoutGuide.snp.top)
            make.size.equalTo(tableContainerView.tableView.frameLayoutGuide.snp.size)
        }
    }
    
    private lazy var tableContainerView: ZLTableContainerView = {
        let view = ZLTableContainerView()
        view.setTableViewHeader()
        view.tableView.showsVerticalScrollIndicator = false
        view.register(ZLProfileHeaderCell.self, forCellReuseIdentifier: "ZLProfileHeaderCell")
        view.register(ZLProfileContributionsCell.self, forCellReuseIdentifier: "ZLProfileContributionsCell")
        view.register(ZLCommonTableViewCell.self, forCellReuseIdentifier: "ZLCommonTableViewCell")
        view.register(ZLCommonSectionFooterView.self, forViewReuseIdentifier: "ZLCommonSectionFooterView")
        view.delegate = self
        return view
    }()
    
    private lazy var backView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        return view
    }()
}

// MARK: - cellDatas
extension ZLProfileViewController {
    
    func reloadCellDatas() {
        
        for sectionData in sectionDatas {
            sectionData.removeFromSuperViewModel()
        }
        sectionDatas.removeAll()
        
        guard let userModel = currentUserInfo else {
            self.tableContainerView.resetSectionDatas(sectionDatas: sectionDatas, hasMoreData: false)
            return
        }
        
        // header
        let headerCellData = ZLProfileHeaderCellData(userModel: userModel)
        addSubViewModel(headerCellData)
        
        // contribution
        let contributionsCellData = ZLProfileContributionsCellData(userModel: userModel)
        addSubViewModel(contributionsCellData)
        
        let headerSectionData = ZLCommonSectionHeaderFooterViewData(cellDatas: [headerCellData,contributionsCellData],
                                                                    headerHeight: 0,
                                                                    footerHeight:20,
                                                                    headerColor: nil,
                                                                    footerColor: .clear,
                                                                    headerReuseIdentifier: nil,
                                                                    footerReuseIdentifier: "ZLCommonSectionFooterView")
        addSubViewModel(headerSectionData)
        
        // info
        let companyCellData = ZLCommonTableViewCellDataV2(canClick: false,
                                                          title: { ZLLocalizedString(string: "company", comment: "公司")},
                                                          info: { userModel.company ?? "" },
                                                          cellHeight: 50,
                                                          showSeparateLine: true)
        addSubViewModel(companyCellData)
        
        let locationCellData = ZLCommonTableViewCellDataV2(canClick: false,
                                                           title: { ZLLocalizedString(string: "location", comment: "地址")},
                                                           info: { userModel.location ?? "" },
                                                           cellHeight: 50,
                                                           showSeparateLine: true)
        addSubViewModel(locationCellData)
        
        let emailCellData = ZLCommonTableViewCellDataV2(canClick: false,
                                                        title: { ZLLocalizedString(string: "email", comment: "邮箱")},
                                                        info: { userModel.email ?? "" },
                                                        cellHeight: 50,
                                                        showSeparateLine: true)
        addSubViewModel(emailCellData)
        
        let blogCellData = ZLCommonTableViewCellDataV2(canClick: !(userModel.blog?.isEmpty ?? true),
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
        addSubViewModel(blogCellData)
        
        let infoSectionData = ZLCommonSectionHeaderFooterViewData(cellDatas: [companyCellData,locationCellData,emailCellData,blogCellData],
                                                                  headerHeight: 0,
                                                                  footerHeight:20,
                                                                  headerColor: nil,
                                                                  footerColor: .clear,
                                                                  headerReuseIdentifier: nil,
                                                                  footerReuseIdentifier: "ZLCommonSectionFooterView")
        addSubViewModel(infoSectionData)
        
        
        // setting
        let settingCellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                          title: { ZLLocalizedString(string: "setting", comment: "设置")},
                                                          info: { "" },
                                                          cellHeight: 50,
                                                          showSeparateLine: true) { [weak self] in
            if let vc = ZLUIRouter.getVC(key: ZLUIRouter.SettingController) {
                vc.hidesBottomBarWhenPushed = true
                self?.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        addSubViewModel(settingCellData)
        
        let aboutCellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                        title: { ZLLocalizedString(string: "about", comment: "关于")},
                                                        info: { "" },
                                                        cellHeight: 50,
                                                        showSeparateLine: true) { [weak self] in
            if let vc = ZLUIRouter.getZLAboutViewController() {
                vc.hidesBottomBarWhenPushed = true
                self?.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        addSubViewModel(aboutCellData)
        
        let feedbackCellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                           title: { ZLLocalizedString(string: "feedback", comment: "反馈")},
                                                           info: { "" },
                                                           cellHeight: 50) { [weak self] in
            let vc = ZLFeedbackController.init()
            vc.hidesBottomBarWhenPushed = true
            self?.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        addSubViewModel(feedbackCellData)
        
        
        let settingSectionData = ZLCommonSectionHeaderFooterViewData(cellDatas: [settingCellData,aboutCellData,feedbackCellData],
                                                                     headerHeight: 0,
                                                                     footerHeight:20,
                                                                     headerColor: nil,
                                                                     footerColor: .clear,
                                                                     headerReuseIdentifier: nil,
                                                                     footerReuseIdentifier: "ZLCommonSectionFooterView")
        addSubViewModel(settingSectionData)
        
        sectionDatas = [headerSectionData,infoSectionData,settingSectionData]
        
        self.tableContainerView.resetSectionDatas(sectionDatas: sectionDatas, hasMoreData: false)
    }
    
}

// MARK: - ZLTableContainerViewDelegate
extension ZLProfileViewController: ZLTableContainerViewDelegate {
    func zlLoadNewData() {
        guard let userInfo = ZLServiceManager.sharedInstance.viewerServiceModel?.currentUserModel else {
            self.reloadCellDatas()
            return
        }
        currentUserInfo = userInfo
        reloadCellDatas()
    }
    func zlLoadMoreData() {}
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
            tableContainerView.justRefresh()
            }
        default:
            break
        }

    }
}
