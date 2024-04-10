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

enum ZLUserOrOrgInfoSectionId: String {
    case header
    case contribution
    case baseInfo
    case pinnedRepos
}


class ZLUserOrOrgInfoController: ZLBaseViewController {

    // Outer Property
    @objc var loginName: String?
    
    lazy var stateModel: ZLUserInfoStateModel = {
        let stateModel = ZLUserInfoStateModel(login: loginName ?? "")
        stateModel.delegate = self
        return stateModel
    }()
    
    // subViewModel
    private var sectionDataArray: [ZLTableViewBaseSectionData] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        guard let _ = loginName else {
            ZLToastView.showMessage(ZLLocalizedString(string: "loginName is nil", comment: ""))
            return
        }
        
        setupUI()
        
        tableView.startLoad()
    }
    
    func setupUI() {
        title = loginName
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
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

        guard let html_url = stateModel.html_url,
              let url = URL(string: html_url) else { return }
        button.showShareMenu(title: url.absoluteString, url: url, sourceViewController: self)
    }
    
    lazy var tableView: ZLTableContainerView = {
        let view = ZLTableContainerView()
        view.setTableViewHeader()
        view.delegate = self
        view.register(ZLUserInfoHeaderCell.self, forCellReuseIdentifier: "ZLUserInfoHeaderCell")
        view.register(ZLOrgInfoHeaderCell.self, forCellReuseIdentifier: "ZLOrgInfoHeaderCell")
        view.register(ZLUserContributionsCell.self, forCellReuseIdentifier: "ZLUserContributionsCell")
        view.register(ZLCommonTableViewCell.self, forCellReuseIdentifier: "ZLCommonTableViewCell")
        view.register(ZLPinnedRepositoriesTableViewCell.self, forCellReuseIdentifier: "ZLPinnedRepositoriesTableViewCell")
        view.register(ZLCommonSectionHeaderView.self, forViewReuseIdentifier: "ZLCommonSectionHeaderView")
        view.register(ZLCommonSectionFooterView.self, forViewReuseIdentifier: "ZLCommonSectionFooterView")
        return view
    }()

    lazy var readMeView: ZLReadMeView = {
        let readMeView: ZLReadMeView = ZLReadMeView()
        readMeView.delegate = self
        return readMeView
    }()

}

// MARK: - ZLTableContainerViewDelegate
extension ZLUserOrOrgInfoController: ZLReadMeViewDelegate {
    func zlLoadNewData()  {
        stateModel.getUserInfo()
    }
}

// MARK: - ZLTableContainerViewDelegate
extension ZLUserOrOrgInfoController: ZLTableContainerViewDelegate {
    
    func onLinkClicked(url: URL?) {
        if let realurl = url {
            ZLUIRouter.openURL(url: realurl)
        }
    }

    func getReadMeContent(result: Bool) {
        tableView.tableView.tableFooterView = result ?  readMeView : nil
    }

    func notifyNewHeight(height: CGFloat) {
        if tableView.tableView.tableFooterView != nil {
            readMeView.frame = CGRect(x: 0, y: 0, width: 0, height: height)
            tableView.tableView.tableFooterView = readMeView
        }
    }
}


extension ZLUserOrOrgInfoController {
    
    func generateUserSubViewModel() {
        
        self.sectionDataArray.removeAll()
        for subViewModel in self.subViewModels {
            subViewModel.removeFromSuperViewModel()
        }

        // headerCellData
        let headerCellData = ZLUserInfoHeaderCellData(stateModel: stateModel)
        self.addSubViewModel(headerCellData)
        let headerSectionData = ZLCommonSectionHeaderFooterViewData(cellDatas: [headerCellData],
                                                                    headerHeight: 10,
                                                                    footerHeight: 10,
                                                                    headerColor: .clear,
                                                                    footerColor: .clear,
                                                                    headerReuseIdentifier: "ZLCommonSectionHeaderView",
                                                                    footerReuseIdentifier: "ZLCommonSectionFooterView")
        headerSectionData.sectionId = ZLUserOrOrgInfoSectionId.header.rawValue
        self.sectionDataArray.append(headerSectionData)

        
        // contributionCellData
        let contributionCellData = ZLUserContributionsCellData(loginName: stateModel.login)
        self.addSubViewModel(contributionCellData)
        let contributionSectionData = ZLCommonSectionHeaderFooterViewData(cellDatas: [contributionCellData],
                                                                          footerHeight: 10,
                                                                          footerColor: .clear,
                                                                          footerReuseIdentifier: "ZLCommonSectionFooterView")
        contributionSectionData.sectionId = ZLUserOrOrgInfoSectionId.contribution.rawValue
        self.sectionDataArray.append(contributionSectionData)
        
       
        // baseInfo
        var itemCellDatas = [ZLTableViewBaseCellData]()

        // company
        if let company = stateModel.userModel?.company,
           !company.isEmpty {
            let cellData = ZLCommonTableViewCellDataV2(canClick: false,
                                                       title: { ZLLocalizedString(string: "company", comment: "")},
                                                       info: {company},
                                                       cellHeight: 50)
            itemCellDatas.append(cellData)
        }

        // address
        if let location = stateModel.userModel?.location,
           !location.isEmpty {
            let cellData = ZLCommonTableViewCellDataV2(canClick: false,
                                                       title: { ZLLocalizedString(string: "location", comment: "")},
                                                       info: {location},
                                                       cellHeight: 50)
           itemCellDatas.append(cellData)
        }

        // email
        if let email = stateModel.userModel?.email,
           !email.isEmpty {
            
            let cellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                       title: { ZLLocalizedString(string: "email", comment: "")},
                                                       info: {email},
                                                       cellHeight: 50) {
                if let url = URL(string: "mailto:\(email)"),
                   UIApplication.shared.canOpenURL(url) {

                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
           itemCellDatas.append(cellData)
        }

        // blog
        if let blog = stateModel.userModel?.blog,
           !blog.isEmpty {

            
            let cellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                       title: { ZLLocalizedString(string: "blog", comment: "")},
                                                       info: {blog},
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
            let baseInfoSectionData = ZLCommonSectionHeaderFooterViewData(cellDatas: itemCellDatas,
                                                                              footerHeight: 10,
                                                                              footerColor: .clear,
                                                                              footerReuseIdentifier: "ZLCommonSectionFooterView")
            baseInfoSectionData.sectionId = ZLUserOrOrgInfoSectionId.baseInfo.rawValue
            self.sectionDataArray.append(baseInfoSectionData)
        }

        /// pinnedRepositories
        if !stateModel.pinnedRepositories.isEmpty {
            let pinnedReposCellData = ZLPinnedRepositoriesTableViewCellData(repos: stateModel.pinnedRepositories)
            let pinnedRepoSectionData = ZLCommonSectionHeaderFooterViewData(cellDatas: [pinnedReposCellData],
                                                                              footerHeight: 10,
                                                                              footerColor: .clear,
                                                                              footerReuseIdentifier: "ZLCommonSectionFooterView")
            pinnedRepoSectionData.sectionId = ZLUserOrOrgInfoSectionId.pinnedRepos.rawValue
            self.addSubViewModel(pinnedReposCellData)
            self.sectionDataArray.append(pinnedRepoSectionData)
        }
    }
    
    func generateOrgSubViewModel() {
        
        guard let model = stateModel.orgModel else { return }
        
        self.sectionDataArray.removeAll()
        for subViewModel in self.subViewModels {
            subViewModel.removeFromSuperViewModel()
        }
        
        // headerCellData
        let headerCellData = ZLOrgInfoHeaderCellData(stateModel: stateModel)
        self.addSubViewModel(headerCellData)
        let headerSectionData = ZLCommonSectionHeaderFooterViewData(cellDatas: [headerCellData],
                                                                    headerHeight: 10,
                                                                    footerHeight: 10,
                                                                    headerColor: .clear,
                                                                    footerColor: .clear,
                                                                    headerReuseIdentifier: "ZLCommonSectionHeaderView",
                                                                    footerReuseIdentifier: "ZLCommonSectionFooterView")
        headerSectionData.sectionId = ZLUserOrOrgInfoSectionId.header.rawValue
        self.sectionDataArray.append(headerSectionData)
        
    
        // baseInfo
        var itemCellDatas = [ZLTableViewBaseCellData]()
                
        // company
        if model.repositories > 0 {
            let cellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                       title: { ZLLocalizedString(string: "repositories", comment: "")},
                                                       info: { "\(model.repositories)" },
                                                       cellHeight: 50) { [weak self] in
                guard let self = self else { return }
                
                let login = self.stateModel.login
                if let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController, params: ["login": login, "type": ZLUserAdditionInfoType.repositories.rawValue]) {
                    vc.hidesBottomBarWhenPushed = true
                    self.viewController?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            itemCellDatas.append(cellData)
        }
        
        // address
        if let location = model.location,
           !location.isEmpty {
            let cellData = ZLCommonTableViewCellDataV2(canClick: false,
                                                       title: { ZLLocalizedString(string: "location", comment: "")},
                                                       info: {location},
                                                       cellHeight: 50)
           itemCellDatas.append(cellData)
        }
        
        // email
        if let email = model.email,
           !email.isEmpty {
        
            let cellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                       title: { ZLLocalizedString(string: "email", comment: "")},
                                                       info: {email},
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
            
            let cellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                       title: { ZLLocalizedString(string: "blog", comment: "")},
                                                       info: {blog},
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
            let baseInfoSectionData = ZLCommonSectionHeaderFooterViewData(cellDatas: itemCellDatas,
                                                                              footerHeight: 10,
                                                                              footerColor: .clear,
                                                                              footerReuseIdentifier: "ZLCommonSectionFooterView")
            baseInfoSectionData.sectionId = ZLUserOrOrgInfoSectionId.baseInfo.rawValue
            self.sectionDataArray.append(baseInfoSectionData)
        }
        
        // pinnedRepositories
        if !stateModel.pinnedRepositories.isEmpty {
            let pinnedReposCellData = ZLPinnedRepositoriesTableViewCellData(repos: stateModel.pinnedRepositories)
            let pinnedRepoSectionData = ZLCommonSectionHeaderFooterViewData(cellDatas: [pinnedReposCellData],
                                                                              footerHeight: 10,
                                                                              footerColor: .clear,
                                                                              footerReuseIdentifier: "ZLCommonSectionFooterView")
            pinnedRepoSectionData.sectionId = ZLUserOrOrgInfoSectionId.pinnedRepos.rawValue
            self.addSubViewModel(pinnedReposCellData)
            self.sectionDataArray.append(pinnedRepoSectionData)
        }
    }
    
    func generatePinnedRepositoriesCellData() {
        if let index = sectionDataArray.firstIndex(where: { $0.sectionId == ZLUserOrOrgInfoSectionId.pinnedRepos.rawValue }) {
            let sectionData = self.sectionDataArray.remove(at: index)
            sectionData.cellDatas.forEach { 
                ($0 as? ZLBaseViewModel)?.removeFromSuperViewModel()
            }
        }
        
        // pinnedRepositories
        if !stateModel.pinnedRepositories.isEmpty {
            let pinnedReposCellData = ZLPinnedRepositoriesTableViewCellData(repos: stateModel.pinnedRepositories)
            let pinnedRepoSectionData = ZLCommonSectionHeaderFooterViewData(cellDatas: [pinnedReposCellData],
                                                                              footerHeight: 10,
                                                                              footerColor: .clear,
                                                                              footerReuseIdentifier: "ZLCommonSectionFooterView")
            pinnedRepoSectionData.sectionId = ZLUserOrOrgInfoSectionId.pinnedRepos.rawValue
            self.addSubViewModel(pinnedReposCellData)
            self.sectionDataArray.append(pinnedRepoSectionData)
        }
    }
   
}

extension ZLUserOrOrgInfoController: ZLUserInfoStateModelDelegate {
    func onUserInfoLoad(result: Bool, msg: String) {
        if result {
            if stateModel.isOrg {
                generateOrgSubViewModel()
            } else {
                generateUserSubViewModel()
            }
            tableView.resetSectionDatas(sectionDatas: sectionDataArray, hasMoreData: false)
            readMeView.startLoad(fullName: "\(stateModel.login)/\(stateModel.login)", branch: nil)
        } else {
            tableView.endRefresh()
            if !msg.isEmpty {
                ZLToastView.showMessage(msg, sourceView: contentView)
            }
        }
    }
    
    func onPinnedRepoLoad(result: Bool, msg: String) {
        if result {
            generatePinnedRepositoriesCellData()
            tableView.resetSectionDatas(sectionDatas: sectionDataArray, hasMoreData: false)
        }
        
    }
    
    func onFollowStatusChanged() {
        tableView.reloadDataWith(sectionIds: [ZLUserOrOrgInfoSectionId.header.rawValue])
    }
    
    func onBlockStatusChanged() {
        tableView.reloadDataWith(sectionIds: [ZLUserOrOrgInfoSectionId.header.rawValue])
    }
}
