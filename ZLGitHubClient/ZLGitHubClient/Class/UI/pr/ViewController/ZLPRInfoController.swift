//
//  ZLPRInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/24.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService
import ZLUtilities
import ZMMVVM

class ZLPRInfoController: ZMTableViewController {

    // input model
    @objc var login: String?
    @objc var repoName: String?
    @objc var number: Int = 0

    var after: String?
    
    var tmpCellDatas: [ZMBaseTableViewCellViewModel] = []

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
        
        self.title = "#\(number)"
    
        self.zmNavigationBar.addRightView(moreButton)
      
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        tableView.register(ZLPullRequestHeaderTableViewCell.self,
                           forCellReuseIdentifier: "ZLPullRequestHeaderTableViewCell")
        tableView.register(ZLPullRequestCommentTableViewCell.self,
                           forCellReuseIdentifier: "ZLPullRequestCommentTableViewCell")
        tableView.register(ZLPullRequestTimelineTableViewCell.self, 
                           forCellReuseIdentifier: "ZLPullRequestTimelineTableViewCell")
        
        self.setRefreshViews(types: [.header,.footer])
    }
    
    override func refreshLoadNewData() {
        loadData(isLoadNew:true)
    }
    
    override func refreshLoadMoreData() {
        loadData(isLoadNew:false)
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
}

// MARK: - Action
extension ZLPRInfoController {
    @objc func onMoreButtonClick(button: UIButton) {

        let path = "https://www.github.com/\(login?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")/\(repoName?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")/pull/\(number)"

        guard let url = URL(string: path) else { return }

        button.showShareMenu(title: path, url: url, sourceViewController: self)
    }
}

// MARK: - Request
extension ZLPRInfoController {

    func loadData(isLoadNew: Bool) {
        ZLEventServiceShared()?.getPRInfo(withLogin: login ?? "",
                                          repoName: repoName ?? "",
                                          number: Int32(number),
                                          after: isLoadNew ? nil : after,
                                          serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel: ZLOperationResultModel) in
            guard let self else { return }
    
            
            if resultModel.result,
               let data = resultModel.data as? PrInfoQuery.Data {
                
                self.after = data.repository?.pullRequest?.timelineItems.pageInfo.endCursor
                let hasNextPage = data.repository?.pullRequest?.timelineItems.pageInfo.hasNextPage ?? false
                let cellDatas = self.getCellDatasWithPRModel(data: data,
                                                             firstPage: isLoadNew)
               
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(200), execute: {
                    self.zm_addSubViewModels(cellDatas)
                    if isLoadNew {
                        self.tmpCellDatas = cellDatas
                        self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                        self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDatas)]
                    } else {
                        self.tmpCellDatas.append(contentsOf: cellDatas)
                        self.sectionDataArray.first?.cellDatas.append(contentsOf: cellDatas)
                    }
                    
                    
                    self.tableView.reloadData()
                    self.endRefreshViews(noMoreData: !hasNextPage)
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
}


extension ZLPRInfoController {
    
    func getCellDatasWithPRModel(data: PrInfoQuery.Data, firstPage: Bool) -> [ZMBaseTableViewCellViewModel] {

        let preCellDatas = tmpCellDatas
        
        var cellDatas: [ZMBaseTableViewCellViewModel] = []

        if firstPage {
            let headercellData = ZLPullRequestHeaderTableViewCellData(data: data)
            cellDatas.append(headercellData)

            if let pullrequest = data.repository?.pullRequest {
                let preBodyCellData = preCellDatas.first { $0 is ZLPullRequestBodyTableViewCellData }
                let bodyCellData = ZLPullRequestBodyTableViewCellData(data: pullrequest,
                                                                      cellHeight: preBodyCellData?.zm_cellHeight)
                cellDatas.append(bodyCellData)
            }
        }

        if let timelines = data.repository?.pullRequest?.timelineItems.nodes {
            for timeline in timelines {
                if let comment =  timeline?.asIssueComment {
                    let preBodyCellData = preCellDatas.first {
                        if let commentCellData =  $0 as? ZLPullRequestCommentTableViewCellData,
                           commentCellData.data.id ==  comment.id {
                            return true
                        }
                        return false
                    }
                    let bodyCellData = ZLPullRequestCommentTableViewCellData(data: comment, 
                                                                             cellHeight: preBodyCellData?.zm_cellHeight)
                    cellDatas.append(bodyCellData)
                } else if timeline?.asSubscribedEvent != nil ||
                            timeline?.asUnsubscribedEvent != nil ||
                            timeline?.asMentionedEvent != nil ||
                            timeline?.asAddedToProjectEvent != nil ||
                            timeline?.asRemovedFromProjectEvent != nil {
                    continue
                } else if let timeline  = timeline {
                    let timelinedata = ZLPullRequestTimelineTableViewCellData(data: timeline)
                    cellDatas.append(timelinedata)
                }
            }
        }

        return cellDatas
    }
}
