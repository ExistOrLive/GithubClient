//
//  ZLEditIssueHeaderView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/23.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import ZMMVVM

class ZLEditIssueHeaderView: UITableViewHeaderFooterView {
    
    var viewData: ZLEditIssueHeaderViewData? {
        zm_viewModel as? ZLEditIssueHeaderViewData
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lazy View
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zlMediumFont(withSize: 16)
        label.textColor = UIColor(named:"ZLLabelColor1")
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = ZMButton()
        button.setTitle(ZLLocalizedString(string: "Edit", comment: ""), for: .normal)
        button.titleLabel?.font = .zlRegularFont(withSize: 13)
        button.addTarget(self, action: #selector(onEditButtonClicked), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var separateLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLSeperatorLineColor")
        return view
    }()
}

extension ZLEditIssueHeaderView {
    
    func setupUI() {
        
        backgroundColor = .clear
        
        addSubview(titleLabel)
        addSubview(editButton)
        addSubview(separateLine)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        editButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.size.equalTo(CGSize(width: 60, height: 30))
            make.centerY.equalToSuperview()
        }
        
        separateLine.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.height.equalTo(1.0 / UIScreen.main.scale)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension ZLEditIssueHeaderView {
    @objc func onEditButtonClicked() {
        viewData?.onEditButtonAction()
    }
}


extension ZLEditIssueHeaderView: ZMBaseViewUpdatableWithViewData {

    func zm_fillWithViewData(viewData: ZLEditIssueHeaderViewData) {
        titleLabel.text = viewData.title
        editButton.isHidden = !viewData.showEditButton
    }
}
