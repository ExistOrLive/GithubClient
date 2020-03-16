
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
}


class ZLGithubItemTableViewCellData : ZLBaseViewModel,ZLGithubItemTableViewCellDataProtocol
{
    func getCellReuseIdentifier() -> String {
        return "UITableViewCell";
    }
    
    func getCellHeight() -> CGFloat {
        return 0;
    }
}
