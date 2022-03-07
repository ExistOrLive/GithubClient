//
//  ZLSimpleUserTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/23.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit

protocol ZLSimpleUserTableViewCellDataSource {
    
    var avatarUrl: String { get }
    
    var loginName: String { get }
    
}

class ZLSimpleUserTableViewCell: UITableViewCell {
    
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
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
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

extension ZLSimpleUserTableViewCell: ViewUpdatable {
    
    func fillWithData(viewData: ZLSimpleUserTableViewCellDataSource) {
        
        avatarImageView.sd_setImage(with: URL(string: viewData.avatarUrl), placeholderImage: UIImage(named: "default_avatar"))
        fullNameLabel.text = viewData.loginName
    }
}
