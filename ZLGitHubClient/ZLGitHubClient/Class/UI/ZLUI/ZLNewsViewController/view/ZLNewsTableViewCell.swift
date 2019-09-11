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
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib()
    {
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.lc_with/2
        self.avatarImageView.layer.masksToBounds = true
    }
    
//    override var frame: CGRect
//    {
//        didSet
//        {
//            var newFrame: CGRect = frame
//            newFrame.origin.x += 10;
//            newFrame.origin.y += 10;
//            newFrame.size.height -= 10;
//            newFrame.size.width -= 20;
//
//            super.frame = newFrame
//        }
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
