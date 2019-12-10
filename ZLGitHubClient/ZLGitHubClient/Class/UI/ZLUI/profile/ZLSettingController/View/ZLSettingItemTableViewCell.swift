//
//  ZLSettingItemTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSettingItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemTypeLabel: UILabel!
    @IBOutlet weak var itemValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
}
