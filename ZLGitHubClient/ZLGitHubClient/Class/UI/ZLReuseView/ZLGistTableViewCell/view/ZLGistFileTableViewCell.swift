//
//  ZLGistFileVoew.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/6/15.
//  Copyright © 2025 ZM. All rights reserved.
//


import UIKit
import SnapKit
import Foundation
import ZLUIUtilities
import MJRefresh
import ZLUtilities
import ZMMVVM

protocol ZLGistFileTableViewCellDelegate: AnyObject {

    var fileName: String { get }
    
    var fileLanguage: String { get }
}

class ZLGistFileTableViewCell: ZLBaseCardTableViewCell {

    var delegate: ZLGistFileTableViewCellDelegate? {
        zm_viewModel as? ZLGistFileTableViewCellDelegate
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        containerView.addSubview(fileNameLabel)
        containerView.addSubview(languageIcon)
        containerView.addSubview(languageLabel)
    
        fileNameLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.right.equalTo(-10)
        }
    
        languageIcon.snp.makeConstraints { make in
            make.top.equalTo(fileNameLabel.snp.bottom).offset(10)
            make.size.equalTo(12)
            make.left.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        languageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(languageIcon)
            make.left.equalTo(languageIcon.snp.right).offset(10)
        }
    }

    // MARK: Lazy View
    lazy var fileNameLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor(named:"ZLLinkLabelColor2")
        label.font = .zlMediumFont(withSize: 17)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var languageIcon: UIView = {
        let view = UIView()
        view.cornerRadius = 6
        return view
    }()
    
    lazy  var languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlMediumFont(withSize: 14)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()
}


// MARK: - ZMBaseViewUpdatableWithViewData
extension ZLGistFileTableViewCell: ZMBaseViewUpdatableWithViewData {
    
    func zm_fillWithViewData(viewData: ZLGistFileTableViewCellDelegate) {
        fileNameLabel.text = viewData.fileName
        languageLabel.text = viewData.fileLanguage
        languageIcon.backgroundColor = ZLDevelopmentLanguageColor.colorForLanguage(viewData.fileLanguage)
    }
}
