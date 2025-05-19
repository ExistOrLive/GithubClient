//
//  ZLCommitInfoFilePathHeaderView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/19.
//  Copyright © 2025 ZM. All rights reserved.
//

import UIKit
import ZMMVVM

class ZLCommitInfoFilePathHeaderView: UITableViewHeaderFooterView {
    
    var viewData: ZLCommitInfoFilePathHeaderViewData? {
        zm_viewModel as? ZLCommitInfoFilePathHeaderViewData
    }
    
    lazy var titleLabel: UILabel =  {
        let label = UILabel()
        label.font = .zlMediumFont(withSize: 16)
        label.textColor = .label(withName: "ZLLabelColor1")
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingHead
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .back(withName: "ZLCellBack")
        contentView.addSubview(self.titleLabel)
 
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ZLCommitInfoFilePathHeaderView: ZMBaseViewUpdatableWithViewData {
    func zm_fillWithViewData(viewData: ZLCommitInfoFilePathHeaderViewData) {
        self.titleLabel.text = viewData.filePath
    }
}
