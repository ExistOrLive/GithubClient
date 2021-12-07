//
//  ZLGithubItemCollectionViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/5.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit


@objc protocol ZLGithubItemCollectionViewCellDataProtocol : NSObjectProtocol
{
    func getCellReuseIdentifier() -> String;

    func onCellSingleTap()
}

class ZLGithubItemCollectionViewCellData: ZLBaseViewModel,ZLGithubItemCollectionViewCellDataProtocol {
    
    func getCellReuseIdentifier() -> String{
        return "UICollectionViewCell"
    }

    func onCellSingleTap() {
        
    }
}
