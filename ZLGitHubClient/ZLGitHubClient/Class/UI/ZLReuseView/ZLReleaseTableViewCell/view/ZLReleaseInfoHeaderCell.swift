//
//  ZLReleaseInfoHeaderCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/11.
//  Copyright © 2025 ZM. All rights reserved.
//

import UIKit
import YYText
import SnapKit
import ZLUIUtilities
import ZLBaseExtension
import ZLUtilities
import ZMMVVM

protocol ZLReleaseInfoHeaderCellDataSourceAndDelegate: AnyObject {
        
    var repoOwnerAvatarString: String { get }
    
    var repoOwnerLogin: String { get }
    
    var repoFullName: String { get }
    
    var title: String { get }
    
    var authorLogin: String { get }
    
    var authorAvatarString: String { get }
    
    var time: String { get }
    
    var commitSha: String { get }
    
    var tagName: String { get }
    
    var isLatest: Bool { get }
    
    var isDraft: Bool { get }
    
    var isPre: Bool { get }

    func onAuthorAvatarAction()
    
    func onRepoOwnerAvatarAction()
    
    func onRepoFullNameAction()
}


class ZLReleaseInfoHeaderCell: UITableViewCell {
    
    var delegate: ZLReleaseInfoHeaderCellDataSourceAndDelegate? {
        zm_viewModel as? ZLReleaseInfoHeaderCellDataSourceAndDelegate
    }
    
    func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = UIColor(named: "ZLIssueCommentCellColor")
        contentView.addSubview(repoOwnerAvatarButton)
        contentView.addSubview(fullNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorAvatarButton)
        contentView.addSubview(authorLoginReleaseLabel)
        contentView.addSubview(infoStackView)
        
        repoOwnerAvatarButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(10)
            make.size.equalTo(30)
        }
        
        fullNameLabel.snp.makeConstraints { make in
            make.left.equalTo(repoOwnerAvatarButton.snp.right).offset(10)
            make.centerY.equalTo(repoOwnerAvatarButton)
            make.right.equalTo(-20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(repoOwnerAvatarButton.snp.bottom).offset(10)
        }
        
        authorAvatarButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.size.equalTo(20)
        }
        
        authorLoginReleaseLabel.snp.makeConstraints { make in
            make.centerY.equalTo(authorAvatarButton)
            make.left.equalTo(authorAvatarButton.snp.right).offset(8)
            make.right.equalTo(-20)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(authorAvatarButton.snp.bottom).offset(15)
            make.bottom.equalTo(-10)
        }
        
        
    }
    
    // MARK: View
    lazy var repoOwnerAvatarButton: UIButton =  {
        let button = UIButton(type: .custom)
        button.cornerRadius = 15
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(repoOwnerAvatarButtonClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor1")
        label.font = UIFont(name: Font_PingFangSCSemiBold, size: 14)
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true 
        let tapGeature = UITapGestureRecognizer(target: self, action: #selector(repoFullNameClicked))
        label.addGestureRecognizer(tapGeature)
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor1")
        label.font = UIFont(name: Font_PingFangSCSemiBold, size: 20)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var authorAvatarButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onAuthorAvatarButtonClicked(_ :)), for: .touchUpInside)
        button.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    lazy var authorLoginReleaseLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.isUserInteractionEnabled = true
        label.font = .zlRegularFont(withSize: 12)
        return label
    }()
    
    
    lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.addArrangedSubview(releaseStatusLabel)
        stackView.addArrangedSubview(tagView)
        stackView.addArrangedSubview(commitView)
        return stackView
    }()

    lazy var releaseStatusLabel: UILabel = {
         let label = UILabel()
         return label
     }()
    
    lazy var tagView: UIView = {
        let view = UIView()
        view.addSubview(tagIcon)
        view.addSubview(tagNameLabel)
        tagIcon.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.size.equalTo(15)
        }
        tagNameLabel.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(tagIcon.snp.right).offset(8)
        }
        return view
     }()
    
   lazy var tagIcon: UILabel = {
        let label = UILabel()
        label.font = .zlIconFont(withSize: 15)
        label.text = ZLIconFont.Tag.rawValue
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()
    
    lazy var tagNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.font = .zlRegularFont(withSize: 13)
        return label
    }()
    
    lazy var commitView: UIView = {
        let view = UIView()
        view.addSubview(commitIcon)
        view.addSubview(commitLabel)
        commitIcon.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.size.equalTo(15)
        }
        commitLabel.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(commitIcon.snp.right).offset(8)
        }
        return view
     }()
    
   lazy var commitIcon: UILabel = {
        let label = UILabel()
        label.font = .zlIconFont(withSize: 15)
       label.text = ZLIconFont.Commit.rawValue
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()
    
    lazy var commitLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.font = .zlRegularFont(withSize: 13)
        return label
    }()
    
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
}

extension ZLReleaseInfoHeaderCell {
    @objc func repoOwnerAvatarButtonClicked(_ button: UIButton) {
        delegate?.onRepoOwnerAvatarAction()
    }
    
    @objc func repoFullNameClicked() {
        delegate?.onRepoFullNameAction()
    }
    
    @objc func onAuthorAvatarButtonClicked(_ button: UIButton) {
        delegate?.onAuthorAvatarAction()
    }
}

extension ZLReleaseInfoHeaderCell: ZMBaseViewUpdatableWithViewData {
    
    func zm_fillWithViewData(viewData: ZLReleaseInfoHeaderCellDataSourceAndDelegate) {
        
        repoOwnerAvatarButton.loadAvatar(login: viewData.repoOwnerLogin,
                                         avatarUrl: viewData.repoOwnerAvatarString)
        fullNameLabel.text = viewData.repoFullName
        
        titleLabel.text = viewData.title
        
        authorAvatarButton.loadAvatar(login: viewData.authorLogin,
                                      avatarUrl: viewData.authorAvatarString,
                                      size: 10)
        authorLoginReleaseLabel.text = "\(viewData.authorLogin) \(ZLLocalizedString(string: "released", comment: "发布于")) \(viewData.time)"

        
        
        tagNameLabel.text = viewData.tagName
        
        
        var statusTagStr = ""
        var statusTagColor: UIColor = .clear
    
        if viewData.isLatest {
            statusTagStr = ZLLocalizedString(string: "Latest Release", comment: "最新发行版")
            statusTagColor = .label(withName: "Release-Latest")
        } else if viewData.isPre {
            statusTagStr = ZLLocalizedString(string: "Pre Release", comment: "预发版")
            statusTagColor = .label(withName: "Release-Pre")
        } else if viewData.isDraft {
            statusTagStr = ZLLocalizedString(string: "Draft Release", comment: "草稿")
            statusTagColor = .label(withName: "Release-Draft")
        }
        
        if !statusTagStr.isEmpty {
            let tag = NSTagWrapper()
                .attributedString(statusTagStr
                                    .asMutableAttributedString()
                                    .font(.zlRegularFont(withSize: 10))
                                    .foregroundColor(statusTagColor))
                .cornerRadius(4.0)
                .borderColor(statusTagColor)
                .borderWidth(1.0 / UIScreen.main.scale)
                .edgeInsets(UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
                .asImage()?
                .asImageTextAttachmentWrapper()
                .font(.zlMediumFont(withSize: 16))
                .alignment(.centerline)
                .asAttributedString() ?? " ".asAttributedString()
            releaseStatusLabel.attributedText = tag
            releaseStatusLabel.isHidden = false
        } else {
            releaseStatusLabel.isHidden = true
        }
        
        tagNameLabel.text = viewData.tagName
        
        commitLabel.text = viewData.commitSha
      
    }
}

