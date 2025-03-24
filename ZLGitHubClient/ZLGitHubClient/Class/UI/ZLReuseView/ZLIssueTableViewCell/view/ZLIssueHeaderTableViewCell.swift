//
//  ZLIssueHeaderTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/16.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import YYText
import ZMMVVM

protocol ZLIssueHeaderTableViewCellDelegate: NSObjectProtocol {
    func getIssueAuthorLogin() -> String
    func getIssueAuthorAvatarURL() -> String
    func getIssueRepoFullName() -> NSAttributedString
    func getIssueNumber() -> Int
    func getIssueState() -> String
    func getIssueTitle() -> String

    func onIssueAvatarClicked()
}

class ZLIssueHeaderTableViewCell: UITableViewCell {

    var delegate: ZLIssueHeaderTableViewCellDelegate? {
        zm_viewModel as? ZLIssueHeaderTableViewCellDelegate
    }

    var avatarButton: UIButton!
    var fullNameLabel: YYLabel!
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

    func setUpUI() {

        self.selectionStyle = .none

        self.contentView.backgroundColor = UIColor(named: "ZLIssueCommentCellColor")

        let button = UIButton(type: .custom)
        button.cornerRadius = 15
        self.contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        avatarButton = button
        avatarButton.addTarget(self, action: #selector(onAvatarButtonClicked), for: .touchUpInside)

        let label1 = YYLabel()
        self.contentView.addSubview(label1)
        label1.snp.makeConstraints { (make) in
            make.left.equalTo(avatarButton.snp.right).offset(10)
            make.centerY.equalTo(avatarButton)
        }
        fullNameLabel = label1

        let label2 = UILabel()
        label2.textColor = UIColor(named: "ZLLabelColor2")
        label2.font = UIFont(name: Font_PingFangSCRegular, size: 14)
        self.contentView.addSubview(label2)
        label2.snp.makeConstraints { (make) in
            make.left.equalTo(fullNameLabel.snp.right).offset(10)
            make.centerY.equalTo(avatarButton)
        }
        numberLabel = label2

        let label3 = UILabel()
        label3.textColor = UIColor(named: "ZLLabelColor1")
        label3.font = UIFont(name: Font_PingFangSCSemiBold, size: 20)
        label3.numberOfLines = 4
        self.contentView.addSubview(label3)
        label3.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(avatarButton.snp.bottom).offset(10)
        }
        titleLabel = label3

        let label4 = UILabel()
        label4.font = UIFont(name: Font_PingFangSCMedium, size: 12)
        label4.borderWidth = 1 / 3
        label4.cornerRadius = 5
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
    }

 

    @objc func onAvatarButtonClicked() {
        self.delegate?.onIssueAvatarClicked()
    }

}

extension ZLIssueHeaderTableViewCell: ZMBaseViewUpdatableWithViewData {
    func zm_fillWithViewData(viewData data: ZLIssueHeaderTableViewCellDelegate) {
        avatarButton.loadAvatar(login: data.getIssueAuthorLogin(), avatarUrl:  data.getIssueAuthorAvatarURL())
        fullNameLabel.attributedText = data.getIssueRepoFullName()
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
