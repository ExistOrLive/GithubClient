//
//  ZLNotificationTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/8.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

@objc protocol  ZLNotificationTableViewCellDelegate: NSObjectProtocol{
    func onNotificationTitleClicked() -> Void
}


class ZLNotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notificationTypeImageView: UIImageView!
    
    @IBOutlet weak var notificationTitleLabel: YYLabel!
    @IBOutlet weak var notificationDescLabel: UILabel!
    @IBOutlet weak var notificationReasonLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    weak var delegate : ZLNotificationTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func fillWithData(data : ZLNotificationTableViewCellData) {
        self.notificationDescLabel.text = data.getNotificationSubjectTitle()
        self.notificationTitleLabel.attributedText = data.getNotificationTitle()
        self.notificationReasonLabel.text = data.getNotificationReason()
        self.timeLabel.text = data.getNotificationTimeStr()
        
        if "PullRequest" == data.getNotificationSubjectType() {
            self.notificationTypeImageView.image = UIImage.init(named: "pr_opened")
        } else if "Issue" == data.getNotificationSubjectType() {
            self.notificationTypeImageView.image = UIImage.init(named: "issue_opened")
        } else if "RepositoryVulnerabilityAlert" == data.getNotificationSubjectType(){
            self.notificationTypeImageView.image = UIImage.init(named: "security_alert")
        } else {
           self.notificationTypeImageView.image = nil
        }
    }
    
}
