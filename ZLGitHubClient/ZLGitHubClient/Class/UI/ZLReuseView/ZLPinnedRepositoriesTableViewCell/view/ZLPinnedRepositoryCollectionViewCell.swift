//
//  ZLPinnedRepositoryCollectionViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/5.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLUtilities

protocol ZLPinnedRepositoryCollectionViewCellDataSourceAndDelegate: ZLGithubItemCollectionViewCellDataProtocol {
    var avatarUrl: String {get}
    var repoName: String {get}
    var ownerName: String {get}
    var language: String {get}
    var desc: String {get}
    var forkNum: Int {get}
    var starNum: Int {get}
    var isPrivate: Bool {get}
}

class ZLPinnedRepositoryCollectionViewCell: UICollectionViewCell {

    private weak var delegate: ZLPinnedRepositoryCollectionViewCellDataSourceAndDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        backgroundColor = .clear
        contentView.backgroundColor = UIColor(named: "ZLCellBack")
        contentView.layer.cornerRadius = 5.0
        contentView.layer.masksToBounds = true

        contentView.addSubview(avatarButton)
        contentView.addSubview(repostitoryNameLabel)
        contentView.addSubview(ownerNameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(languageIcon)
        contentView.addSubview(languageLabel)

        avatarButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }

        repostitoryNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarButton)
            make.left.equalTo(avatarButton.snp.right).offset(15)
            make.right.equalToSuperview().offset(-20)
        }

        ownerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(repostitoryNameLabel.snp.bottom).offset(10)
            make.left.equalTo(repostitoryNameLabel)
        }

        languageIcon.snp.makeConstraints { make in
            make.centerY.equalTo(languageLabel)
            make.size.equalTo(10)
            make.left.equalTo(ownerNameLabel.snp.right).offset(20)
        }
        
        languageLabel.snp.makeConstraints { make in
            make.top.equalTo(repostitoryNameLabel.snp.bottom).offset(10)
            make.left.equalTo(languageIcon.snp.right).offset(5)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(avatarButton.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.clear
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.left.equalTo(repostitoryNameLabel)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }

        bottomView.addSubview(privateLabel)
        bottomView.addSubview(starLabel)
        bottomView.addSubview(starNumLabel)
        bottomView.addSubview(forkLabel)
        bottomView.addSubview(forkNumLabel)

        forkNumLabel.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(40)
        }

        forkLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
            make.right.equalTo(forkNumLabel.snp.left).offset(-3)
        }

        starNumLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(40)
            make.right.equalTo(forkLabel.snp.left).offset(-20)
        }

        starLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
            make.right.equalTo(starNumLabel.snp.left).offset(-3)
        }

        privateLabel.snp.makeConstraints { make in
            make.right.equalTo(starLabel.snp.left).offset(-20)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
        }
    }

    // MARK: fillWithData
    func fillWithData(viewData: ZLPinnedRepositoryCollectionViewCellDataSourceAndDelegate) {
        self.delegate = viewData

        avatarButton.loadAvatar(login: viewData.ownerName, avatarUrl: viewData.avatarUrl)
        repostitoryNameLabel.text = viewData.repoName
        languageLabel.text = viewData.language
        languageIcon.backgroundColor = ZLDevelopmentLanguageColor.colorForLanguage(viewData.language)
        languageIcon.isHidden = viewData.language.isEmpty
        ownerNameLabel.text = viewData.ownerName
        descriptionLabel.text = viewData.desc
        forkNumLabel.text = viewData.forkNum < 1000 ? "\(viewData.forkNum)" : String(format: "%.1f", Double(viewData.forkNum)/1000.0) + "k"
        starNumLabel.text = viewData.starNum < 1000 ? "\(viewData.starNum)" : String(format: "%.1f", Double(viewData.starNum)/1000.0) + "k"
        privateLabel.isHidden = !viewData.isPrivate
    }

    // MARK: View 
    lazy var avatarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()

    lazy  var repostitoryNameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.zlSemiBoldFont(withSize: 17)
        label.textColor = UIColor(named: "ZLLabelColor1")
        return label
    }()
    
    lazy  var languageIcon: UIView = {
        let view = UIView()
        view.cornerRadius = 5.0
        return view
    }()

    lazy  var languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlMediumFont(withSize: 14)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var ownerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlMediumFont(withSize: 14)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.font = UIFont.zlRegularFont(withSize: 12)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var starLabel: UILabel = {
        let label = UILabel()
        label.text = ZLIconFont.RepoStar.rawValue
        label.font = UIFont.zlIconFont(withSize: 15)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var forkLabel: UILabel = {
        let label = UILabel()
        label.text = ZLIconFont.RepoFork.rawValue
        label.font = UIFont.zlIconFont(withSize: 15)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var privateLabel: UILabel = {
        let label = UILabel()
        label.text = ZLIconFont.RepoPrivate.rawValue
        label.font = UIFont.zlIconFont(withSize: 15)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var starNumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.zlMediumFont(withSize: 12)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var forkNumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.zlMediumFont(withSize: 12)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()
}
