//
//  ZLDiscussionTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/2.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService

class ZLDiscussionTableViewCellData: ZLGithubItemTableViewCellData {
    
    typealias DiscussionData = SearchItemQuery.Data.Search.Node.AsDiscussion
    
    let data: DiscussionData
    
    init(data: DiscussionData) {
        self.data = data
        super.init()
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLDiscussionTableViewCell"
    }

    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }

    override func onCellSingleTap() {
        if let url = URL.init(string: data.url) {
            ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,
                                  params: ["requestURL": url],
                                  animated: true)
        }
    }
    
    override func clearCache() {

    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        super.bindModel(targetModel, andView: targetView)
        if let cell = targetView as? ZLDiscussionTableViewCell {
            cell.fillWithData(viewData: self)
        }
    }
    
}

extension ZLDiscussionTableViewCellData: ZLDiscussionTableViewCellDataSourceAndDelegate {
    
    var repositoryFullName: String {
        data.repository.nameWithOwner
    }
    
    var title: String {
        data.title
    }
    
    var createTime: String {
        NSDate.getLocalStrSinceCurrentTime(withGithubTime: data.createdAt)
    }
    
    
    var upvoteNumber: Int {
        data.upvoteCount
    }
    
    var commentNumber: Int {
        data.comments.totalCount
    }
    
    func onClickRepoFullName() {
        
    }
    
    func hasLongPressAction() -> Bool {
        true
    }

    func longPressAction(view: UIView) {
        
    }
    
}
