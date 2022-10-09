//
//  ZLIssueMilestoneCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/23.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension

protocol ZLIssueMilestoneCellDelegateAndDataSource {
    
    var title: String { get }
    
    var percent: Double { get }
}

class ZLIssueMilestoneCell: UITableViewCell {
    
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
    
    private lazy var milestoneTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor1")
        label.font = .zlMediumFont(withSize: 15)
        return label
    }()
    
    private lazy var progressView: ZLProgressView = {
       let view = ZLProgressView()
        return view 
    }()
    
}

extension ZLIssueMilestoneCell {
    
    func setupUI() {
        
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(containerView)
        containerView.addSubview(milestoneTitleLabel)
        containerView.addSubview(progressView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        }
        milestoneTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(20)
        }
        progressView.snp.makeConstraints { make in
            make.top.equalTo(milestoneTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-15)
            make.height.equalTo(10)
        }
        progressView.cornerRadius = 5
        progressView.layer.masksToBounds = true 
    }
}

extension ZLIssueMilestoneCell: ZLViewUpdatableWithViewData {
    func justUpdateView() {
        
    }
    
    func fillWithViewData(viewData: ZLIssueMilestoneCellDelegateAndDataSource) {
        
        milestoneTitleLabel.text = viewData.title
        progressView.set(params: [(viewData.percent,UIColor.back(withName: "done")),
                                  (100 - viewData.percent,UIColor.back(withName: "todo"))])
    }
}
