//
//  ZLCompareCommitFilesController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/20.
//  Copyright © 2025 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZLUIUtilities
import ZLUtilities
import ZMMVVM

class ZLCompareCommitFilesController: ZMTableViewController {

    @objc var login: String?
    @objc var repoName: String?
    @objc var baseRef: String?
    @objc var headRef: String?
    
    var model: ZLGithubCompareModel?
    var lastIndex = 0
    let per_page = 10
    
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
        
        self.title = ZLLocalizedString(string: "commits", comment: "提交")
        

        tableView.register(ZLCommitInfoPatchCell.self,
                           forCellReuseIdentifier: "ZLCommitInfoPatchCell")
        tableView.register(ZLCommitInfoFilePathHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: "ZLCommitInfoFilePathHeaderView")
        tableView.register(ZLCommonSectionHeaderFooterView.self,
                           forHeaderFooterViewReuseIdentifier: "ZLCommonSectionHeaderFooterView")
        
        self.setRefreshViews(types: [.header,.footer])
    }
    
    override func refreshLoadNewData() {
        requestCompareInfo()
    }
    
    override func refreshLoadMoreData() {
        generateMoreFileData()
    }
  
}




// MARK: - Request
extension ZLCompareCommitFilesController {
    
    func requestCompareInfo() {

            ZLRepoServiceShared()?.getRepoCommitCompare(withLogin: login ?? "",
                                                        repoName: repoName ?? "",
                                                        baseRef: baseRef ?? "",
                                                        headRef: headRef ?? "",
                                                        per_page: 30,
                                                        page: 1,
                                                        serialNumber: NSString.generateSerialNumber())
            { [weak self] resultModel in
                guard let self else { return }
                if resultModel.result == true,
                   let model = resultModel.data as? ZLGithubCompareModel {
                
                self.model = model
                self.lastIndex = 0
                
                let sectionDatas = self.generateFirstPageSectionDatas(data: model)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(200), execute: {
                    
                    self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    
                    sectionDatas.forEach { $0.zm_addSuperViewModel(self) }
               
                
                    self.sectionDataArray = sectionDatas
                    
                    self.tableView.reloadData()
                    self.endRefreshViews(noMoreData: model.files.count <= self.lastIndex)
                    self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
                })
                
            } else {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
                self.endRefreshViews()
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
            }
        }
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
extension ZLCompareCommitFilesController {
    
    @objc dynamic func generateFirstPageSectionDatas(data: ZLGithubCompareModel) -> [ZMBaseTableViewSectionData] {
        var sectionDatas: [ZMBaseTableViewSectionData] = []


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



