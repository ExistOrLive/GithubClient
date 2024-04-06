//
//  ZLSettingLogoutTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSettingLogoutTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        contentView.backgroundColor = UIColor(named: "ZLCellBack")
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: Lazy View
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ZLLocalizedString(string: "logout", comment: "登出")
        label.textColor = UIColor(named:"ZLLabelColor1")
        label.font = .zlRegularFont(withSize: 18)
        return label
    }()

}
