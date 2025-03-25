//
//  ZLIssueProjectCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/23.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import ZMMVVM

protocol ZLIssueProjectCellDataSourceAndDeledate {
    
    var projectTitle: String { get }
    
    var projectColumnTitle: String { get }
    
    var toDoValue: Double { get }
    
    var doneValue: Double { get }
    
    var inProgessValue: Double { get }
}

class ZLIssueProjectCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lazy View
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLCellBack")
        view.cornerRadius = 8.0
        return view
    }()
    
    private lazy var projectTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor1")
        label.font = .zlMediumFont(withSize: 15)
        return label
    }()
    
    private lazy var progressView: ZLProgressView = {
       let view = ZLProgressView()
        return view
    }()
    
    private lazy var projectColumnLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor4")
        label.font = .zlRegularFont(withSize: 12)
        return label
    }()
    
}

extension ZLIssueProjectCell {
    
    func setupUI() {
        
        selectionStyle = .none
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.addSubview(projectTitleLabel)
        containerView.addSubview(progressView)
        containerView.addSubview(projectColumnLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        }
        projectTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(20)
        }
        progressView.snp.makeConstraints { make in
            make.top.equalTo(projectTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(10)
        }
        projectColumnLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.bottom.equalTo(-10)
        }
        progressView.cornerRadius = 5
        progressView.layer.masksToBounds = true
    }
}

extension ZLIssueProjectCell: ZMBaseViewUpdatableWithViewData {

    func zm_fillWithViewData(viewData: ZLIssueProjectCellDataSourceAndDeledate) {
        
        projectTitleLabel.text = viewData.projectTitle
        projectColumnLabel.text = viewData.projectColumnTitle
        
        progressView.set(params: [(viewData.doneValue,UIColor.back(withName: "done")),
                                  (viewData.inProgessValue,UIColor.back(withName: "inprogress")),
                                  (viewData.toDoValue,UIColor.back(withName: "todo"))])
    }
}
