//
//  ZLSettingItemTableViewCell1.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/1/21.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLSettingItemTableViewCell1: UITableViewCell {
    
    @IBOutlet weak var itemTypeLabel: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var singleIineView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
}
