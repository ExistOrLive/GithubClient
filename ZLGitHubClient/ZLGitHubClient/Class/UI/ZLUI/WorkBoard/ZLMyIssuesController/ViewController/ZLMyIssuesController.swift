//
//  ZLMyIssuesController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/23.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLMyIssuesController: ZLBaseViewController, ZLMyIssuesViewDelegate {
    
    // view
    var myIssuesView : ZLMyIssuesView!
    
    // model
    var filterType : ZLMyIssueFilterType = .creator
    var afterCursor : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ZLLocalizedString(string: "issues", comment: "")
        
        let issuesView = ZLMyIssuesView()
        self.contentView.addSubview(issuesView)
        issuesView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        issuesView.githubItemListView.delegate = self
        issuesView.delegate = self
        
        self.myIssuesView = issuesView
       
        self.myIssuesView.githubItemListView.beginRefresh()
    }
    
    func onFilterTypeChange(type: ZLMyIssueFilterType) {
        self.filterType = type
        self.myIssuesView.githubItemListView.clearListView()
        self.myIssuesView.githubItemListView.beginRefresh()
    }
    
}

extension ZLMyIssuesController : ZLGithubItemListViewDelegate {
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void{
        
        weak var weakSelf = self
        ZLServiceManager.sharedInstance.additionServiceModel?.getMyIssues(with: self.filterType,
                                                        after: nil,
                                                        serialNumber: NSString.generateSerialNumber())
        { (resultModel : ZLOperationResultModel) in
            if resultModel.result == false {
                
                weakSelf?.myIssuesView.githubItemListView.endRefreshWithError()
                guard let errorModel = resultModel.data as? ZLGithubRequestErrorModel else{
                    return
                }
                ZLToastView.showMessage(errorModel.message)
                
            } else {
                
                guard let data = resultModel.data as? SearchIssuesQuery.Data else {
                    weakSelf?.myIssuesView.githubItemListView.endRefreshWithError()
                    return
                }
                weakSelf?.afterCursor = data.search.pageInfo.endCursor
                var cellDatas : [ZLIssueTableViewCellDataForViewerIssue] = []
                if data.search.nodes != nil {
                    for node in data.search.nodes!{
                        if let tmpdata = node?.asIssue {
                            cellDatas.append(ZLIssueTableViewCellDataForViewerIssue.init(data: tmpdata))
                        }
                    }
                    self.addSubViewModels(cellDatas)
                }
                weakSelf?.myIssuesView.githubItemListView.resetCellDatas(cellDatas: cellDatas)
            }
        }
        
    }
    
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) -> Void{
        weak var weakSelf = self
        ZLServiceManager.sharedInstance.additionServiceModel?.getMyIssues(with: self.filterType,
                                                        after: afterCursor,
                                                        serialNumber: NSString.generateSerialNumber())
        { (resultModel : ZLOperationResultModel) in
            if resultModel.result == false {
                
                weakSelf?.myIssuesView.githubItemListView.endRefreshWithError()
                guard let errorModel = resultModel.data as? ZLGithubRequestErrorModel else{
                    return
                }
                ZLToastView.showMessage(errorModel.message)
                
            } else {
                
                guard let data = resultModel.data as? SearchIssuesQuery.Data else {
                    weakSelf?.myIssuesView.githubItemListView.endRefreshWithError()
                    return
                }
                weakSelf?.afterCursor = data.search.pageInfo.endCursor
                var cellDatas : [ZLIssueTableViewCellDataForViewerIssue] = []
                if data.search.nodes != nil {
                    for node in data.search.nodes!{
                        if let tmpdata = node?.asIssue {
                            cellDatas.append(ZLIssueTableViewCellDataForViewerIssue.init(data: tmpdata))
                        }
                    }
                    self.addSubViewModels(cellDatas)
                }
                weakSelf?.myIssuesView.githubItemListView.appendCellDatas(cellDatas: cellDatas)
            }
        }
    }
}
