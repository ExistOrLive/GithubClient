//
//  ZLRepoInfoTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLRepoInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repoInfoTypeLabel: UILabel!
    @IBOutlet weak var repoInfoDetailLabel: UILabel!
    
    @IBOutlet weak var singleLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
}
