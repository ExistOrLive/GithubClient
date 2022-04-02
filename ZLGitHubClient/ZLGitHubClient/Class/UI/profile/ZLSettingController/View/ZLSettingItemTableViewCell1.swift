//
//  ZLSettingItemTableViewCell1.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/1/21.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLSettingItemTableViewCell1: UITableViewCell {

    lazy var itemTypeLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label(withName: "ZLLabelColor1")
        label.font = .zlSemiBoldFont(withSize: 16)
        return label
    }()

    lazy var switchView: UISwitch = {
        let switchView = UISwitch()
        return switchView
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
        self.contentView.addSubview(switchView)
        self.contentView.addSubview(singleIineView)

        itemTypeLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }

        switchView.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.size.equalTo(CGSize(width: 50, height: 30))
            make.centerY.equalToSuperview()
        }

        singleIineView.snp.makeConstraints { make in
            make.left.equalTo(itemTypeLabel)
            make.bottom.right.equalToSuperview()
            make.height.equalTo(1.0 / UIScreen.main.scale)
        }
    }

}
