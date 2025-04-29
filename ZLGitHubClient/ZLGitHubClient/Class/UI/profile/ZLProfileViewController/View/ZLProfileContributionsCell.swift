//
//  ZLProfileContributionsCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/10/7.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import ZLBaseExtension
import ZLUIUtilities
import ZLUtilities
import ZMMVVM

protocol ZLProfileContributionsCellDataSourceAndDelegate: AnyObject {
    
    var loginName: String { get }
    
    var isForce: Bool { get }
    
    func onAllUpdateButtonClicked()
}

class ZLProfileContributionsCell: UITableViewCell {
    
    weak var delegate: ZLProfileContributionsCellDataSourceAndDelegate? {
        zm_viewModel as? ZLProfileContributionsCellDataSourceAndDelegate
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        selectionStyle = .none 
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(topBackView)
        contentView.addSubview(contributionBackView)
        contributionBackView.addSubview(titleLabel)
        contributionBackView.addSubview(allUpdateButton)
        contributionBackView.addSubview(contributionsView)
    }
    
    private func setupLayout() {
        
        topBackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        contributionBackView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(15)
        }
        
        allUpdateButton.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.centerY.equalTo(titleLabel)
        }
        
        contributionsView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-10)
            make.height.equalTo(100)
        }
    }
        
    
    
    // MARK: lazy view
    private lazy var topBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var contributionBackView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named:"ZLCellBack")
        view.cornerRadius = 10
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.label(withName: "ZLLabelColor1")
        label.font = UIFont.zlMediumFont(withSize: 14)
        label.text = ZLLocalizedString(string: "latest update", comment: "最近修改")
        return label 
    }()
    
    private lazy var allUpdateButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.zlIconFont(withSize: 11)
        button.setTitle("\(ZLLocalizedString(string: "all update", comment: "查看全部修改")) \(ZLIconFont.NextArrow.rawValue)", for: .normal)
        button.setTitleColor(UIColor.label(withName: "ZLLabelColor2"), for: .normal)
        button.addTarget(self, action: #selector(onAllUpdateButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var contributionsView: ZLUserContributionsView = {
       let view = ZLUserContributionsView()
        return view
    }()
}

extension ZLProfileContributionsCell {
    @objc func onAllUpdateButtonClicked() {
        self.delegate?.onAllUpdateButtonClicked()
    }
}

// MARK: ZLViewUpdatableWithViewData 
extension ZLProfileContributionsCell: ZMBaseViewUpdatableWithViewData {

    func zm_fillWithViewData(viewData: ZLProfileContributionsCellDataSourceAndDelegate) {
        contributionsView.update(loginName: viewData.loginName, force: viewData.isForce)
        self.titleLabel.text = ZLLocalizedString(string: "latest update", comment: "最近修改")
        self.allUpdateButton.setTitle("\(ZLLocalizedString(string: "all update", comment: "查看全部修改")) \(ZLIconFont.NextArrow.rawValue)", for: .normal)
    }
}
