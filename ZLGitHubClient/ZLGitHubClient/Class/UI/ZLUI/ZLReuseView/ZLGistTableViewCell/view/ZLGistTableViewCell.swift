//
//  ZLGistTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/2/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLGistTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var gistNameLabel: UILabel!
    
    @IBOutlet weak var fileLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var privateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.containerView.layer.cornerRadius = 8.0;
        self.containerView.layer.masksToBounds = true
        
        self.imageButton.layer.cornerRadius = 25.0
        self.imageButton.layer.masksToBounds = true
        
        self.privateLabel.layer.cornerRadius = 2.0
        self.privateLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.privateLabel.layer.borderWidth = 1.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
