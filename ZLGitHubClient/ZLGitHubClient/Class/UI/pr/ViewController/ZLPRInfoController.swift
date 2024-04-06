//
//  ZLPRInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/24.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService
import ZLUtilities

class ZLPRInfoController: ZLBaseViewController {

    // input model
    @objc var login: String?
    @objc var repoName: String?
    @objc var number: Int = 0

    var after: String?

    // view
    private lazy var itemListView: ZLGithubItemListView = {
        let itemListView = ZLGithubItemListView()
        itemListView.setTableViewHeader()
        itemListView.setTableViewFooter()
        itemListView.delegate = self
        return itemListView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ZLLocalizedString(string: "PullRequest", comment: "")

        self.zlNavigationBar.backButton.isHidden = false
        let button = UIButton.init(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: ZLIconFont.More.rawValue,
                                                     attributes: [.font: UIFont.zlIconFont(withSize: 30),
                                                                  .foregroundColor: UIColor.label(withName: "ICON_Common")]),
                                  for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)

        self.zlNavigationBar.rightButton = button

        // view
        self.contentView.addSubview(itemListView)
        itemListView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        itemListView.beginRefresh()
    }

    @objc func onMoreButtonClick(button: UIButton) {

        let path = "https://www.github.com/\(login?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")/\(repoName?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")/pull/\(number)"

        guard let url = URL(string: path) else { return }

        button.showShareMenu(title: path, url: url, sourceViewController: self)
    }
}

extension ZLPRInfoController {
    override func getEvent(_ event: Any?, fromSubViewModel subViewModel: ZLBaseViewModel) {
        if subViewModel is ZLGithubItemTableViewCellData {
            self.itemListView.batchUpdatesHeight()
        }
    }
}

extension ZLPRInfoController: ZLGithubItemListViewDelegate {

    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {

        guard let login = self.login, let repoName = self.repoName else {
            self.itemListView.endRefreshWithError()
            return
        }

        ZLServiceManager.sharedInstance.eventServiceModel?.getPRInfo(withLogin: login,
                                                                        repoName: repoName,
                                                                        number: Int32(number),
                                                                        after: nil,
                                                                        serialNumber: NSString.generateSerialNumber()) { [weak self](resultModel: ZLOperationResultModel) in

            if resultModel.result == false {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
                self?.itemListView.endRefreshWithError()
            } else {

                if let data = resultModel.data as? PrInfoQuery.Data {

                    self?.title = data.repository?.pullRequest?.title
                    
                    let cellDatas = self?.getCellDatasWithPRModel(data: data,
                                                                  firstPage: true) ?? []
                    self?.after = data.repository?.pullRequest?.timelineItems.pageInfo.endCursor
                    self?.addSubViewModels(cellDatas)
                    self?.itemListView.resetCellDatas(cellDatas: cellDatas)
                } else {
                    self?.itemListView.endRefreshWithError()
                }
            }
        }

    }

    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {

        guard let login = self.login, let repoName = self.repoName else {
            self.itemListView.endRefreshWithError()
            return
        }

        ZLServiceManager.sharedInstance.eventServiceModel?.getPRInfo(withLogin: login,
                                                                        repoName: repoName,
                                                                        number: Int32(number),
                                                                        after: after,
                                                                        serialNumber: NSString.generateSerialNumber()) { [weak self](resultModel: ZLOperationResultModel) in

            if resultModel.result == false {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
                self?.itemListView.endRefreshWithError()
            } else {

                if let data = resultModel.data as? PrInfoQuery.Data {

                    self?.title = data.repository?.pullRequest?.title

                    let cellDatas = self?.getCellDatasWithPRModel(data: data,
                                                                  firstPage: false) ?? []

                    self?.after = data.repository?.pullRequest?.timelineItems.pageInfo.endCursor
                    self?.addSubViewModels(cellDatas)
                    self?.itemListView.appendCellDatas(cellDatas: cellDatas)

                } else {
                    self?.itemListView.endRefreshWithError()
                }
            }
        }

    }

}


extension ZLPRInfoController {
    
    func getCellDatasWithPRModel(data: PrInfoQuery.Data, firstPage: Bool) -> [ZLGithubItemTableViewCellData] {

        let preCellDatas = itemListView.cellDatas
        var cellDatas: [ZLGithubItemTableViewCellData] = []

        if firstPage {
            let headercellData = ZLPullRequestHeaderTableViewCellData(data: data)
            cellDatas.append(headercellData)

            if let pullrequest = data.repository?.pullRequest {
                let preBodyCellData = preCellDatas.first { $0 is ZLPullRequestBodyTableViewCellData }
                let bodyCellData = ZLPullRequestBodyTableViewCellData(data: pullrequest,
                                                                      cellHeight: preBodyCellData?.getCellHeight())
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
                    let bodyCellData = ZLPullRequestCommentTableViewCellData(data: comment, cellHeight: preBodyCellData?.getCellHeight())
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
