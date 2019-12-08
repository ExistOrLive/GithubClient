//
//  ZLProfileTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/16.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemContentLabel: UILabel!
    @IBOutlet weak var nextImageView: UIImageView!
    @IBOutlet weak var singleLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
}
