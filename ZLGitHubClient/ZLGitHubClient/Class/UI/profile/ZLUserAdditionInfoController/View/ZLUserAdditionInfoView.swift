//
//  ZLUserAdditionInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

enum ZLUserAdditionInfoViewType : Int
{
    case repositories
    case gists
    case users
}

class ZLUserAdditionInfoView: UIView {
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var itemListView: ZLGithubItemListView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib();
        
        itemListView.setTableViewHeader()
        itemListView.setTableViewFooter()
    }
    
    
    
}
