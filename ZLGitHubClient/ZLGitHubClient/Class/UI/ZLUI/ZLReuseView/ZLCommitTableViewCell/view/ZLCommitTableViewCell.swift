//
//  ZLCommitTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLCommitTableViewCellDelegate : NSObjectProtocol{
}

class ZLCommitTableViewCell: UITableViewCell {
    
    weak var delegate : ZLCommitTableViewCellDelegate?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var assitLabel: UILabel!
    @IBOutlet weak var shaButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 8.0
        self.avatarImageView.layer.cornerRadius = 15
        self.avatarImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillWithData(cellData : ZLCommitTableViewCellData)
    {
        self.titleLabel.text = cellData.getCommitTitle()
        self.avatarImageView.sd_setImage(with: URL.init(string: cellData.getCommiterAvaterURL() ?? ""), placeholderImage: UIImage.init(named: "default_avatar"))
        self.assitLabel.text = cellData.getAssistInfo()
        self.shaButton.setTitle(cellData.getCommitSha(), for: .normal)
    }
    
    
}

