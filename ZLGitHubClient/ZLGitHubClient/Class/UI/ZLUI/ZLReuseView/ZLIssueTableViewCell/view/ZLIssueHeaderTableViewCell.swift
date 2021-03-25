//
//  ZLIssueHeaderTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/16.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

protocol ZLIssueHeaderTableViewCellDelegate : NSObjectProtocol{
    func getIssueAuthorAvatarURL() -> String
    func getIssueRepoFullName() -> String
    func getIssueNumber() -> Int
    func getIssueState() -> String
    func getIssueTitle() -> String
}


class ZLIssueHeaderTableViewCell: UITableViewCell {
    
    var avatarImageView : UIImageView!
    var fullNameLabel : UILabel!
    var numberLabel: UILabel!
    var titleLabel: UILabel!
    var statusLabel: UILabel!

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func setUpUI(){
        
        self.selectionStyle = .none
        
        self.contentView.backgroundColor = UIColor(named: "ZLIssueCommentCellColor")
        
        let imageView = UIImageView()
        imageView.cornerRadius = 15
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        avatarImageView = imageView
        
        let label1 = UILabel()
        label1.textColor = UIColor(named: "ZLLabelColor1")
        label1.font = UIFont(name: Font_PingFangSCMedium, size: 14)
        self.contentView.addSubview(label1)
        label1.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(10)
            make.centerY.equalTo(avatarImageView)
        }
        fullNameLabel = label1
        
        let label2 = UILabel()
        label2.textColor = UIColor(named: "ZLLabelColor2")
        label2.font = UIFont(name: Font_PingFangSCRegular, size: 14)
        self.contentView.addSubview(label2)
        label2.snp.makeConstraints { (make) in
            make.left.equalTo(fullNameLabel.snp.right).offset(10)
            make.centerY.equalTo(avatarImageView)
        }
        numberLabel = label2
        
        let label3 = UILabel()
        label3.textColor = UIColor(named: "ZLLabelColor1")
        label3.font = UIFont(name: Font_PingFangSCSemiBold, size: 20)
        label3.numberOfLines = 0
        self.contentView.addSubview(label3)
        label3.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
        }
        titleLabel = label3
        
        let label4 = UILabel()
        label4.font = UIFont(name: Font_PingFangSCMedium, size: 12)
        label4.borderWidth = 1 / 3
        label4.cornerRadius = 8
        label4.textAlignment = .center
        self.contentView.addSubview(label4)
        label4.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(label3.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(25)
        }
        statusLabel = label4
        
//        let view = UIView()
//        view.backgroundColor = UIColor(named: "ZLSeperatorLineColor")
//        self.contentView.addSubview(view)
//        view.snp.makeConstraints { (make) in
//            make.left.right.bottom.equalToSuperview()
//            make.height.equalTo(1)
//        }
    }
    
    func fillWithData(data : ZLIssueHeaderTableViewCellDelegate) {
        
        avatarImageView.sd_setImage(with: URL(string: data.getIssueAuthorAvatarURL()), placeholderImage: UIImage(named: "default_avatar"))
        fullNameLabel.text = data.getIssueRepoFullName()
        numberLabel.text = "#\(data.getIssueNumber())"
        titleLabel.text = data.getIssueTitle()
        
        
        statusLabel.text = data.getIssueState()
        
        if statusLabel.text == "OPEN" {
            statusLabel.textColor = UIColor(named: "ZLIssueOpenedColor")
            statusLabel.backgroundColor = UIColor(named: "ZLIssueOpenedBackColor")
            statusLabel.borderColor = UIColor(named: "ZLIssueOpenedColor")
        } else if statusLabel.text == "CLOSED" {
            statusLabel.textColor =  UIColor(named: "ZLIssueClosedColor")
            statusLabel.backgroundColor = UIColor(named: "ZLIssueClosedBackColor")
            statusLabel.borderColor = UIColor(named: "ZLIssueClosedColor")
        }
    }

}


