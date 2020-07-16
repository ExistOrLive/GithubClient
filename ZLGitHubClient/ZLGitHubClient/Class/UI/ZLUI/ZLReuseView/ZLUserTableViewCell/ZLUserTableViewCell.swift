//
//  ZLUserTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/1.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLUserTableViewCellDelegate : NSObjectProtocol {
}


class ZLUserTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var loginNameLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    weak var delegate : ZLUserTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 8.0
        self.containerView.layer.masksToBounds = true
        
        self.headImageView.layer.cornerRadius = 25.0
        self.headImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}


extension ZLUserTableViewCell
{
    func fillWithData(data : ZLUserTableViewCellData) -> Void
    {
        self.headImageView.sd_setImage(with: URL.init(string: data.getAvatarUrl() ?? ""), placeholderImage: UIImage.init(named: "default_avatar"))
        self.nameLabel.text = data.getName()
        self.loginNameLabel.text = data.getLoginName()
        self.companyLabel.text = data.getCompany()
        self.locationLabel.text = data.getLocation()
    }
}

