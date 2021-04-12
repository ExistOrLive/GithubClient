//
//  ZLUserTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/1.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLUserTableViewCellDelegate : NSObjectProtocol {
    
    func getName() -> String?
    
    func getLoginName() -> String?
    
    func getAvatarUrl() -> String?
    
    func getCompany() -> String?
    
    func getLocation() -> String?
    
    func desc() -> String?
}


class ZLUserTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
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
    func fillWithData(data : ZLUserTableViewCellDelegate) -> Void
    {
        self.delegate = data
        
        self.headImageView.sd_setImage(with: URL.init(string: data.getAvatarUrl() ?? ""), placeholderImage: UIImage.init(named: "default_avatar"))
        self.nameLabel.text = "\(data.getName() ?? "")(\(data.getLoginName() ?? ""))"
        self.descLabel.text = data.desc()
       
    }
}

