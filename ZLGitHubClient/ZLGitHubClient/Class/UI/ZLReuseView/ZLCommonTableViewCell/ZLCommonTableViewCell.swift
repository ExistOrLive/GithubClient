//
//  ZLCommonTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/5.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLUIUtilities
import ZLBaseExtension

protocol ZLCommonTableViewCellDataSourceAndDelegate: ZLGithubItemTableViewCellDataProtocol {

    var canClick: Bool { get }

    var title: String { get }

    var info: String { get }

}

class ZLCommonTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        contentView.backgroundColor = UIColor(named: "ZLCellBack")

        contentView.addSubview(titleLabel)
        contentView.addSubview(subLabel)
        contentView.addSubview(nextLabel)

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }

        subLabel.snp.makeConstraints { make in
            make.right.equalTo(-50)
            make.centerY.equalToSuperview()
        }

        nextLabel.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
        }

    }

    // MARK: View
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zlMediumFont(withSize: 16)
        label.textColor = UIColor(named: "ZLLabelColor1")
        return label
    }()

    lazy var subLabel: UILabel = {
        let label = UILabel()
        label.font = .zlRegularFont(withSize: 12)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var nextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlIconFont(withSize: 15)
        label.textColor = UIColor(named: "ICON_Common")
        label.text = ZLIconFont.NextArrow.rawValue
        return label
    }()
}


extension ZLCommonTableViewCell: ZLViewUpdatableWithViewData {
    // MARK: fillWithData
    func fillWithViewData(viewData: ZLCommonTableViewCellDataSourceAndDelegate) {
        selectionStyle = viewData.canClick ? .gray : .none
        titleLabel.text = viewData.title
        subLabel.text = viewData.info
        nextLabel.isHidden = !viewData.canClick
    }
}
