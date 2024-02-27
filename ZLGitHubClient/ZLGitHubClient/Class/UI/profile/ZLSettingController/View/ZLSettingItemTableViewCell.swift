//
//  ZLSettingItemTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLUtilities

class ZLSettingItemTableViewCell: UITableViewCell {

    lazy var itemTypeLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label(withName: "ZLLabelColor1")
        label.font = .zlSemiBoldFont(withSize: 16)
        return label
    }()

    lazy var itemValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label(withName: "ZLLabelColor2")
        label.font = .zlRegularFont(withSize: 13)
         return label
    }()

    lazy var nextLabel: UILabel = {
        let nextTag = UILabel()
        nextTag.font = UIFont.zlIconFont(withSize: 15)
        nextTag.textColor = UIColor(named: "ICON_Common")
        nextTag.text = ZLIconFont.NextArrow.rawValue
        return nextTag
    }()

    lazy var singleIineView: UIView = {
        let view = UIView()
        view.backgroundColor = .back(withName: "ZLSeperatorLineColor")
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {

        self.contentView.backgroundColor = .back(withName: "ZLCellBack")

        self.contentView.addSubview(itemTypeLabel)
        self.contentView.addSubview(itemValueLabel)
        self.contentView.addSubview(nextLabel)
        self.contentView.addSubview(singleIineView)

        itemTypeLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }

        nextLabel.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.size.equalTo(CGSize(width: 15, height: 20))
            make.centerY.equalToSuperview()
        }

        itemValueLabel.snp.makeConstraints { make in
            make.right.equalTo(-50)
            make.centerY.equalToSuperview()
        }

        singleIineView.snp.makeConstraints { make in
            make.left.equalTo(itemTypeLabel)
            make.bottom.right.equalToSuperview()
            make.height.equalTo(1.0 / UIScreen.main.scale)
        }
    }

}
