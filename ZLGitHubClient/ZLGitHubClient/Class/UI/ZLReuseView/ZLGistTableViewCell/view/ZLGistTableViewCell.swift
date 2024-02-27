//
//  ZLGistTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/2/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import SnapKit
import Foundation
import ZLUIUtilities
import MJRefresh
import ZLUtilities

protocol ZLGistTableViewCellDelegate: AnyObject {
    func onAvatarButtonClicked()

    func getOwnerAvatar() -> String

    func getOwnerName() -> String

    func getFirstFileName() -> String?

    func getFileCount() -> Int

    func getCommentsCount() -> UInt

    func getDesc() -> String

    func isPub() -> Bool

    func getCreate_At() -> Date?

    func getUpdate_At() -> Date?
}

class ZLGistTableViewCell: ZLBaseCardTableViewCell {

    weak var delegate: ZLGistTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        containerView.addSubview(avatarButton)
        containerView.addSubview(gistNameLabel)
        containerView.addSubview(fileLabel)
        containerView.addSubview(commentLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(descLabel)
        containerView.addSubview(privateLabel)
        
        avatarButton.snp.makeConstraints { make in
            make.top.left.equalTo(10)
            make.size.equalTo(50)
        }
        
        gistNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatarButton)
            make.left.equalTo(avatarButton.snp.right).offset(10)
            make.right.lessThanOrEqualToSuperview().offset(-35)
        }
        
        privateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(gistNameLabel)
            make.left.equalTo(gistNameLabel.snp.right).offset(10)
        }
        
        fileLabel.snp.makeConstraints { make in
            make.left.equalTo(gistNameLabel)
            make.top.equalTo(avatarButton.snp.bottom).offset(5)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(fileLabel)
            make.left.equalTo(fileLabel.snp.right).offset(25)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(fileLabel)
            make.top.equalTo(fileLabel.snp.bottom).offset(10)
        }
        
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(fileLabel)
            make.right.equalTo(-20)
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-15)
        }
    
    }

    // MARK: Lazy View
    lazy var avatarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.cornerRadius = 25
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(onAvatarButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var gistNameLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor(named:"ZLLinkLabelColor2")
        label.font = .zlMediumFont(withSize: 17)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var fileLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor(named:"ZLLabelColor2")
        label.font = .zlRegularFont(withSize: 12)
        return label
    }()
    
    lazy var commentLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor(named:"ZLLabelColor2")
        label.font = .zlRegularFont(withSize: 12)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor(named:"ZLLabelColor2")
        label.font = .zlRegularFont(withSize: 12)
        return label
    }()
    
    lazy var descLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor(named:"ZLLabelColor2")
        label.font = .zlRegularFont(withSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var privateLabel: UILabel = {
       let label = UILabel()
        label.text = ZLIconFont.RepoPrivate.rawValue
        label.textColor = UIColor(named:"ZLLabelColor2")
        label.font = .zlIconFont(withSize: 15)
        return label
    }()
}

// MARK: Action
extension ZLGistTableViewCell {
    @objc func onAvatarButtonClicked() {
        delegate?.onAvatarButtonClicked()
    }
}

// MARK: - ZLViewUpdatableWithViewData
extension ZLGistTableViewCell: ZLViewUpdatableWithViewData {
    
    func justUpdateView() {
    }
    func fillWithViewData(viewData: ZLGistTableViewCellDelegate) {
        self.delegate = viewData
        self.avatarButton.loadAvatar(login: viewData.getOwnerName(),
                                     avatarUrl: viewData.getOwnerAvatar())

        let firstFileName = viewData.getFirstFileName()
        self.gistNameLabel.text = NSString.init(format: "%@/%@", viewData.getOwnerName(), firstFileName ?? "") as String
        self.fileLabel.text = "\(String(describing: viewData.getFileCount()))\(ZLLocalizedString(string: "gistFiles", comment: "条代码片段"))"
        self.commentLabel.text = "\(String(describing: viewData.getCommentsCount()))\(ZLLocalizedString(string: "comments", comment: "条评论"))"

        self.privateLabel.isHidden = viewData.isPub()
    
        if let update_at = viewData.getUpdate_At() {
            self.timeLabel.text = "\(ZLLocalizedString(string: "update at", comment: "更新于"))\((update_at as NSDate).dateLocalStrSinceCurrentTime())"
        } else if let create_at = viewData.getCreate_At() {
              self.timeLabel.text = "\(ZLLocalizedString(string: "created at", comment: "创建于"))\((create_at as NSDate).dateLocalStrSinceCurrentTime())"
        } else {
            self.timeLabel.text = nil
        }

        self.descLabel.text = viewData.getDesc()
    }
}
