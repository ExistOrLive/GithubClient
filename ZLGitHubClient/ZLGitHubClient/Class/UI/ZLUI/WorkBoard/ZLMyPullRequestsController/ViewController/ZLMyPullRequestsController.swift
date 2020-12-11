//
//  ZLMyPullRequestsController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/12/11.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLMyPullRequestsController: ZLBaseViewController,ZLMyPullRequestsViewDelegate {

    // view
    var myPRView : ZLMyPullRequestsView!
    
    // model
    var filterType : ZLGithubPullRequestState = .opened
    var afterCursor : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ZLLocalizedString(string: "pull requests", comment: "")
        
        let myPRView = ZLMyPullRequestsView()
        self.contentView.addSubview(myPRView)
        myPRView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        myPRView.githubItemListView.delegate = self
        myPRView.delegate = self
        
        self.myPRView = myPRView
       
        self.myPRView.githubItemListView.beginRefresh()
    }
    
    func onFilterTypeChange(type: ZLGithubPullRequestState) {
        self.filterType = type
        self.myPRView.githubItemListView.clearListView()
        self.myPRView.githubItemListView.beginRefresh()
    }
    
}

extension ZLMyPullRequestsController : ZLGithubItemListViewDelegate {
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void{
        
        weak var weakSelf = self
        ZLAdditionInfoServiceModel.shared().getMyPR(withType: self.filterType, after: nil, serialNumber: NSString.generateSerialNumber())
        { (resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false {

                weakSelf?.myPRView.githubItemListView.endRefreshWithError()
                guard let errorModel = resultModel.data as? ZLGithubRequestErrorModel else{
                    return
                }
                ZLToastView.showMessage(errorModel.message)

            } else {

                guard let data = resultModel.data as? ViewerPullRequestQuery.Data else {
                    weakSelf?.myPRView.githubItemListView.endRefreshWithError()
                    return
                }
                weakSelf?.afterCursor = data.viewer.pullRequests.pageInfo.endCursor
                var cellDatas : [ZLPullRequestTableViewCellDataForViewerPR] = []
                if let nodes = data.viewer.pullRequests.nodes {
                    for pr in nodes{
                        cellDatas.append(ZLPullRequestTableViewCellDataForViewerPR(data:pr!))
                    }
                    self.addSubViewModels(cellDatas)
                }
                weakSelf?.myPRView.githubItemListView.resetCellDatas(cellDatas: cellDatas)
            }
        }
        
    }
    
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) -> Void{
        
        weak var weakSelf = self
        ZLAdditionInfoServiceModel.shared().getMyPR(withType: self.filterType, after: afterCursor, serialNumber: NSString.generateSerialNumber())
        { (resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false {

                weakSelf?.myPRView.githubItemListView.endRefreshWithError()
                guard let errorModel = resultModel.data as? ZLGithubRequestErrorModel else{
                    return
                }
                ZLToastView.showMessage(errorModel.message)

            } else {

                guard let data = resultModel.data as? ViewerPullRequestQuery.Data else {
                    weakSelf?.myPRView.githubItemListView.endRefreshWithError()
                    return
                }
                weakSelf?.afterCursor = data.viewer.pullRequests.pageInfo.endCursor
                var cellDatas : [ZLPullRequestTableViewCellDataForViewerPR] = []
                if let nodes = data.viewer.pullRequests.nodes {
                    for pr in nodes{
                        cellDatas.append(ZLPullRequestTableViewCellDataForViewerPR(data:pr!))
                    }
                    self.addSubViewModels(cellDatas)
                }
                weakSelf?.myPRView.githubItemListView.appendCellDatas(cellDatas: cellDatas)
            }
        }
    }
}

