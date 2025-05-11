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

    
    @objc init() {
        super.init()
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    
    override func setupUI() {
        super.setupUI()
        
        self.title = "\(ZLLocalizedString(string: "Commit", comment: "提交")) #\(ref?.prefix(7) ?? "")"
        
        self.zmNavigationBar.addRightView(moreButton)
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        tableView.register(ZLCommitInfoHeaderCell.self,
                           forCellReuseIdentifier: "ZLCommitInfoHeaderCell")
        tableView.register(ZLCommitInfoFileCell.self,
                           forCellReuseIdentifier: "ZLCommitInfoFileCell")
        
        self.setRefreshViews(types: [.header])
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
    
  
}

// MARK: - Action
extension ZLCommitInfoController {
    
    @objc func onMoreButtonClick(button: UIButton) {

        let path = model?.html_url ?? ""
        guard let url = URL(string: path) else { return }
        button.showShareMenu(title: path, url: url, sourceViewController: self)
    }
    
}


//
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
                
                let cellDatas = self.getCellDatas(data: data)
                
    
         
                    self.zm_addSubViewModels(cellDatas)
                    
                    self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDatas)]
                    

                    self.tableView.reloadData()
                    self.endRefreshViews(noMoreData: true)
                    self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
            

            } else {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
                self.endRefreshViews()
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
            }
        })
    }
//    
//    func requestDiscussionComment(isLoadNew: Bool) {
//        
//        ZLEventServiceShared()?.getDiscussionComment(withLogin: login ?? "",
//                                                     repoName: repoName ?? "",
//                                                     number: Int32(number),
//                                                     per_page: 20,
//                                                     after: isLoadNew ? nil : after,
//                                                     serialNumber: NSString.generateSerialNumber())
//        { [weak self](resultModel: ZLOperationResultModel) in
//    
//            guard let self else { return }
//            
//            if resultModel.result,
//               let data = resultModel.data as? DiscussionCommentsQuery.Data {
//         
//                let cellDatas = self.getCommentCellDatas(data: data)
//                
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(200), execute: {
//                    self.zm_addSubViewModels(cellDatas)
//                    
//                    let hasNextPage = data.repository?.discussion?.comments.pageInfo.hasNextPage ?? false
//                    self.after = data.repository?.discussion?.comments.pageInfo.endCursor
//                    self.sectionDataArray.first?.cellDatas.append(contentsOf: cellDatas)
//                    self.endRefreshViews(noMoreData: !hasNextPage)
//                    self.tableView.reloadData()
//                    self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
//                })
//
//            } else {
//                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
//                    ZLToastView.showMessage(errorModel.message)
//                }
//                self.endRefreshViews()
//                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
//            }
//        }
//    }
//                                                 
//    
    func getCellDatas(data: ZLGithubCommitModel) -> [ZMBaseTableViewCellViewModel] {
        
        var cellDatas: [ZMBaseTableViewCellViewModel] = []
      
        cellDatas = [ZLCommitInfoHeaderCellData(model: data)]
        
        cellDatas.append(contentsOf: data.files.map({ fileModel in
            return ZLCommitInfoFileCellData(model: fileModel)
        }))
        
        return cellDatas
    }
//    
//    func getCommentCellDatas(data: DiscussionCommentsQuery.Data) -> [ZMBaseTableViewCellViewModel] {
//        
//        var cellDatas: [ZMBaseTableViewCellViewModel] = []
//        if let comments = data.repository?.discussion?.comments.nodes {
//            cellDatas = comments.compactMap({
//                if let data = $0 {
//                    return ZLDiscussionCommentTableViewCellData(data: data)
//                } else {
//                    return nil
//                }
//            })
//        }
//        return cellDatas
//    }

}

