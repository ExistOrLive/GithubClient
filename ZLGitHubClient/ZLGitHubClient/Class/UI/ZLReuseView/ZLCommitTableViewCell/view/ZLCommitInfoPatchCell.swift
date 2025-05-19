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
        contentView.addSubview(webContainerView)
       
        webContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
 
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
        let subViews = webContainerView.subviews
        subViews.forEach { $0.removeFromSuperview() }
        webContainerView.addSubview(viewData.webView)
        viewData.webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

