//
//  ZLUserInfoHeaderView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/5.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities

protocol ZLUserInfoHeaderCellDataSourceAndDelegate: AnyObject {

    var name: String {get}
    var loginName: String {get}
    var time: String {get}
    var desc: String {get}
    var avatarUrl: String {get}

    var reposNum: String {get}
    var gistsNum: String {get}
    var followersNum: String {get}
    var followingNum: String {get}
    
    var blockStatus: Bool? {get}
    var followStatus: Bool? {get}

    func onFollowButtonClicked()
    func onBlockButtonClicked()

    func onReposNumButtonClicked()
    func onGistsNumButtonClicked()
    func onFollowsNumButtonClicked()
    func onFollowingNumButtonClicked()
}

class ZLUserInfoHeaderCell: UITableViewCell {

    private weak var delegate: ZLUserInfoHeaderCellDataSourceAndDelegate?

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

        addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(reposNumButton)
        buttonStackView.addArrangedSubview(gistsNumButton)
        buttonStackView.addArrangedSubview(followersNumButton)
        buttonStackView.addArrangedSubview(followingsNumButton)

        addSubview(buttonStackView1)
        buttonStackView1.addArrangedSubview(followButton)
        buttonStackView1.addArrangedSubview(blockButton)

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
        }

        buttonStackView.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(descLabel.snp.bottom).offset(30)
            make.bottom.equalTo(-10)
            make.height.equalTo(50)
        }

        buttonStackView1.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.centerY.equalTo(avatarImageView)
        }

        followButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60, height: 25))
        }
        blockButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60, height: 25))
        }
    }

    private func reloadData() {
        avatarImageView.loadAvatar(login: delegate?.loginName ?? "",
                                   avatarUrl: delegate?.avatarUrl ?? "")
        nameLabel.text = delegate?.name
        timeLabel.text = delegate?.time
        descLabel.text = delegate?.desc
        reposNumButton.numLabel.text = delegate?.reposNum
        gistsNumButton.numLabel.text  = delegate?.gistsNum
        followersNumButton.numLabel.text = delegate?.followersNum
        followingsNumButton.numLabel.text = delegate?.followingNum

        if let followStatus = delegate?.followStatus {
            followButton.isHidden = false
            followButton.isSelected = followStatus
        } else {
            followButton.isHidden = true
        }
        
        if let blockStatus = delegate?.blockStatus {
            blockButton.isHidden = false
            blockButton.isSelected = blockStatus
        } else {
            blockButton.isHidden = true
        }
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
        label.numberOfLines = 3
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

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 35
        return stackView
    }()

    private lazy var buttonStackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()

    private lazy var reposNumButton: ZLUserInfoHeaderButton = {
        let button = ZLUserInfoHeaderButton(type: .custom)
        button.numLabel.text  = "0"
        button.nameLabel.text = ZLLocalizedString(string: "repositories", comment: "")
        button.addTarget(self, action: #selector(onReposNumButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var gistsNumButton: ZLUserInfoHeaderButton = {
        let button = ZLUserInfoHeaderButton(type: .custom)
        button.numLabel.text  = "0"
        button.nameLabel.text = ZLLocalizedString(string: "gists", comment: "")
        button.addTarget(self, action: #selector(onGistsNumButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var followersNumButton: ZLUserInfoHeaderButton = {
        let button = ZLUserInfoHeaderButton(type: .custom)
        button.numLabel.text  = "0"
        button.nameLabel.text = ZLLocalizedString(string: "followers", comment: "")
        button.addTarget(self, action: #selector(onFollowsNumButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var followingsNumButton: ZLUserInfoHeaderButton = {
        let button = ZLUserInfoHeaderButton(type: .custom)
        button.numLabel.text  = "0"
        button.nameLabel.text = ZLLocalizedString(string: "following", comment: "")
        button.addTarget(self, action: #selector(onFollowingNumButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var followButton: ZLBaseButton = {
        let button = ZLBaseButton()
        button.setTitle(ZLLocalizedString(string: "Follow", comment: ""), for: .normal)
        button.setTitle(ZLLocalizedString(string: "Unfollow", comment: ""), for: .selected)
        button.titleLabel?.font = UIFont.zlSemiBoldFont(withSize: 10)
        button.addTarget(self, action: #selector(onFollowButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var blockButton: ZLBaseButton = {
        let button = ZLBaseButton()
        button.setTitle(ZLLocalizedString(string: "Block", comment: ""), for: .normal)
        button.setTitle(ZLLocalizedString(string: "Unblock", comment: ""), for: .selected)
        button.titleLabel?.font = UIFont.zlSemiBoldFont(withSize: 10)
        button.addTarget(self, action: #selector(onBlockButtonClicked), for: .touchUpInside)
        return button
    }()

}


extension ZLUserInfoHeaderCell: ZLViewUpdatableWithViewData {
    // MARK: fillWithdata
    func fillWithViewData(viewData: ZLUserInfoHeaderCellDataSourceAndDelegate){
        delegate = viewData
        reloadData()
    }
    
    func justUpdateView() {
        
    }
}


extension ZLUserInfoHeaderCell {

    @objc func onFollowButtonClicked() {
        self.delegate?.onFollowButtonClicked()
    }
    @objc func onBlockButtonClicked() {
        self.delegate?.onBlockButtonClicked()
    }
    @objc func onReposNumButtonClicked() {
        self.delegate?.onReposNumButtonClicked()
    }
    @objc func onGistsNumButtonClicked() {
        self.delegate?.onGistsNumButtonClicked()
    }
    @objc func onFollowsNumButtonClicked() {
        self.delegate?.onFollowsNumButtonClicked()
    }
    @objc func onFollowingNumButtonClicked() {
        self.delegate?.onFollowingNumButtonClicked()
    }
}

private class ZLUserInfoHeaderButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(numLabel)
        addSubview(nameLabel)

        numLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1.5)
            make.centerX.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-1.5)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: View
    lazy var numLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor3")
        label.font = UIFont.zlMediumFont(withSize: 17)
        label.textAlignment = .center
        return label
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor3")
        label.font = UIFont.zlMediumFont(withSize: 12)
        label.textAlignment = .center
        return label
    }()
}
