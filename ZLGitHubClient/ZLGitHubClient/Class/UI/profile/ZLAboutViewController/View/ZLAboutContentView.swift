//
//  ZLAboutContentView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/5.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI

protocol ZLAboutContentViewDelegate: AnyObject {
    var version: String {get}
    func onContributorsButtonClicked()
    func onRepoButtonClicked()
    func onAppStoreButtonClicked()
}

class ZLAboutContentView: ZLBaseView {

    // MARK: View
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_round")
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor1")
        label.font = UIFont.zlSemiBoldFont(withSize: 20)
        label.text = "ZLGithub"
        return label
    }()

    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.font = UIFont.zlRegularFont(withSize: 15)
        return label
    }()

    private lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    private lazy var contributorButton: UIButton = {
        let button = ZLAboutContentViewItemButton(type: .custom)
        button.itemTitle.text = ZLLocalizedString(string: "contributor", comment: "贡献者")
        return button
    }()

    private lazy var repoButton: UIButton = {
        let button = ZLAboutContentViewItemButton(type: .custom)
        button.itemTitle.text = ZLLocalizedString(string: "repository", comment: "版本库")
        return button
    }()

    private lazy var appStoreButton: UIButton = {
        let button = ZLAboutContentViewItemButton(type: .custom)
        button.itemTitle.text = "App Store"
        return button
    }()

    private weak var delegate: ZLAboutContentViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(versionLabel)
        addSubview(stackView)

        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(versionLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview()
        }

        stackView.addArrangedSubview(contributorButton)
        stackView.addArrangedSubview(repoButton)
        stackView.addArrangedSubview(appStoreButton)

        contributorButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        contributorButton.addTarget(self, action: #selector(onContributorsButtonClicked), for: .touchUpInside)

        repoButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        repoButton.addTarget(self, action: #selector(onRepoButtonClicked), for: .touchUpInside)

        appStoreButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        appStoreButton.addTarget(self, action: #selector(onAppStoreButtonClicked), for: .touchUpInside)
    }

    func fillWithData(delegate: ZLAboutContentViewDelegate) {
        self.delegate = delegate
        versionLabel.text = delegate.version
    }

    @objc private func onContributorsButtonClicked() {
        delegate?.onContributorsButtonClicked()
    }

    @objc private func onRepoButtonClicked() {
        delegate?.onRepoButtonClicked()
    }

    @objc private func onAppStoreButtonClicked() {
        delegate?.onAppStoreButtonClicked()
    }

}

extension ZLAboutContentView {
    class ZLAboutContentViewItemButton: UIButton {

        lazy var itemTitle: UILabel = {
            let label = UILabel()
            label.font = .zlRegularFont(withSize: 15)
            label.textColor = .label(withName: "ZLLabelColor1")
            return label
        }()

        lazy var nextTag: UILabel = {
            let nextTag = UILabel()
            nextTag.font = .zlIconFont(withSize: 15)
            nextTag.textColor = UIColor(named: "ICON_Common")
            nextTag.text = ZLIconFont.NextArrow.rawValue
            return nextTag
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setupUI() {

            backgroundColor = UIColor(named: "ZLCellBack")

            addSubview(itemTitle)
            addSubview(nextTag)

            itemTitle.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.centerY.equalToSuperview()
            }

            nextTag.snp.makeConstraints { make in
                make.right.equalTo(-20)
                make.centerY.equalToSuperview()
            }
        }
    }
}

