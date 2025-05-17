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
import WebKit

protocol ZLCommitInfoPatchCellSourceAndDelegate: NSObjectProtocol {
    var webView: WKWebView { get }
    var fileName: String { get }
}


class ZLCommitInfoPatchCell: UITableViewCell {
    
    var delegate: ZLCommitInfoPatchCellSourceAndDelegate? {
        zm_viewModel as? ZLCommitInfoPatchCellSourceAndDelegate
    }
    
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(backView)
       
        backView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: View
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .back(withName: "ZLCellBack")
        view.addSubview(filePathView)
        view.addSubview(webContainerView)
        filePathView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        webContainerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(filePathView.snp.bottom)
        }
        return view
        
    }()
    
    lazy var filePathView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(filePathLabel)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false 
        filePathLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.bottom.equalTo(-5)
            make.right.equalTo(-10)
        }
        return scrollView
    }()
    
    lazy var filePathLabel: UILabel = {
        let label = UILabel()
        label.font = .zlMediumFont(withSize: 16)
        label.textColor = .label(withName: "ZLLabelColor1")
        return label
    }()
    
    lazy var webContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .back(withName: "ZLCellBack")
        return view
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




extension ZLCommitInfoPatchCell: ZMBaseViewUpdatableWithViewData {
    
    func zm_fillWithViewData(viewData: ZLCommitInfoPatchCellSourceAndDelegate) {
        filePathLabel.text = viewData.fileName
        let subViews = webContainerView.subviews
        subViews.forEach { $0.removeFromSuperview() }
        webContainerView.addSubview(viewData.webView)
        viewData.webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

