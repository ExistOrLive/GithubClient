//
//  ZLUserOrOrgInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/4/10.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLGitRemoteService
import ZLBaseExtension
import ZLUIUtilities
import ZLUtilities

class ZLUserOrOrgInfoController: ZLBaseViewController {

    // Outer Property
    @objc var loginName: String?

    // view
    private lazy var userInfoView: ZLUserInfoView = {
        ZLUserInfoView()
    }()
    
    // presenter
    private var userPresenter: ZLUserInfoPresenter?
    
    // subViewModel
    private var subViewModelArray: [[ZLGithubItemTableViewCellData]] = []

    // viewCallBack
    private var viewCallback: (() -> Void)?
    private var readMeCallback: (() -> Void)?


    override func viewDidLoad() {
        super.viewDidLoad()

        guard let login = loginName else {
            ZLToastView.showMessage(ZLLocalizedString(string: "loginName is nil", comment: ""))
            return
        }
        
        setupUI()
        
        userInfoView.fillWithData(delegateAndDataSource: self)
        
        userPresenter = ZLUserInfoPresenter(login: login, callBack: { [weak self] model in
            guard let self = self else { return }
            self.dealWithPresenterMessage(message: model)
        })
        
        contentView.showProgressHUD()
        userPresenter?.loadData(firstLoad: true)
    }
    
    func setupUI() {
        title = loginName
        contentView.addSubview(userInfoView)
        userInfoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        setSharedButton()
    }


    func setSharedButton() {

        let button = UIButton.init(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: ZLIconFont.More.rawValue,
                                                     attributes: [.font: UIFont.zlIconFont(withSize: 30),
                                                                  .foregroundColor: UIColor.label(withName: "ICON_Common")]),
                                  for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)

        self.zlNavigationBar.rightButton = button
    }

    // action
    @objc func onMoreButtonClick(button: UIButton) {

        guard let _ = loginName,
              let url = URL(string: html_url ?? "") else { return }
        button.showShareMenu(title: url.absoluteString, url: url, sourceViewController: self)
    }

}

extension ZLUserOrOrgInfoController {
    
    func generateUserSubViewModel(model: ZLGithubUserModel, pinnedRepositories: [ZLGithubRepositoryBriefModel]) {
        
        self.subViewModelArray.removeAll()
        for subViewModel in self.subViewModels {
            subViewModel.removeFromSuperViewModel()
        }

        // headerCellData
        let headerCellData = ZLUserInfoHeaderCellData(data: model)
        self.subViewModelArray.append([headerCellData])
        self.addSubViewModel(headerCellData)

        // contributionCellData
        let contributionCellData = ZLUserContributionsCellData(loginName: model.loginName ?? "")
        self.subViewModelArray.append([contributionCellData])
        self.addSubViewModel(contributionCellData)

        var itemCellDatas = [ZLGithubItemTableViewCellData]()

        // company
        if let company = model.company,
           !company.isEmpty {
             let cellData = ZLCommonTableViewCellData(canClick: false,
                                                      title: ZLLocalizedString(string: "company", comment: ""),
                                                      info: company,
                                                      cellHeight: 50)
            itemCellDatas.append(cellData)
        }

        // address
        if let location = model.location,
           !location.isEmpty {
            let cellData = ZLCommonTableViewCellData(canClick: false,
                                                     title: ZLLocalizedString(string: "location", comment: ""),
                                                     info: location,
                                                     cellHeight: 50)
           itemCellDatas.append(cellData)
        }

        // email
        if let email = model.email,
           !email.isEmpty {

            let cellData = ZLCommonTableViewCellData(canClick: true,
                                                     title: ZLLocalizedString(string: "email", comment: ""),
                                                     info: email,
                                                     cellHeight: 50) {

                if let url = URL(string: "mailto:\(email)"),
                   UIApplication.shared.canOpenURL(url) {

                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
           itemCellDatas.append(cellData)
        }

        // blog
        if let blog = model.blog,
           !blog.isEmpty {

            let cellData = ZLCommonTableViewCellData(canClick: true,
                                                     title: ZLLocalizedString(string: "blog", comment: ""),
                                                     info: blog,
                                                     cellHeight: 50) {

                if let url = URL.init(string: blog) {
                    ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,
                                          params: ["requestURL": url],
                                          animated: true)
                }
            }
           itemCellDatas.append(cellData)
        }

        if !itemCellDatas.isEmpty {
            self.addSubViewModels(itemCellDatas)
            self.subViewModelArray.append(itemCellDatas)
        }

        if !pinnedRepositories.isEmpty {
            let pinnedReposCellData = ZLPinnedRepositoriesTableViewCellData(repos: pinnedRepositories)
            self.addSubViewModel(pinnedReposCellData)
            self.subViewModelArray.append([pinnedReposCellData])
        }
    }
    
    func generateOrgSubViewModel(model: ZLGithubOrgModel, pinnedRepositories: [ZLGithubRepositoryBriefModel]) {
        
        self.subViewModelArray.removeAll()
        
        for subViewModel in self.subViewModels {
            subViewModel.removeFromSuperViewModel()
        }
        
        // headerCellData
        let headerCellData = ZLOrgInfoHeaderCellData(data: model)
        self.subViewModelArray.append([headerCellData])
        self.addSubViewModel(headerCellData)
        
        var itemCellDatas = [ZLGithubItemTableViewCellData]()
        
        // company
        if model.repositories > 0 {
            let cellData = ZLCommonTableViewCellData(canClick: true,
                                                     title: ZLLocalizedString(string: "repositories", comment: ""),
                                                     info: "\(model.repositories)",
                                                     cellHeight: 50) { [weak self] in
                guard let self = self else { return }
                
                if let login = self.loginName,
                   let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController, params: ["login": login, "type": ZLUserAdditionInfoType.repositories.rawValue]) {
                    vc.hidesBottomBarWhenPushed = true
                    self.viewController?.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            itemCellDatas.append(cellData)
        }
        
        // address
        if let location = model.location,
           !location.isEmpty {
            let cellData = ZLCommonTableViewCellData(canClick: false,
                                                     title: ZLLocalizedString(string: "location", comment: ""),
                                                     info: location,
                                                     cellHeight: 50)
            itemCellDatas.append(cellData)
        }
        
        // email
        if let email = model.email,
           !email.isEmpty {
            
            let cellData = ZLCommonTableViewCellData(canClick: true,
                                                     title: ZLLocalizedString(string: "email", comment: ""),
                                                     info: email,
                                                     cellHeight: 50) {
                
                if let url = URL(string: "mailto:\(email)"),
                   UIApplication.shared.canOpenURL(url) {
                    
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            itemCellDatas.append(cellData)
        }
        
        // blog
        if let blog = model.blog,
           !blog.isEmpty {
            
            let cellData = ZLCommonTableViewCellData(canClick: true,
                                                     title: ZLLocalizedString(string: "blog", comment: ""),
                                                     info: blog,
                                                     cellHeight: 50) {
                
                if let url = URL.init(string: blog) {
                    ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,
                                          params: ["requestURL": url],
                                          animated: true)
                }
            }
            itemCellDatas.append(cellData)
        }
        
        if !itemCellDatas.isEmpty {
            self.addSubViewModels(itemCellDatas)
            self.subViewModelArray.append(itemCellDatas)
        }
        
        if !pinnedRepositories.isEmpty {
            let pinnedReposCellData = ZLPinnedRepositoriesTableViewCellData(repos: pinnedRepositories)
            self.addSubViewModel(pinnedReposCellData)
            self.subViewModelArray.append([pinnedReposCellData])
        }
    }
    
    
    func dealWithPresenterMessage (message: ZLPresenterMessageModel) {
        
        contentView.dismissProgressHUD()
        
        if message.result {
            if let data = message.data as? ZLUserInfoViewData {
                generateUserSubViewModel(model: data.userInfoModel, pinnedRepositories: data.pinnedRepositories)
            } else if let data = message.data as? ZLOrgInfoViewData {
                generateOrgSubViewModel(model: data.orgInfoModel, pinnedRepositories: data.pinnedRepositories)
            }
            readMeCallback?()
        } else {
            if !message.error.isEmpty {
                ZLToastView.showMessage(message.error)
            }
        }
        viewCallback?()
        
    }
    
}

extension ZLUserOrOrgInfoController: ZLUserInfoViewDelegateAndDataSource {
    
    var html_url: String? {
        userPresenter?.htmlUrl
    }

    // datasource
    var userOrOrgLoginName: String {
        userPresenter?.loginName ?? ""
    }

    var cellDatas: [[ZLGithubItemTableViewCellDataProtocol]] {
        subViewModelArray
    }

    // delegate
    func loadNewData() {
        userPresenter?.loadData(firstLoad: false)
    }

    func onLinkClicked(url: URL?) {
        if let realurl = url {
            ZLUIRouter.openURL(url: realurl)
        }
    }

    func setCallBack(callback: @escaping () -> Void) {
        viewCallback = callback
    }
    func setReadMeCallBack(callback: @escaping () -> Void) {
        readMeCallback = callback
    }
}
