//
//  ZLPullRequestTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLPullRequestTableViewCellDelegate : NSObjectProtocol {
    
    func getTitle() -> String?
    
    func getAssistInfo() -> String?
    
    func getState() -> ZLGithubPullRequestState
    
    func isMerged() -> Bool 
}

class ZLPullRequestTableViewCell: UITableViewCell {
    
    weak var  delegate : ZLPullRequestTableViewCellDelegate?
    
    @IBOutlet weak var typeImageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var assitInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 8.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    
    func fillWithData(data : ZLPullRequestTableViewCellDelegate)
    {
        self.delegate = data
        
        self.titleLabel.text = data.getTitle()
        self.assitInfoLabel.text = data.getAssistInfo()
        
        if data.getState() == .opened {
            self.typeImageView?.image = UIImage.init(named: "pr_opened")
        } else if data.isMerged() {
            self.typeImageView?.image = UIImage.init(named: "pr_merged")
        } else {
            self.typeImageView?.image = UIImage.init(named: "pr_closed")
        }
        
    }
    
}
