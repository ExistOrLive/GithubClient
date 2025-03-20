//
//  ZLUserOrOrgInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/4/10.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZLBaseExtension
import ZLUIUtilities
import ZLUtilities
import ZMMVVM

enum ZLUserOrOrgInfoSectionId: String, ZMBaseSectionUniqueIDProtocol {
    var zm_ID: String {
        return self.rawValue
    }
    
    case header
    case contribution
    case baseInfo
    case pinnedRepos
}


class ZLUserOrOrgInfoController: ZMTableViewController {

    // Outer Property
    @objc var loginName: String?
    
    @objc init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var stateModel: ZLUserInfoStateModel = {
        let stateModel = ZLUserInfoStateModel(login: loginName ?? "")
        stateModel.delegate = self
        return stateModel
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let _ = loginName else {
            ZLToastView.showMessage(ZLLocalizedString(string: "loginName is nil", comment: ""))
            return
        }
    
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        title = loginName
        
        setRefreshViews(types: [.header])
        
        tableView.register(ZLUserInfoHeaderCell.self,
                           forCellReuseIdentifier: "ZLUserInfoHeaderCell")
        tableView.register(ZLOrgInfoHeaderCell.self, 
                           forCellReuseIdentifier: "ZLOrgInfoHeaderCell")
        tableView.register(ZLUserContributionsCell.self,
                           forCellReuseIdentifier: "ZLUserContributionsCell")
        tableView.register(ZLCommonTableViewCell.self, 
                           forCellReuseIdentifier: "ZLCommonTableViewCell")
        tableView.register(ZLPinnedRepositoriesTableViewCell.self, 
                           forCellReuseIdentifier: "ZLPinnedRepositoriesTableViewCell")
        tableView.register(ZLCommonSectionHeaderFooterView.self, 
                           forHeaderFooterViewReuseIdentifier: "ZLCommonSectionHeaderFooterView")

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

        self.zmNavigationBar.addRightView(button)
    }

    // action
    @objc func onMoreButtonClick(button: UIButton) {
        guard let html_url = stateModel.html_url,
              let url = URL(string: html_url) else { return }
        button.showShareMenu(title: url.absoluteString, url: url, sourceViewController: self)
    }
    

    lazy var readMeView: ZLReadMeView = {
        let readMeView: ZLReadMeView = ZLReadMeView()
        readMeView.delegate = self
        return readMeView
    }()

    
    override func refreshLoadNewData() {
        stateModel.getUserInfo()
    }
}


// MARK: - ZLReadMeViewDelegate
extension ZLUserOrOrgInfoController: ZLReadMeViewDelegate {
    
    func onLinkClicked(url: URL?) {
        if let realurl = url {
            ZLUIRouter.openURL(url: realurl)
        }
    }

    func getReadMeContent(result: Bool) {
        tableView.tableFooterView = result ?  readMeView : nil
    }

    func notifyNewHeight(height: CGFloat) {
        if tableView.tableFooterView == readMeView {
            readMeView.frame = CGRect(x: 0, y: 0, width: 0, height: height)
            tableView.tableFooterView = readMeView
        }
    }
}


extension ZLUserOrOrgInfoController {
    
    func generateUserSubViewModel() {
        
        self.sectionDataArray.forEach({ $0.zm_removeFromSuperViewModel() })
        self.sectionDataArray.removeAll()
      

        // headerCellData
        let headerCellData = ZLUserInfoHeaderCellData(stateModel: stateModel)
       
        let headerSectionData = ZMBaseTableViewSectionData(zm_sectionID: ZLUserOrOrgInfoSectionId.header)
        headerSectionData.cellDatas = [headerCellData]
        headerSectionData.headerData = ZLCommonSectionHeaderFooterViewDataV2(backColor: .clear,
                                                                             viewHeight: 10)
        headerSectionData.footerData = ZLCommonSectionHeaderFooterViewDataV2(backColor: .clear,
                                                                             viewHeight: 10)
        sectionDataArray.append(headerSectionData)
        
                
        // contributionCellData
        let contributionCellData = ZLUserContributionsCellData(loginName: stateModel.login)
    
        let contributionSectionData = ZMBaseTableViewSectionData(zm_sectionID: ZLUserOrOrgInfoSectionId.contribution)
        contributionSectionData.cellDatas = [contributionCellData]
        contributionSectionData.footerData = ZLCommonSectionHeaderFooterViewDataV2(backColor: .clear,
                                                                             viewHeight: 10)
        sectionDataArray.append(contributionSectionData)
       
        // baseInfo
        var itemCellDatas = [ZMBaseTableViewCellViewModel]()

        // company
        if let company = stateModel.userModel?.company,
           !company.isEmpty {
            let cellData = ZLCommonTableViewCellDataV3(canClick: false,
                                                       title: { ZLLocalizedString(string: "company", comment: "")},
                                                       info: {company},
                                                       cellHeight: 50,
                                                       showSeparateLine: true)
            itemCellDatas.append(cellData)
        }

        // address
        if let location = stateModel.userModel?.location,
           !location.isEmpty {
            let cellData = ZLCommonTableViewCellDataV3(canClick: false,
                                                       title: { ZLLocalizedString(string: "location", comment: "")},
                                                       info: {location},
                                                       cellHeight: 50,
                                                       showSeparateLine: true)
           itemCellDatas.append(cellData)
        }

        // email
        if let email = stateModel.userModel?.email,
           !email.isEmpty {
            
            let cellData = ZLCommonTableViewCellDataV3(canClick: true,
                                                       title: { ZLLocalizedString(string: "email", comment: "")},
                                                       info: {email},
                                                       cellHeight: 50,
                                                       showSeparateLine: true) {
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

            
            let cellData = ZLCommonTableViewCellDataV3(canClick: true,
                                                       title: { ZLLocalizedString(string: "blog", comment: "")},
                                                       info: {blog},
                                                       cellHeight: 50,
                                                       showSeparateLine: true) {

                if let url = URL.init(string: blog) {
                    ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,
                                          params: ["requestURL": url],
                                          animated: true)
                }
            }
           itemCellDatas.append(cellData)
        }

        if !itemCellDatas.isEmpty {
    
            let baseInfoSectionData = ZMBaseTableViewSectionData(zm_sectionID: ZLUserOrOrgInfoSectionId.baseInfo)
            baseInfoSectionData.cellDatas = itemCellDatas
            baseInfoSectionData.footerData = ZLCommonSectionHeaderFooterViewDataV2(backColor: .clear,
                                                                                 viewHeight: 10)
            self.sectionDataArray.append(baseInfoSectionData)
        }

        /// pinnedRepositories
        if !stateModel.pinnedRepositories.isEmpty {
            let pinnedReposCellData = ZLPinnedRepositoriesTableViewCellData(repos: stateModel.pinnedRepositories)
            let pinnedRepoSectionData = ZMBaseTableViewSectionData(zm_sectionID: ZLUserOrOrgInfoSectionId.pinnedRepos)
            pinnedRepoSectionData.cellDatas = [pinnedReposCellData]
            pinnedRepoSectionData.footerData = ZLCommonSectionHeaderFooterViewDataV2(backColor: .clear,
                                                                                 viewHeight: 10)
            self.sectionDataArray.append(pinnedRepoSectionData)
        }
        
        self.sectionDataArray.forEach {
            $0.zm_addSuperViewModel(self)
        }
    }
    
    func generateOrgSubViewModel() {
        
        guard let model = stateModel.orgModel else { return }
        
        self.sectionDataArray.forEach({ $0.zm_removeFromSuperViewModel() })
        self.sectionDataArray.removeAll()
        

        // headerCellData
        let headerCellData = ZLOrgInfoHeaderCellData(stateModel: stateModel)
        
         let headerSectionData = ZMBaseTableViewSectionData(zm_sectionID: ZLUserOrOrgInfoSectionId.header)
         headerSectionData.cellDatas = [headerCellData]
         headerSectionData.headerData = ZLCommonSectionHeaderFooterViewDataV2(backColor: .clear,
                                                                              viewHeight: 10)
         headerSectionData.footerData = ZLCommonSectionHeaderFooterViewDataV2(backColor: .clear,
                                                                              viewHeight: 10)
         sectionDataArray.append(headerSectionData)
        
        
        // baseInfo
        var itemCellDatas = [ZMBaseTableViewCellViewModel]()
                
        // company
        if model.repositories > 0 {
            let cellData = ZLCommonTableViewCellDataV3(canClick: true,
                                                       title: { ZLLocalizedString(string: "repositories", comment: "")},
                                                       info: { "\(model.repositories)" },
                                                       cellHeight: 50,
                                                       showSeparateLine: true) { [weak self] in
                guard let self = self else { return }
                
                let login = self.stateModel.login
                if let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController, params: ["login": login, "type": ZLUserAdditionInfoType.repositories.rawValue]) {
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            itemCellDatas.append(cellData)
        }
        
        // address
        if let location = model.location,
           !location.isEmpty {
            let cellData = ZLCommonTableViewCellDataV3(canClick: false,
                                                       title: { ZLLocalizedString(string: "location", comment: "")},
                                                       info: {location},
                                                       cellHeight: 50,
                                                       showSeparateLine: true)
           itemCellDatas.append(cellData)
        }
        
        // email
        if let email = model.email,
           !email.isEmpty {
        
            let cellData = ZLCommonTableViewCellDataV3(canClick: true,
                                                       title: { ZLLocalizedString(string: "email", comment: "")},
                                                       info: {email},
                                                       cellHeight: 50,
                                                       showSeparateLine: true) {
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
            
            let cellData = ZLCommonTableViewCellDataV3(canClick: true,
                                                       title: { ZLLocalizedString(string: "blog", comment: "")},
                                                       info: {blog},
                                                       cellHeight: 50,
                                                       showSeparateLine: true) {

                if let url = URL.init(string: blog) {
                    ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,
                                          params: ["requestURL": url],
                                          animated: true)
                }
            }
           itemCellDatas.append(cellData)
        }
        
        if !itemCellDatas.isEmpty {
        
            let baseInfoSectionData = ZMBaseTableViewSectionData(zm_sectionID: ZLUserOrOrgInfoSectionId.baseInfo)
            baseInfoSectionData.cellDatas = itemCellDatas
            baseInfoSectionData.footerData = ZLCommonSectionHeaderFooterViewDataV2(backColor: .clear,
                                                                                 viewHeight: 10)
            self.sectionDataArray.append(baseInfoSectionData)
        }
        
        // pinnedRepositories
        if !stateModel.pinnedRepositories.isEmpty {
            let pinnedReposCellData = ZLPinnedRepositoriesTableViewCellData(repos: stateModel.pinnedRepositories)
            let pinnedRepoSectionData = ZMBaseTableViewSectionData(zm_sectionID: ZLUserOrOrgInfoSectionId.pinnedRepos)
            pinnedRepoSectionData.cellDatas = [pinnedReposCellData]
            pinnedRepoSectionData.footerData = ZLCommonSectionHeaderFooterViewDataV2(backColor: .clear,
                                                                                     viewHeight: 10)
            self.sectionDataArray.append(pinnedRepoSectionData)
        }
        
        self.sectionDataArray.forEach {
            $0.zm_addSuperViewModel(self)
        }
    }
    
    func generatePinnedRepositoriesCellData() {
        if let index = sectionDataArray.firstIndex(where: { $0.zm_sectionID.zm_ID == ZLUserOrOrgInfoSectionId.pinnedRepos.zm_ID }) {
            let sectionData = self.sectionDataArray.remove(at: index)
            sectionData.cellDatas.forEach { 
                $0.zm_removeFromSuperViewModel()
            }
        }
        
        // pinnedRepositories
        if !stateModel.pinnedRepositories.isEmpty {
            let pinnedReposCellData = ZLPinnedRepositoriesTableViewCellData(repos: stateModel.pinnedRepositories)
            zm_addSubViewModel(pinnedReposCellData)
            let pinnedRepoSectionData = ZMBaseTableViewSectionData(zm_sectionID: ZLUserOrOrgInfoSectionId.pinnedRepos)
            pinnedRepoSectionData.cellDatas = [pinnedReposCellData]
            pinnedRepoSectionData.footerData = ZLCommonSectionHeaderFooterViewDataV2(backColor: .clear,
                                                                                     viewHeight: 10)
            self.sectionDataArray.append(pinnedRepoSectionData)
        }
    }
   
}

extension ZLUserOrOrgInfoController: ZLUserInfoStateModelDelegate {
    func onUserInfoLoad(result: Bool, msg: String) {
        viewStatus = .normal
        endRefreshViews()
        if result {
            if stateModel.isOrg {
                generateOrgSubViewModel()
            } else {
                generateUserSubViewModel()
            }
            tableView.reloadData()
            readMeView.startLoad(fullName: "\(stateModel.login)/\(stateModel.login)", branch: nil)
        } else {
            viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
            if !msg.isEmpty {
                ZLToastView.showMessage(msg, sourceView: contentView)
            }
        }
    }
    
    func onPinnedRepoLoad(result: Bool, msg: String) {
        if result {
            generatePinnedRepositoriesCellData()
            tableView.reloadData()
        }
        
    }
    
    func onFollowStatusChanged() {
        tableViewProxy.reloadSections(sectionTypes: [ZLUserOrOrgInfoSectionId.header])
    }
    
    func onBlockStatusChanged() {
        tableViewProxy.reloadSections(sectionTypes: [ZLUserOrOrgInfoSectionId.header])
    }
}
