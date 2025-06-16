//
//  ZLCommitInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/11.
//  Copyright © 2025 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZLUIUtilities
import ZLUtilities
import ZMMVVM

class ZLCommitInfoController: ZMTableViewController {

    // input model
    @objc var login: String?
    @objc var repoName: String?
    @objc var ref: String?
    
    // model
    var model: ZLGithubCommitModel?
    
    var lastIndex: Int = 0
    
    var per_page: Int = 10

    
    @objc init() {
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if ZLDeviceInfo.isIPhone() {
            guard let appdelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            appdelegate.allowRotation = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if ZLDeviceInfo.isIPhone() {
            guard let appdelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            appdelegate.allowRotation = false
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        super.viewWillTransition(to: size, with: coordinator)

        if ZLDeviceInfo.isIPhone() {
            guard let navigationVC: ZMNavigationController = self.navigationController as? ZMNavigationController else {
                return
            }
            if size.height > size.width {
                // 横屏变竖屏
                self.isZmNavigationBarHidden = false
                navigationVC.forbidGestureBack = false
            } else {
                self.isZmNavigationBarHidden = true
                navigationVC.forbidGestureBack = true
            }
        }
    }
    
    
    override func setupUI() {
        super.setupUI()
        
        self.title = "\(ZLLocalizedString(string: "commit", comment: "提交")) #\(ref?.prefix(7) ?? "")"
        
        self.zmNavigationBar.addRightView(moreButton)
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(ZLCommitInfoHeaderCell.self,
                           forCellReuseIdentifier: "ZLCommitInfoHeaderCell")
        tableView.register(ZLCommitInfoPatchCell.self,
                           forCellReuseIdentifier: "ZLCommitInfoPatchCell")
        tableView.register(ZLCommitInfoFilePathHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: "ZLCommitInfoFilePathHeaderView")
        tableView.register(ZLCommonSectionHeaderFooterView.self,
                           forHeaderFooterViewReuseIdentifier: "ZLCommonSectionHeaderFooterView")
        
        self.setRefreshViews(types: [.header,.footer])
    }
    
    lazy var moreButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: ZLIconFont.More.rawValue,
                                                     attributes: [.font: UIFont.zlIconFont(withSize: 30),
                                                                  .foregroundColor: UIColor.label(withName: "ICON_Common")]),
                                  for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        return button
    }()
    

    override func refreshLoadNewData() {
        requestCommitInfo()
    }
    
    override func refreshLoadMoreData() {
        generateMoreFileData()
    }
    
  
}

// MARK: - Action
extension ZLCommitInfoController {
    
    @objc func onMoreButtonClick(button: UIButton) {

        let path = model?.html_url ?? ""
        guard let url = URL(string: path) else { return }
        button.showShareMenu(title: path, url: url, sourceViewController: self)
    }
    
}


// MARK: - Request
extension ZLCommitInfoController {
    
    func requestCommitInfo() {
        
        ZLRepoServiceShared()?.getRepoCommitInfo(withLogin: login ?? "",
                                                 repoName: repoName ?? "",
                                                 ref: ref ?? "",
                                                 serialNumber: NSString.generateSerialNumber(),
                                                 completeHandle: {  [weak self](resultModel: ZLOperationResultModel) in
            guard let self else { return }
            
            if resultModel.result,
               let data = resultModel.data as? ZLGithubCommitModel {
                self.model = data
                self.lastIndex = 0
                
                let sectionDatas = self.generateFirstPageSectionDatas(data: data)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(200), execute: {
                    
                    self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    
                    sectionDatas.forEach { $0.zm_addSuperViewModel(self) }
               
                
                    self.sectionDataArray = sectionDatas
                    
                    self.tableView.reloadData()
                    self.endRefreshViews(noMoreData: data.files.count <= self.lastIndex)
                    self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
                })
                
            } else {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
                self.endRefreshViews()
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
            }
        })
    }
    
    func generateMoreFileData() {
        let sectionDatas = self.generateNextPageFileData()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(200), execute: {
            
      
            sectionDatas.forEach { $0.zm_addSuperViewModel(self) }
       
        
            self.sectionDataArray.append(contentsOf: sectionDatas)
            
            self.tableView.reloadData()
            
            self.endRefreshViews(noMoreData: (self.model?.files.count ?? 0) <= self.lastIndex)
        })
    }

}

// MARK: - generate Data
extension ZLCommitInfoController {
    
    @objc dynamic func generateFirstPageSectionDatas(data: ZLGithubCommitModel) -> [ZMBaseTableViewSectionData] {
        var sectionDatas: [ZMBaseTableViewSectionData] = []
        
        sectionDatas.append(ZMBaseTableViewSectionData(
            cellDatas: [ZLCommitInfoHeaderCellData(model: data)],
            headerData: ZLCommonSectionHeaderFooterViewDataV2(backColor: .back(withName: "ZLVCBackColor"), viewHeight: 8),
            footerData: ZLCommonSectionHeaderFooterViewDataV2(backColor: .back(withName: "ZLVCBackColor"), viewHeight: 8)))
   
    
        var files = data.files
        if files.count > per_page {
            files = Array(files[0..<per_page])
            self.lastIndex = per_page
        } else {
            self.lastIndex = files.count
        }
        
        
        let fileSectionDatas = files.map({ fileModel in
            let sectionData = ZMBaseTableViewSectionData()
            sectionData.headerData = ZLCommitInfoFilePathHeaderViewData(filePath:fileModel.filename)
            sectionData.cellDatas = [ZLCommitInfoPatchCellData(model: fileModel,
                                                               cellHeight: nil)]
            return sectionData
        })
        sectionDatas.append(contentsOf: fileSectionDatas)
    
        return sectionDatas
    }
    
    @objc dynamic func generateNextPageFileData() -> [ZMBaseTableViewSectionData] {
        guard let model else { return [] }
        
        var files = model.files
        let newLastIndex = self.lastIndex + self.per_page
        if files.count > newLastIndex {
            files = Array(files[self.lastIndex..<newLastIndex])
            self.lastIndex = newLastIndex
        } else {
            files = Array(files[self.lastIndex..<files.count])
            self.lastIndex = model.files.count
        }
        
        let fileSectionDatas = files.map({ fileModel in
            let sectionData = ZMBaseTableViewSectionData()
            sectionData.headerData = ZLCommitInfoFilePathHeaderViewData(filePath:fileModel.filename)
            sectionData.cellDatas = [ZLCommitInfoPatchCellData(model: fileModel,
                                                               cellHeight: nil)]
            return sectionData
        })
    
        return fileSectionDatas
    }
}


