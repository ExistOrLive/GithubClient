//
//  ZLNewsTableViewCell.swift
//  ZLGitHubClient
//
//  Created by LongMac on 2019/9/1.
//  Copyright © 2019年 ZM. All rights reserved.
//

import UIKit


class ZLNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containView: UIView!
    
    @IBOutlet weak var avatarButton: UIButton!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib()
    {
        self.avatarButton.layer.cornerRadius = 20
        self.avatarButton.layer.masksToBounds = true
        self.autoresizingMask = UIViewAutoresizing.init(rawValue: 0)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.containView.layer.cornerRadius = 2
        self.containView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
}
