//
//  ZLPinnedRepositoryCollectionViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/5.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLUtilities

protocol ZLPinnedRepositoryCollectionViewCellDataSourceAndDelegate: NSObjectProtocol {
    var avatarUrl: String {get}
    var repoName: String {get}
    var ownerName: String {get}
    var language: String {get}
    var desc: String {get}
    var forkNum: Int {get}
    var starNum: Int {get}
    var isPrivate: Bool {get}
    
    func getCellReuseIdentifier() -> String

    func onCellSingleTap()
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
        contentView.addSubview(bottomStackView)
        
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

        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(avatarButton.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalTo(20)
            make.height.equalTo(20)
        }
        
        bottomStackView.addArrangedSubview(languageIcon)
        bottomStackView.addArrangedSubview(languageLabel)
        bottomStackView.addArrangedSubview(starLabel)
        bottomStackView.addArrangedSubview(starNumLabel)
        bottomStackView.addArrangedSubview(forkLabel)
        bottomStackView.addArrangedSubview(forkNumLabel)
        bottomStackView.addArrangedSubview(privateLabel)
        
        languageIcon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 10, height: 10))
        }
        
        forkLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        starLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15, height: 15))
        }

        privateLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        bottomStackView.setCustomSpacing(5, after: languageIcon)
        bottomStackView.setCustomSpacing(12, after: languageLabel)
        bottomStackView.setCustomSpacing(5, after: starLabel)
        bottomStackView.setCustomSpacing(12, after: starNumLabel)
        bottomStackView.setCustomSpacing(5, after: forkLabel)
        bottomStackView.setCustomSpacing(12, after: forkNumLabel)
    }

    // MARK: fillWithData
    func fillWithData(viewData: ZLPinnedRepositoryCollectionViewCellDataSourceAndDelegate) {
        self.delegate = viewData

        avatarButton.loadAvatar(login: viewData.ownerName, avatarUrl: viewData.avatarUrl)
        repostitoryNameLabel.text = viewData.repoName
        ownerNameLabel.text = viewData.ownerName
        descriptionLabel.text = viewData.desc
        forkNumLabel.text = viewData.forkNum < 1000 ? "\(viewData.forkNum)" : String(format: "%.1f", Double(viewData.forkNum)/1000.0) + "k"
        starNumLabel.text = viewData.starNum < 1000 ? "\(viewData.starNum)" : String(format: "%.1f", Double(viewData.starNum)/1000.0) + "k"
        privateLabel.isHidden = !viewData.isPrivate
        
        languageLabel.isHidden = viewData.language.isEmpty
        languageLabel.text = viewData.language
        languageIcon.backgroundColor = ZLDevelopmentLanguageColor.colorForLanguage(viewData.language)
        languageIcon.isHidden = viewData.language.isEmpty
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
    
    lazy  var languageIcon: UIView = {
        let view = UIView()
        view.cornerRadius = 5.0
        return view
    }()

    lazy  var languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlMediumFont(withSize: 12)
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
    
    lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
}
