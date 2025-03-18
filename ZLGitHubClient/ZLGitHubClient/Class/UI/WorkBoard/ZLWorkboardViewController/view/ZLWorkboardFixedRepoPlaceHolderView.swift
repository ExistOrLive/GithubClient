//
//  ZLWorkboardFixedRepoPlaceHolderView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/3/18.
//  Copyright © 2025 ZM. All rights reserved.
//

import Foundation

class ZLWorkboardFixedRepoPlaceHolderView: UITableViewHeaderFooterView {
    
    lazy var label: UILabel = {
        let label = UILabel.init()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.init(named: "ZLLabelColor2")
        label.font = UIFont.init(name: Font_PingFangSCRegular, size: 13)
        label.text = ZLLocalizedString(string: "Add Fixed Repo", comment: "")
        label.textAlignment = .center
        return label
    }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
