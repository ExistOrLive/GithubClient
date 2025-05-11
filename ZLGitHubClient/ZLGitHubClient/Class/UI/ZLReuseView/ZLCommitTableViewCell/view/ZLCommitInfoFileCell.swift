//
//  ZLCommitInfoFileCell.swift
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

protocol ZLCommitInfoFileCellSourceAndDelegate: NSObjectProtocol {
    
    var fileName: String { get }
    var filePatchContent: NSAttributedString { get }
}


class ZLCommitInfoFileCell: UITableViewCell {
    
    var delegate: ZLCommitInfoFileCellSourceAndDelegate? {
        zm_viewModel as? ZLCommitInfoFileCellSourceAndDelegate
    }
    
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubview(fileNameLabel)
        backView.addSubview(fileContentLabel)
       
        backView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        fileNameLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-10)
            make.top.equalTo(10)
        }
        
        fileContentLabel.snp.makeConstraints { make in
            make.top.equalTo(fileNameLabel.snp.bottom).offset(5)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-10)
        }
    }
    
    // MARK: View
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .back(withName: "ZLCellBack")
        return view
    }()
    
    lazy var fileNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor1")
        label.font = UIFont(name: Font_PingFangSCSemiBold, size: 20)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var fileContentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = UIColor(named: "PatchBack")
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




extension ZLCommitInfoFileCell: ZMBaseViewUpdatableWithViewData {
    
    func zm_fillWithViewData(viewData: ZLCommitInfoFileCellSourceAndDelegate) {
        
        fileNameLabel.text = viewData.fileName
        fileContentLabel.attributedText = viewData.filePatchContent
    }
}

