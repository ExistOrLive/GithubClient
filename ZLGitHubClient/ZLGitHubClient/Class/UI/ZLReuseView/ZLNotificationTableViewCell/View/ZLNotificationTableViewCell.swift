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
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLCellBack")
        view.cornerRadius = 8.0
        return view
    }()
    
    private lazy var notificationTypeLabel: UILabel = {
        let label = UILabel()
        label.text = ZLIconFont.Workflow.rawValue
        label.font = UIFont.zlIconFont(withSize: 20)
        return label
    }()
    

    lazy var notificationTitleLabel: YYLabel = {
       let label = YYLabel()
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = ZLKeyWindowWidth - 90
        return label
    }()
    
    
    lazy var notificationDescLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label(withName: "ZLLabelColor3")
        label.font = .zlRegularFont(withSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var notificationReasonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label(withName: "ZLLabelColor4")
        label.font = .zlSemiBoldFont(withSize: 15)
         return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label(withName: "ZLLabelColor2")
        label.font = .zlRegularFont(withSize: 15)
         return label
    }()
    
    weak var delegate : ZLNotificationTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.notificationTitleLabel.preferredMaxLayoutWidth = ZLKeyWindowWidth - 90
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    
    private func setupUI(){
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
        
        containerView.addSubview(notificationTypeLabel)
        containerView.addSubview(notificationTitleLabel)
        containerView.addSubview(notificationDescLabel)
        containerView.addSubview(notificationReasonLabel)
        containerView.addSubview(timeLabel)
        
        notificationTypeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        notificationTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(notificationTypeLabel.snp.right).offset(10)
            make.centerY.equalTo(notificationTypeLabel)
            make.right.equalToSuperview().offset(-20)
        }
        
        notificationDescLabel.snp.makeConstraints { make in
            make.left.right.equalTo(notificationTitleLabel)
            make.top.equalTo(notificationTitleLabel.snp.bottom).offset(13.5)
        }
        
        notificationReasonLabel.snp.makeConstraints { make in
            make.left.equalTo(notificationTitleLabel)
            make.top.equalTo(notificationDescLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-12.5)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.right.equalTo(notificationTitleLabel)
            make.centerY.equalTo(notificationReasonLabel)
        }
    }
    
    
    func fillWithData(data : ZLNotificationTableViewCellData) {
        self.notificationDescLabel.text = data.getNotificationSubjectTitle()
        self.notificationTitleLabel.attributedText = data.getNotificationTitle()
        self.notificationReasonLabel.text = data.getNotificationReason()
        self.timeLabel.text = data.getNotificationTimeStr()
        
        switch data.getNotificationSubjectType() {
        case "PullRequest":
            self.notificationTypeLabel.text = ZLIconFont.PR.rawValue
            self.notificationTypeLabel.textColor = UIColor.iconColor(withName: "ICON_PROpenedColor")
        case "Issue":
            self.notificationTypeLabel.text = ZLIconFont.IssueOpen.rawValue
            self.notificationTypeLabel.textColor = UIColor.iconColor(withName: "ICON_IssueOpenedColor")
        case "RepositoryVulnerabilityAlert":
            self.notificationTypeLabel.text = ZLIconFont.Alert.rawValue
            self.notificationTypeLabel.textColor = UIColor.iconColor(withName: "ICON_Common")
        case "Discussion":
            self.notificationTypeLabel.text = ZLIconFont.Discussion.rawValue
            self.notificationTypeLabel.textColor = UIColor.iconColor(withName: "ICON_Common")
        case "Release":
            self.notificationTypeLabel.text = ZLIconFont.Tag.rawValue
            self.notificationTypeLabel.textColor = UIColor.iconColor(withName: "ICON_Common")
        case "Commit":
            self.notificationTypeLabel.text = ZLIconFont.Commit.rawValue
            self.notificationTypeLabel.textColor = UIColor.iconColor(withName: "ICON_Common")
        default:
            self.notificationTypeLabel.text = ZLIconFont.Notification.rawValue
            self.notificationTypeLabel.textColor = UIColor.iconColor(withName: "ICON_Common")
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBackSelected")
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }
}
