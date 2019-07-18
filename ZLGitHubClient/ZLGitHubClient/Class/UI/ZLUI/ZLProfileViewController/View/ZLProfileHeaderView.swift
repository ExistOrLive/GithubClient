//
//  ZLProfileHeaderView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/15.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLProfileHeaderView: ZLBaseView {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    
    @IBOutlet weak var repositoryNum: UILabel!
    @IBOutlet weak var gistNumLabel: UILabel!
    @IBOutlet weak var followersNumLabel: UILabel!
    @IBOutlet weak var followingNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.headImageView.layer.cornerRadius = 30.0;
        
    }
}
