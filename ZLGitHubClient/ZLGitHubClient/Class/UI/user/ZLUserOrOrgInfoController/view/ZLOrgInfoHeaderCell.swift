//
//  ZLOrgInfoHeaderCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/12.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZMMVVM

protocol ZLOrgInfoHeaderCellDataSourceAndDelegate: AnyObject {

    var name: String {get}
    var loginName: String {get}
    var time: String {get}
    var desc: String {get}
    var avatarUrl: String {get}
}

class ZLOrgInfoHeaderCell: UITableViewCell {

    var delegate: ZLOrgInfoHeaderCellDataSourceAndDelegate? {
        zm_viewModel as? ZLOrgInfoHeaderCellDataSourceAndDelegate
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = UIColor(named: "ZLCellBack")

        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(descLabel)
        addSubview(timeLabel)

        avatarImageView.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.top.equalTo(15)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }

        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(avatarImageView.snp.bottom).offset(15)
        }

        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
        }

        descLabel.snp.makeConstraints { make in
            make.right.equalTo(-30)
            make.left.equalTo(30)
            make.top.equalTo(timeLabel.snp.bottom).offset(25)
            make.bottom.equalTo(-20)
        }
    }

    private func reloadData() {
        avatarImageView.loadAvatar(login: delegate?.loginName ?? "",
                                   avatarUrl: delegate?.avatarUrl ?? "",
                                   forceFromRemote: true) { [weak self] image in
            if let self , let image {
                self.avatarImageView.image = image
            }
        }
        nameLabel.text = delegate?.name
        timeLabel.text = delegate?.time
        descLabel.text = delegate?.desc
    }

    // MARK: View
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.circle = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor1")
        label.font = UIFont.zlMediumFont(withSize: 16)
        label.numberOfLines = 0
        return label
    }()

    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.font = UIFont.zlMediumFont(withSize: 14)
        label.numberOfLines = 4
        return label
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.font = UIFont.zlRegularFont(withSize: 11)
        return label
    }()

}


extension ZLOrgInfoHeaderCell: ZMBaseViewUpdatableWithViewData {
    // MARK: fillWithdata
    func zm_fillWithViewData(viewData: ZLOrgInfoHeaderCellDataSourceAndDelegate) {
        reloadData()
    }
}
