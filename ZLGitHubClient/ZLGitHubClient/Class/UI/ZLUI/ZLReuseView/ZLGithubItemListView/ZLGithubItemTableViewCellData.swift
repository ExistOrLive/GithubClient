
//
//  ZLGithubItemTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import Foundation

@objc protocol ZLGithubItemTableViewCellDataProtocol : NSObjectProtocol
{
    func getCellReuseIdentifier() -> String;
     
    func getCellHeight() -> CGFloat;
    
    func onCellSingleTap()
}


class ZLGithubItemTableViewCellData : ZLBaseViewModel,ZLGithubItemTableViewCellDataProtocol
{
    func getCellReuseIdentifier() -> String {
        return "UITableViewCell";
    }
    
    func getCellHeight() -> CGFloat {
        return 0;
    }
    
    func onCellSingleTap() {
        
    }
    
}

extension ZLGithubItemTableViewCellData {
    
    class func getCellDataWithData(data: Any?) -> ZLGithubItemTableViewCellData?{
        
        if data == nil {
            return nil
        } else if data! is ZLGithubRepositoryModel {
            return ZLRepositoryTableViewCellData.init(data: data! as! ZLGithubRepositoryModel)
        } else if data! is ZLGithubUserModel {
            return ZLUserTableViewCellData.init(userModel: data! as! ZLGithubUserModel)
        } else if data! is ZLGithubPullRequestModel {
            return ZLPullRequestTableViewCellData.init(eventModel: data! as! ZLGithubPullRequestModel)
        } else if data! is ZLGithubEventModel {
            return ZLEventTableViewCellData.getCellDataWithEventModel(eventModel: data! as! ZLGithubEventModel)
        } else if data! is ZLGithubGistModel {
            return ZLGistTableViewCellData.init(data: data! as! ZLGithubGistModel)
        } else if data! is ZLGithubCommitModel {
            return ZLCommitTableViewCellData.init(commitModel: data! as! ZLGithubCommitModel)
        } else if data! is ZLGithubIssueModel {
            return ZLIssueTableViewCellData.init(issueModel: data! as! ZLGithubIssueModel)
        } else {
            return nil
        }
    }
    
}
