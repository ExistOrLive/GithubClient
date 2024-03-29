//
//  ZLWorkboardTableViewSectionHeader.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/20.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI

class ZLWorkboardTableViewSectionHeader: UITableViewHeaderFooterView {

    var titleLabel: UILabel!
    var button: UIButton!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        if #available(iOS 14.0, *) {
            self.backgroundConfiguration?.backgroundColor = UIColor.clear
        } else {
            self.backgroundColor = UIColor.clear
        }

        self.titleLabel = UILabel()
        self.titleLabel.textColor = UIColor(named: "ZLLabelColor1")
        self.titleLabel.font = UIFont.init(name: Font_PingFangSCSemiBold, size: 20)
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(20)
            make.bottom.equalToSuperview().offset(-10)
        }

        self.button = ZLBaseButton()
        self.button.titleLabel?.font = UIFont.init(name: Font_PingFangSCRegular, size: 13)
        self.button.setTitle(ZLLocalizedString(string: "Edit", comment: ""), for: .normal)
        self.addSubview(self.button)
        self.button.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 60, height: 30))
            make.centerY.equalTo(self.titleLabel)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right).offset(-20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
