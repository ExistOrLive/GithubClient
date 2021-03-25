//
//  ZLPullRequestHeaderTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/24.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLPullRequestHeaderTableViewCellData: ZLGithubItemTableViewCellData {
    
    typealias Data = PrInfoQuery.Data
    
    let data : Data
    
    init(data : Data) {
        self.data = data
        super.init()
    }

    
    override func getCellReuseIdentifier() -> String {
        return "ZLPullRequestHeaderTableViewCell";
    }
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func clearCache() {
        
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        super.bindModel(targetModel, andView: targetView)
        if let cell : ZLPullRequestHeaderTableViewCell = targetView as? ZLPullRequestHeaderTableViewCell {
            cell.fillWithData(data:self)
        }
    }
}


extension ZLPullRequestHeaderTableViewCellData : ZLPullRequestHeaderTableViewCellDelegate {
    
    func getPRAuthorAvatarURL() -> String{
        data.repository?.pullRequest?.author?.avatarUrl ?? ""
    }
    
    func getPRRepoFullName() -> String{
        data.repository?.nameWithOwner ?? ""
    }
    func getPRNumber() -> Int {
        data.repository?.pullRequest?.number ?? 0
    }
    
    func getPRState() -> String {
        data.repository?.pullRequest?.state.rawValue ?? ""
    }
    
    func getPRTitle() -> String {
        data.repository?.pullRequest?.title ?? ""
    }
    
    func getCommitNumber() -> Int {
        data.repository?.pullRequest?.commits.totalCount ?? 0
    }
    
    func getFileChangedNumber() -> Int {
        data.repository?.pullRequest?.changedFiles ?? 0
    }
    
    func getAdditionFileNumber() -> Int {
        data.repository?.pullRequest?.additions ?? 0
    }
    func getDeletedFileNumber() -> Int {
        data.repository?.pullRequest?.deletions ?? 0
    }
    func getRef() -> String {
        "\(data.repository?.pullRequest?.headRepository?.owner.login ?? "") : \(data.repository?.pullRequest?.headRefName ?? "")  -> \(data.repository?.pullRequest?.baseRepository?.owner.login ?? "") : \(data.repository?.pullRequest?.baseRefName ?? "")"
    }
    
}
