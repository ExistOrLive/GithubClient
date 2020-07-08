//
//  ZLNotificaitonView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLNotificationView: ZLBaseView {

    @IBOutlet weak var filterLabel: UILabel!
    
    @IBOutlet weak var githubItemListView: ZLGithubItemListView!
    
    override func awakeFromNib() {
        self.githubItemListView.setTableViewHeader()
        self.githubItemListView.setTableViewFooter()
    }
    
}
