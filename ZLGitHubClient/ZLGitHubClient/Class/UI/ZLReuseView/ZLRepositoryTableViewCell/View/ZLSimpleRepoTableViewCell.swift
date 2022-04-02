//
//  ZLSimpleRepoTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/24.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLSimpleRepoTableViewCell: UITableViewCell {

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
  
        self.contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.left.equalToSuperview().offset(15)
        }
        avatarImageView.circle = true

        self.contentView.addSubview(fullNameLabel)
        fullNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp_right).offset(10)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        
        self.contentView.addSubview(singleLineView)
        singleLineView.snp.makeConstraints { (make) in
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
    
    
    // MARK: Lazy View
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Font_PingFangSCMedium, size: 14)
        label.textColor = UIColor(named: "ZLLabelColor1")
        return label
    }()
    
    lazy var singleLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLSeperatorLineColor")
        return view
    }()
}
