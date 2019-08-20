//
//  ZLRepoHeaderInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLRepoHeaderInfoView: ZLBaseView {

    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var issuesNumLabel: UILabel!
    
    @IBOutlet weak var starsNumLabel: UILabel!
    @IBOutlet weak var forksNumLabel: UILabel!
    
    @IBOutlet weak var watchersNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headImageView.layer.cornerRadius = 30.0
        self.headImageView.layer.masksToBounds = true
        
    }
    
}
