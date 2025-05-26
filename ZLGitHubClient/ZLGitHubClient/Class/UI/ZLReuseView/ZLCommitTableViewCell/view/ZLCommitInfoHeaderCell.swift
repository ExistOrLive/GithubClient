//
//  ZLCommitInfoHeaderCell.swift
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

protocol ZLCommitInfoHeaderCellSourceAndDelegate: NSObjectProtocol {
    
    var title: String { get }
    var authorLogin: String { get }
    var authorAvator: String { get }
    var commitTime: String { get }
    var modifyStr: NSAttributedString { get }
    
    func onAuthorAvatarAction()
}


class ZLCommitInfoHeaderCell: UITableViewCell {
    
    var delegate: ZLCommitInfoHeaderCellSourceAndDelegate? {
        zm_viewModel as? ZLCommitInfoHeaderCellSourceAndDelegate
    }
    
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = UIColor(named: "ZLIssueCommentCellColor")
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorAvatarButton)
        contentView.addSubview(authorLoginCommitLabel)
        contentView.addSubview(modifyInfoLabel)
       
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(10)
        }
        
        authorAvatarButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.size.equalTo(20)
        }
        
        authorLoginCommitLabel.snp.makeConstraints { make in
            make.centerY.equalTo(authorAvatarButton)
            make.left.equalTo(authorAvatarButton.snp.right).offset(8)
            make.right.equalTo(-20)
        }
        
        modifyInfoLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(authorAvatarButton.snp.bottom).offset(15)
            make.bottom.equalTo(-10)
        }
        
        
    }
    
    // MARK: View
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
    
    lazy var authorLoginCommitLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.isUserInteractionEnabled = true
        label.font = .zlRegularFont(withSize: 12)
        return label
    }()
    
    
    lazy var modifyInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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


extension ZLCommitInfoHeaderCell {

    @objc func onAuthorAvatarButtonClicked(_ button: UIButton) {
        delegate?.onAuthorAvatarAction()
    }
}

extension ZLCommitInfoHeaderCell: ZMBaseViewUpdatableWithViewData {
    
    func zm_fillWithViewData(viewData: ZLCommitInfoHeaderCellSourceAndDelegate) {
        
        titleLabel.text = viewData.title
        
        authorAvatarButton.loadAvatar(login: viewData.authorLogin,
                                      avatarUrl: viewData.authorAvator,
                                      size: 10)
        authorLoginCommitLabel.text = "\(viewData.authorLogin) \(ZLLocalizedString(string: "committed", comment: "提交于")) \(viewData.commitTime)"
      
        modifyInfoLabel.attributedText = viewData.modifyStr
    }
}

