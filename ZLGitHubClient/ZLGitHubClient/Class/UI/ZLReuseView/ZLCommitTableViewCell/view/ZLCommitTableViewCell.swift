//
//  ZLCommitTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZMMVVM

@objc protocol ZLCommitTableViewCellDelegate: NSObjectProtocol {
}

class ZLCommitTableViewCell: UITableViewCell {

    var delegate: ZLCommitTableViewCellDelegate? {
        zm_viewModel as? ZLCommitTableViewCellDelegate
    }

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLCellBack")
        view.cornerRadius = 8.0
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zlMediumFont(withSize: 16)
        label.textColor = UIColor(named: "ZLLabelColor1")
        label.numberOfLines = 3
        return label
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var assitLabel: UILabel = {
        let label = UILabel()
        label.font = .zlRegularFont(withSize: 11)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    private lazy var shaButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor(named: "ZLLinkLabelColor1"), for: .normal)
        button.titleLabel?.font = .zlRegularFont(withSize: 12)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }

        containerView.addSubview(titleLabel)
        containerView.addSubview(shaButton)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(assitLabel)

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(15)
        }

        shaButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 25))
            make.right.equalTo(-10)
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(10)
        }

        avatarImageView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalTo(-10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }

        assitLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(10)
            make.centerY.equalTo(avatarImageView)
            make.right.equalTo(-20)
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBackSelected")
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }

}

extension ZLCommitTableViewCell: ZMBaseViewUpdatableWithViewData {
    
    func zm_fillWithViewData(viewData: ZLCommitTableViewCellData) {
        self.titleLabel.text = viewData.getCommitTitle()
        self.avatarImageView.loadAvatar(login: viewData.getCommiterLogin(),
                                        avatarUrl: viewData.getCommiterAvaterURL() ?? "")
        self.assitLabel.text = viewData.getAssistInfo()
        self.shaButton.setTitle(viewData.getCommitSha(), for: .normal)
    }
}
