
//
//  ZLReleaseTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/10.
//  Copyright © 2025 ZM. All rights reserved.
//

import UIKit
import YYText
import SnapKit
import ZLUIUtilities
import ZLBaseExtension
import ZLUtilities
import ZMMVVM

protocol ZLReleaseTableViewCellDataSourceAndDelegate: AnyObject {
        
    var title: String { get }
    
    var time: String { get }
    
    var authorLogin: String { get }
    
    var authorAvatarString: String { get }
    
    var tagName: String { get }
    
    var isLatest: Bool { get }
    
    var isDraft: Bool { get }
    
    var isPre: Bool { get }
    
    func hasLongPressAction() -> Bool

    func longPressAction(view: UIView)
    
    func onAuthorAvatarAction()
}


class ZLReleaseTableViewCell: ZLBaseCardTableViewCell {
    
    var delegate: ZLReleaseTableViewCellDataSourceAndDelegate? {
        zm_viewModel as? ZLReleaseTableViewCellDataSourceAndDelegate
    }
    
    override func setupUI() {
        super.setupUI()
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(authorAvatarButton)
        containerView.addSubview(authorLoginLabel)
        containerView.addSubview(tagIcon)
        containerView.addSubview(tagNameLabel)
        containerView.addSubview(timeLabel)
        containerView.addGestureRecognizer(longPressGesture)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.right.equalTo(-40)
        }
        
        authorAvatarButton.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.size.equalTo(20)
            make.bottom.equalTo(-10)
        }
        
        authorLoginLabel.snp.makeConstraints { make in
            make.left.equalTo(authorAvatarButton.snp.right).offset(8)
            make.centerY.equalTo(authorAvatarButton)
        }
        
        tagIcon.snp.makeConstraints { make in
            make.left.equalTo(authorLoginLabel.snp.right).offset(15)
            make.centerY.equalTo(authorAvatarButton)
        }
        
        tagNameLabel.snp.makeConstraints { make in
            make.left.equalTo(tagIcon.snp.right).offset(8)
            make.centerY.equalTo(authorAvatarButton)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(authorAvatarButton)
            make.right.equalTo(-15)
        }
    }
    
    // MARK: View

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.textColor = UIColor(named: "ZLLabelColor1")
        label.font = .zlMediumFont(withSize: 16)
        return label
    }()
    
    
    private lazy var authorAvatarButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onAuthorAvatarButtonClicked(_ :)), for: .touchUpInside)
        button.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var authorLoginLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.isUserInteractionEnabled = true
        label.font = .zlRegularFont(withSize: 13)
        let tapGeature = UITapGestureRecognizer(target: self, action: #selector(onAuthorLabelClicked))
        label.addGestureRecognizer(tapGeature)
        
        return label
    }()
    
    private lazy var tagIcon: UILabel = {
        let label = UILabel()
        label.font = .zlIconFont(withSize: 15)
        label.text = ZLIconFont.Tag.rawValue
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()
    
    private lazy var tagNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.font = .zlRegularFont(withSize: 13)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.font = .zlRegularFont(withSize: 13)
        return label
    }()

    
    lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(gesture:)))
        return gesture
    }()
    
}

extension ZLReleaseTableViewCell: ZMBaseViewUpdatableWithViewData {
    
    func zm_fillWithViewData(viewData: ZLReleaseTableViewCellDataSourceAndDelegate) {
        
        let titleAttributedString = viewData.title
            .asMutableAttributedString()
            .font(.zlMediumFont(withSize: 16))
            .foregroundColor(.label(withName: "ZLLabelColor1"))
        
        var tagStr = ""
        var tagColor: UIColor = .clear
    
        if viewData.isLatest {
            tagStr = ZLLocalizedString(string: "Latest Release", comment: "最新发行版")
            tagColor = .label(withName: "Release-Latest")
        } else if viewData.isPre {
            tagStr = ZLLocalizedString(string: "Pre Release", comment: "预发版")
            tagColor = .label(withName: "Release-Pre")
        } else if viewData.isDraft {
            tagStr = ZLLocalizedString(string: "Draft Release", comment: "草稿")
            tagColor = .label(withName: "Release-Draft")
        }
        
        if !tagStr.isEmpty {
            let tag = NSTagWrapper()
                .attributedString(tagStr
                                    .asMutableAttributedString()
                                    .font(.zlRegularFont(withSize: 10))
                                    .foregroundColor(tagColor))
                .cornerRadius(4.0)
                .borderColor(tagColor)
                .borderWidth(1.0 / UIScreen.main.scale)
                .edgeInsets(UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
                .asImage()?
                .asImageTextAttachmentWrapper()
                .font(.zlMediumFont(withSize: 16))
                .alignment(.centerline)
                .asAttributedString() ?? " ".asAttributedString()
            titleAttributedString.append(" ".asAttributedString())
            titleAttributedString.append(tag)
        }
        
        titleLabel.attributedText = titleAttributedString
        
        authorAvatarButton.loadAvatar(login: viewData.authorLogin,
                                      avatarUrl: viewData.authorAvatarString,
                                      size: 10)
        authorLoginLabel.text = viewData.authorLogin
        tagNameLabel.text = viewData.tagName
        timeLabel.text = viewData.time
    
        longPressGesture.isEnabled = viewData.hasLongPressAction()
    }
}

extension ZLReleaseTableViewCell {

    @objc func longPressAction(gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        delegate?.longPressAction(view: self)
    }
    
    @objc func onAuthorAvatarButtonClicked(_ button: UIButton) {
        delegate?.onAuthorAvatarAction()
    }
    
    @objc func onAuthorLabelClicked() {
        delegate?.onAuthorAvatarAction()
    }
}
