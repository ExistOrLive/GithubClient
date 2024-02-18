//
//  ZLProfileHeaderCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/9/22.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import ZLUIUtilities

protocol ZLProfileHeaderCellDataSourceAndDelegate: AnyObject {

    var avatarUrl: String {get}
    var name: String {get}
    var loginName: String {get}
    var createTime: String {get}
    
    var reposNum: String {get}
    var gistsNum: String {get}
    var followersNum: String {get}
    var followingNum: String {get}
    
    func onReposNumButtonClicked()
    func onGistsNumButtonClicked()
    func onFollowsNumButtonClicked()
    func onFollowingNumButtonClicked()
    func onAvatarButtonClicked()
    func onEditProfileButtonClicked()
}


class ZLProfileHeaderCell: UITableViewCell {
    
    private weak var delegate: ZLProfileHeaderCellDataSourceAndDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = .black
        contentView.addSubview(avatarButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(createTimeLabel)
        contentView.addSubview(editButton)
        contentView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(reposNumButton)
        buttonStackView.addArrangedSubview(gistsNumButton)
        buttonStackView.addArrangedSubview(followersNumButton)
        buttonStackView.addArrangedSubview(followingsNumButton)
    }
    
    func setupLayout() {
        
        avatarButton.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(30)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }

        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarButton.snp.right).offset(20)
            make.top.equalTo(avatarButton.snp.top).offset(10)
            make.right.equalTo(-50)
        }

        createTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarButton.snp.right).offset(20)
            make.bottom.equalTo(avatarButton.snp.bottom).offset(-10)
            make.right.equalTo(-50)
        }

        editButton.snp.makeConstraints { make in
            make.top.equalTo(avatarButton)
            make.right.equalTo(-10)
            make.size.equalTo(30)
        }

        buttonStackView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(avatarButton.snp.bottom).offset(20)
            make.bottom.equalTo(-10)
            make.height.equalTo(50)
        }
    }
    
    
    //MARK: Lazy View
    private lazy var avatarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 30.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(onAvatarButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .zlMediumFont(withSize: 15)
        return label
    }()
    
    private lazy var createTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .zlRegularFont(withSize: 12)
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.iconFontImage(withText: ZLIconFont.Edit.rawValue,
                                              fontSize: 25,
                                              color: .white),
                        for: .normal)
        button.addTarget(self, action: #selector(onEditProfileButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 35
        return stackView
    }()
    
    private lazy var reposNumButton: ZLProfileInfoHeaderButton = {
        let button = ZLProfileInfoHeaderButton(type: .custom)
        button.numLabel.text  = "0"
        button.nameLabel.text = ZLLocalizedString(string: "repositories", comment: "")
        button.addTarget(self, action: #selector(onReposNumButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var gistsNumButton: ZLProfileInfoHeaderButton = {
        let button = ZLProfileInfoHeaderButton(type: .custom)
        button.numLabel.text  = "0"
        button.nameLabel.text = ZLLocalizedString(string: "gists", comment: "")
        button.addTarget(self, action: #selector(onGistsNumButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var followersNumButton: ZLProfileInfoHeaderButton = {
        let button = ZLProfileInfoHeaderButton(type: .custom)
        button.numLabel.text  = "0"
        button.nameLabel.text = ZLLocalizedString(string: "followers", comment: "")
        button.addTarget(self, action: #selector(onFollowsNumButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var followingsNumButton: ZLProfileInfoHeaderButton = {
        let button = ZLProfileInfoHeaderButton(type: .custom)
        button.numLabel.text  = "0"
        button.nameLabel.text = ZLLocalizedString(string: "following", comment: "")
        button.addTarget(self, action: #selector(onFollowingNumButtonClicked), for: .touchUpInside)
        return button
    }()
}

// MARK: - Action
extension ZLProfileHeaderCell {
    
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
    @objc func onEditProfileButtonClicked() {
        self.delegate?.onEditProfileButtonClicked()
    }
    @objc func onAvatarButtonClicked() {
        self.delegate?.onAvatarButtonClicked()
    }
}


// MARK: - ZLViewUpdatableWithViewData
extension ZLProfileHeaderCell: ZLViewUpdatableWithViewData {

    func fillWithViewData(viewData: ZLProfileHeaderCellDataSourceAndDelegate) {
        delegate = viewData
        avatarButton.loadAvatar(login: viewData.loginName, avatarUrl: viewData.avatarUrl)
        nameLabel.text = viewData.name
        createTimeLabel.text = viewData.createTime
        reposNumButton.numLabel.text = viewData.reposNum
        gistsNumButton.numLabel.text  = viewData.gistsNum
        followersNumButton.numLabel.text = viewData.followersNum
        followingsNumButton.numLabel.text = viewData.followingNum
       
        justUpdateView() 
    }
    
    func justUpdateView() {
        reposNumButton.nameLabel.text = ZLLocalizedString(string: "repositories", comment: "仓库")
        gistsNumButton.nameLabel.text = ZLLocalizedString(string: "gists", comment: "代码片段")
        followersNumButton.nameLabel.text = ZLLocalizedString(string: "followers", comment: "粉丝")
        followingsNumButton.nameLabel.text = ZLLocalizedString(string: "following", comment: "关注")
    }
}


private class ZLProfileInfoHeaderButton: UIButton {

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
        label.textColor = .white
        label.font = UIFont.zlMediumFont(withSize: 17)
        label.textAlignment = .center
        return label
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.zlMediumFont(withSize: 12)
        label.textAlignment = .center
        return label
    }()
}
