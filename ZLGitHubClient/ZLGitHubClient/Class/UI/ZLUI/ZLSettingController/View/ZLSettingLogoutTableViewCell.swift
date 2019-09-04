//
//  ZLSettingLogoutTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSettingLogoutTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ZLLocalizedString(string: "logout", comment: "注销")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
}
