//
//  ZLRepoInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension
import RxSwift

class ZLRepoInfoController: ZLBaseViewController {
    
    let disposeBag = DisposeBag()
    
    // Entry Params
    @objc var fullName: String?
    
    // Presenter
    var presenter: ZLRepoInfoPresenter?
    
    // viewModel
    var sectionDatas: [ZLTableViewBaseSectionData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let fullName = self.fullName,
              fullName.contains(find: "/") else {
                  ZLToastView.showMessage("invalid full name")
                  return
              }
        
        analytics.log(.viewItem(name: fullName))
        
        setupUI()
        
        presenter = ZLRepoInfoPresenter(repoFullName: fullName)
        
        tableContainerView.startLoad()
    }
    
    func setupUI() {
        title = fullName
        
        contentView.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        zlNavigationBar.rightButton = moreButton
    }
    
    // MARK: - lazy view
    
    lazy var moreButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: ZLIconFont.More.rawValue,
                                                     attributes: [.font: UIFont.zlIconFont(withSize: 30),
                                                                  .foregroundColor: UIColor.label(withName: "ICON_Common")]),
                                  for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)
        return  button
    }()
    
    lazy var tableContainerView: ZLTableContainerView = {
        let view = ZLTableContainerView()
        view.setTableViewHeader()
        view.delegate = self
        view.register(ZLRepoInfoHeaderCell.self, forCellReuseIdentifier: "ZLRepoInfoHeaderCell")
        view.register(ZLCommonTableViewCell.self, forCellReuseIdentifier: "ZLCommonTableViewCell")
        view.register(ZLCommonSectionHeaderView.self, forViewReuseIdentifier: "ZLCommonSectionHeaderView")
        view.register(ZLCommonSectionFooterView.self, forViewReuseIdentifier: "ZLCommonSectionFooterView")
        view.tableViewFooter = readMeView
        return view
    }()
    
    lazy var readMeView: ZLReadMeView = {
        let readMeView: ZLReadMeView = ZLReadMeView()
        readMeView.delegate = self
        return readMeView
    }()
}

// MARK: - Rows
extension ZLRepoInfoController {
    
    func generateCellDatas() {
        
        let model = presenter?.repoModel
        
        sectionDatas.removeAll()
        for sectionData in sectionDatas {
            sectionData.removeFromSuperViewModel()
        }
        
        guard let model = model else {
            tableContainerView.resetSectionDatas(sectionDatas: sectionDatas, hasMoreData: false)
            return
        }
        
        let headerCellData = ZLRepoHeaderCellData(repoInfoModel: model, presenter: presenter)
        addSubViewModel(headerCellData)
        let headerSectionData = ZLCommonSectionHeaderFooterViewData(cellDatas: [headerCellData], headerHeight: 10, headerColor: .clear, headerReuseIdentifier: "ZLCommonSectionHeaderView")
        addSubViewModel(headerSectionData)
        sectionDatas.append(headerSectionData)
        
        let commitCellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                         title: { ZLLocalizedString(string: "commit", comment: "提交") },
                                                         info: {""},
                                                         cellHeight: 50,
                                                         actionBlock: { [weak self] in
            self?.onCommitClicked()
        })
        
        let branchCellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                         title: {ZLLocalizedString(string: "branch", comment: "分支")},
                                                         info: { [weak self] in self?.presenter?.currentBranch ?? ""},
                                                         cellHeight: 50,
                                                         actionBlock: { [weak self] in
            self?.onBranchClicked()
            
        })
        
        let languageCellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                           title: {ZLLocalizedString(string: "Language", comment: "语言")},
                                                           info: { model.language ?? ""} ,
                                                           cellHeight: 50,
                                                           actionBlock: { [weak self] in
            self?.onLanguageClicked()
        })
        
        let codeCellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                       title: {ZLLocalizedString(string: "code", comment: "代码")},
                                                       info: {""},
                                                       cellHeight: 50,
                                                       actionBlock: {  [weak self] in
            self?.onCodeClicked()
            
        })
        
        let actionCellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                         title:{ ZLLocalizedString(string: "action", comment: "action")},
                                                         info: {""},
                                                         cellHeight: 50,
                                                         actionBlock: { [weak self] in
            self?.onActionClicked()
        })
        
        
        let prCellData = ZLCommonTableViewCellDataV2(canClick: true,
                                                     title: {ZLLocalizedString(string: "pull request", comment: "合并请求")},
                                                     info:{""},
                                                     cellHeight: 50,
                                                     actionBlock: { [weak self] in
            self?.onPrClicked()
        })
        let itemCellDatas: [ZLTableViewBaseCellData] = [commitCellData,
                                                        branchCellData,
                                                        languageCellData,
                                                        codeCellData,
                                                        actionCellData,
                                                        prCellData]
        addSubViewModels(itemCellDatas)
        
        let itemSectionData = ZLCommonSectionHeaderFooterViewData(cellDatas: itemCellDatas,
                                                                  headerHeight: 10,
                                                                  footerHeight: 10,
                                                                  headerColor: .clear,
                                                                  footerColor: .clear,
                                                                  headerReuseIdentifier: "ZLCommonSectionHeaderView",
                                                                  footerReuseIdentifier: "ZLCommonSectionFooterView")
        addSubViewModel(itemSectionData)
        sectionDatas.append(itemSectionData)
        
        tableContainerView.resetSectionDatas(sectionDatas: sectionDatas, hasMoreData: false)
    }
}

// MARK: - Action
extension ZLRepoInfoController {
    
    func onCommitClicked() {
        let controller = ZLRepoCommitController()
        controller.repoFullName = fullName
        controller.branch = presenter?.currentBranch
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func onBranchClicked() {
        
        guard let fullName = fullName else { return }
        
        ZLRepoBranchesView.showRepoBranchedView(repoFullName: fullName,
                                                currentBranch: presenter?.currentBranch ?? "" ) { [weak self] (branch: String) in
            guard let self = self else { return }
            self.presenter?.changeBranch(newBranch: branch)
            self.tableContainerView.reloadData()
            self.readMeView.startLoad(fullName: fullName, branch: branch)
        }
    }
    
    func onLanguageClicked() {
        
        guard let fullName = fullName,
              let language = presenter?.repoModel?.language,
              !language.isEmpty else {
                        return
                    }
        ZLRepoLanguagesPercentView.showRepoLanguagesPercentView(fullName: fullName)
    }
    
    func onCodeClicked() {
        let controller = ZLRepoContentController()
        controller.branch = presenter?.currentBranch
        controller.repoFullName = fullName
        controller.path = ""
        self.viewController?.navigationController?.pushViewController(controller, animated: true)
    }

    
    func onActionClicked() {
        let workflowVC = ZLRepoWorkflowsController()
        workflowVC.repoFullName = fullName
        self.viewController?.navigationController?.pushViewController(workflowVC, animated: true)
    }
    
    func onPrClicked() {
        let controller = ZLRepoPullRequestController.init()
        controller.repoFullName = fullName
        self.viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    // action
    @objc func onMoreButtonClick(button: UIButton) {

        guard let _ = fullName,
              let htmlUrl = presenter?.repoModel?.html_url,
              let url = URL(string: htmlUrl) else { return }
        button.showShareMenu(title: url.absoluteString, url: url, sourceViewController: self)
    }
       
}


// MARK: - ZLTableContainerViewDelegate
extension ZLRepoInfoController: ZLTableContainerViewDelegate {
    
    func zlLoadNewData() {
        
        presenter?.loadRepoRequest().subscribe(onNext: { [weak self] message in
            
            guard let self = self else { return }
            if message.result {
                
                self.generateCellDatas()
                
            } else if !message.result,
               !message.error.isEmpty {
                
                ZLToastView.showMessage(message.error, sourceView: self.view)
                self.tableContainerView.endRefresh()
            }
            
        }).disposed(by: disposeBag)
        
        presenter?.getRepoWatchStatus()
        
        presenter?.getRepoStarStatus()
        
        readMeView.startLoad(fullName: fullName ?? "", branch: presenter?.currentBranch)
    }
    
    func zlLoadMoreData() {
        // No Implementation
    }
}


extension ZLRepoInfoController: ZLReadMeViewDelegate {
    
    @objc func onLinkClicked(url: URL?) {
        if let realurl = url {
            ZLUIRouter.openURL(url: realurl)
        }
    }

    @objc func notifyNewHeight(height: CGFloat) {
        if tableContainerView.tableViewFooter != nil {
            readMeView.frame = CGRect(x: 0, y: 0, width: 0, height: height)
            tableContainerView.tableViewFooter = readMeView
        }
    }
}
