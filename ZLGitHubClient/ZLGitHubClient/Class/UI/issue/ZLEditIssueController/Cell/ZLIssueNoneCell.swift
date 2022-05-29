//
//  ZLIssueNoneCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/8.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension

protocol ZLIssueNoneCellDataSource {
    var info: String { get }
}

class ZLIssueNoneCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.font = .zlRegularFont(withSize: 12)
        return label
    }()
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(45)
        }
    }

}

extension ZLIssueNoneCell: ZLViewUpdatableWithViewData {
    
    func fillWithViewData(viewData: ZLIssueNoneCellDataSource) {
        infoLabel.text = viewData.info
    }
}
