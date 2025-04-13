//
//  ZLRepoInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService
import ZLUtilities
import ZMMVVM

enum ZLRepoInfoSectionType: String, ZMBaseSectionUniqueIDProtocol {
    case header
    case items
    
    var zm_ID: String {
        self.rawValue
    }
}

enum ZLRepoInfoCellType: String, ZMBaseCellUniqueIDProtocol {
    case header
    case commit
    case branch
    case language
    case code
    case action
    case pullRequest
    case discusstion
    case release
    
    var zm_ID: String {
        self.rawValue
    }
}


class ZLRepoInfoController: ZMTableViewController {
        
    // Entry Params
    @objc var fullName: String?
    
    // Presenter
    lazy var presenter: ZLRepoInfoPresenter = {
        let presenter = ZLRepoInfoPresenter(repoFullName: fullName ?? "")
        presenter.delegate = self
        return presenter
    }()
    
    @objc init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        analytics.log(.viewItem(name: fullName ?? ""))
        
        viewStatus = .loading
        
        refreshLoadNewData()
    }
    
    
    
    override func setupUI() {
        super.setupUI()
        
        title = fullName
        
        setRefreshView(type: .header)
        
        tableView.register(ZLRepoInfoHeaderCell.self, forCellReuseIdentifier: "ZLRepoInfoHeaderCell")
        tableView.register(ZLCommonTableViewCell.self, forCellReuseIdentifier: "ZLCommonTableViewCell")
        tableView.register(ZLCommonSectionHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "ZLCommonSectionHeaderFooterView")
   
        zmNavigationBar.addRightView(moreButton)
    }
    
    // MARK: - lazy view
    
    lazy var moreButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: ZLIconFont.More.rawValue,
                                                     attributes: [.font: UIFont.zlIconFont(withSize: 30),
                                                                  .foregroundColor: UIColor.label(withName: "ICON_Common")]),
                                  for: .normal)
        button.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)
        return  button
    }()
    
    lazy var readMeView: ZLReadMeView = {
        let readMeView: ZLReadMeView = ZLReadMeView()
        readMeView.delegate = self
        return readMeView
    }()
    
    override func refreshLoadNewData() {
        presenter.loadRepoRequest()
            
        presenter.getRepoStarStatus()
        
        presenter.getRepoWatchStatus()
         
        readMeView.startLoad(fullName: fullName ?? "", branch: presenter.currentBranch)
        
    }
}

// MARK: - Rows
extension ZLRepoInfoController {
    
    func generateCellDatas() {
        guard let model = presenter.repoModel else { return }
        
        self.sectionDataArray.forEach( { $0.zm_removeFromSuperViewModel() })
        self.sectionDataArray = []
        
        /// header
        let workSection = ZMBaseTableViewSectionData(zm_sectionID: ZLRepoInfoSectionType.header)
        workSection.cellDatas = [ZLRepoHeaderCellData(presenter: presenter)]
        workSection.headerData = ZLCommonSectionHeaderFooterViewDataV2(backColor: .clear,
                                                                       viewHeight: 10)
        sectionDataArray.append(workSection)
        
        
        let itemsSection = ZMBaseTableViewSectionData(zm_sectionID: ZLRepoInfoSectionType.items)
        itemsSection.cellDatas = [
            ZLRepoItemCellData(cellType: .pullRequest, presenter: presenter),
            ZLRepoItemCellData(cellType: .code, presenter: presenter),
            ZLRepoItemCellData(cellType: .commit, presenter: presenter),
            ZLRepoItemCellData(cellType: .branch, presenter: presenter),
            ZLRepoItemCellData(cellType: .language, presenter: presenter),
            ZLRepoItemCellData(cellType: .action, presenter: presenter),
           ]
        if model.discussions_count > 0 {
            itemsSection.cellDatas.append(ZLRepoItemCellData(cellType: .discusstion, presenter: presenter))
        }
//        if model.releases_count > 0 {
//            itemsSection.cellDatas.append(ZLRepoItemCellData(cellType: .release, presenter: presenter))
//        }
        
        itemsSection.headerData = ZLCommonSectionHeaderFooterViewDataV2(backColor: .clear,
                                                                       viewHeight: 10)
        itemsSection.footerData = ZLCommonSectionHeaderFooterViewDataV2(backColor: .clear,
                                                                       viewHeight: 10)
        sectionDataArray.append(itemsSection)
        
        sectionDataArray.forEach { $0.zm_addSuperViewModel(self) }
    }
}

// MARK: - Action
extension ZLRepoInfoController {
    
    // action
    @objc func onMoreButtonClick(button: UIButton) {

        guard let _ = fullName,
              let htmlUrl = presenter.repoModel?.html_url,
              let url = URL(string: htmlUrl) else { return }
        button.showShareMenu(title: url.absoluteString, url: url, sourceViewController: self)
    }
       
}

extension ZLRepoInfoController: ZLReadMeViewDelegate {
    
    @objc func onLinkClicked(url: URL?) {
        if let realurl = url {
            ZLUIRouter.openURL(url: realurl)
        }
    }

    @objc func notifyNewHeight(height: CGFloat) {
        readMeView.frame = CGRect(x: 0, y: 0, width: 0, height: height)
        if tableView.tableFooterView == readMeView {
            tableView.tableFooterView = readMeView
        }
    }
    
    func getReadMeContent(result: Bool) {
        if result, tableView.tableFooterView != readMeView, presenter.repoModel != nil   {
            tableView.tableFooterView = readMeView
        }
    }
}

extension ZLRepoInfoController: ZLRepoInfoPresenterDelegate {
    func onRepoInfoLoad(success: Bool, msg: String) {
        self.endRefreshViews()
        if success {
            self.viewStatus = .normal
            self.generateCellDatas()
            self.tableView.reloadData()
            if readMeView.hasRequestData {
                tableView.tableFooterView = readMeView // 等repoinfo数据请求到才展示readme
            }
        } else {
            self.viewStatus = self.presenter.repoModel == nil ? .error : .normal
            ZLToastView.showMessage(msg)
        }
    }
    
    func onBranchChanged() {
        self.tableViewProxy.reloadCells(cellIDs: [(ZLRepoInfoSectionType.items,
                                                   ZLRepoInfoCellType.branch)])
        self.readMeView.startLoad(fullName: presenter.repoFullName,
                                  branch: presenter.currentBranch)
    }
    
    func onWatchStatusLoaded() {
        self.tableViewProxy.reloadCells(cellIDs: [(ZLRepoInfoSectionType.header,
                                                   ZLRepoInfoCellType.header)])
    }
    
    func onStarStatusLoaded() {
        self.tableViewProxy.reloadCells(cellIDs: [(ZLRepoInfoSectionType.header,
                                                   ZLRepoInfoCellType.header)])
    }
}
