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
    var filterType : ZLIssueFilterType = .created
    var state : ZLGithubIssueState = .open

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
    
    func onFilterTypeChange(type: ZLIssueFilterType) {
        self.filterType = type
        self.myIssuesView.githubItemListView.clearListView()
        self.myIssuesView.githubItemListView.beginRefresh()
    }
    
    func onStateChange(state:ZLGithubIssueState){
        self.state = state
        self.myIssuesView.githubItemListView.clearListView()
        self.myIssuesView.githubItemListView.beginRefresh()
    }
    
}

extension ZLMyIssuesController : ZLGithubItemListViewDelegate {
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void{
        
        ZLServiceManager.sharedInstance.viewerServiceModel?.getMyIssues(key: nil,
                                                                        state: state,
                                                                        filter: filterType,
                                                                        after: nil,
                                                                        serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel) in
            
            if resultModel.result == false {
                
                self?.myIssuesView.githubItemListView.endRefreshWithError()
                guard let errorModel = resultModel.data as? ZLGithubRequestErrorModel else{
                    return
                }
                ZLToastView.showMessage(errorModel.message)
                
            } else {
                
                guard let data = resultModel.data as? SearchItemQuery.Data else {
                    self?.myIssuesView.githubItemListView.endRefreshWithError()
                    return
                }
                self?.afterCursor = data.search.pageInfo.endCursor
                var cellDatas : [ZLIssueTableViewCellDataForViewerIssue] = []
                if data.search.nodes != nil {
                    for node in data.search.nodes!{
                        if let tmpdata = node?.asIssue {
                            cellDatas.append(ZLIssueTableViewCellDataForViewerIssue.init(data: tmpdata))
                        }
                    }
                    self?.addSubViewModels(cellDatas)
                }
                self?.myIssuesView.githubItemListView.resetCellDatas(cellDatas: cellDatas)
            }
            
        }
    }
    
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) -> Void{
        
        ZLServiceManager.sharedInstance.viewerServiceModel?.getMyIssues(key: nil,
                                                                        state: state,
                                                                        filter: filterType,
                                                                        after: afterCursor,
                                                                        serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false {
                
                self?.myIssuesView.githubItemListView.endRefreshWithError()
                guard let errorModel = resultModel.data as? ZLGithubRequestErrorModel else{
                    return
                }
                ZLToastView.showMessage(errorModel.message)
                
            } else {
                
                guard let data = resultModel.data as? SearchItemQuery.Data else {
                    self?.myIssuesView.githubItemListView.endRefreshWithError()
                    return
                }
                self?.afterCursor = data.search.pageInfo.endCursor
                var cellDatas : [ZLIssueTableViewCellDataForViewerIssue] = []
                if data.search.nodes != nil {
                    for node in data.search.nodes!{
                        if let tmpdata = node?.asIssue {
                            cellDatas.append(ZLIssueTableViewCellDataForViewerIssue.init(data: tmpdata))
                        }
                    }
                    self?.addSubViewModels(cellDatas)
                }
                self?.myIssuesView.githubItemListView.appendCellDatas(cellDatas: cellDatas)
            }
        }
    }
}
