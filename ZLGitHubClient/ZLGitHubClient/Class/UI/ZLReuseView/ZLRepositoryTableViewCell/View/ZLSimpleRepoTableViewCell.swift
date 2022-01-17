//
//  ZLSimpleRepoTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/24.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLSimpleRepoTableViewCell: UITableViewCell {

    var avatarImageView: UIImageView!
    var fullNameLabel: UILabel!
    var singleLineView: UIView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpUI()
    }

    func setUpUI() {

        self.backgroundColor = UIColor.clear

        self.contentView.backgroundColor = UIColor(named: "ZLCellBack")

        self.avatarImageView = UIImageView()
        self.contentView.addSubview(self.avatarImageView)
        self.avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.left.equalToSuperview().offset(15)
        }
        self.avatarImageView.circle = true

        self.fullNameLabel = UILabel()
        self.fullNameLabel.font = UIFont(name: Font_PingFangSCMedium, size: 14)
        self.fullNameLabel.textColor = UIColor(named: "ZLLabelColor1")
        self.contentView.addSubview(self.fullNameLabel)
        self.fullNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarImageView.snp_right).offset(10)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }

        self.singleLineView = UIView()
        self.singleLineView.backgroundColor = UIColor(named: "ZLSeperatorLineColor")
        self.contentView.addSubview(self.singleLineView)
        self.singleLineView.snp.makeConstraints { (make) in
            make.left.equalTo(self.fullNameLabel)
            make.height.equalTo(0.3)
            make.bottom.right.equalToSuperview()
        }

    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }

}
