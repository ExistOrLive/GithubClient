//
//  ZLSearchRecordView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLBaseExtension
import ZLBaseUI

@objc protocol ZLSearchRecordViewDelegate: NSObjectProtocol {
    func clearRecord()
}

class ZLSearchRecordView: ZLBaseView {

    weak var delegate: ZLSearchRecordViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor(named:"ZLVCBackColor")
        addSubview(topBackView)
        topBackView.addSubview(recordLabel)
        topBackView.addSubview(clearButton)
        addSubview(tableView)
        
        topBackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        recordLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.bottom.equalToSuperview()
        }
       
        clearButton.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.top.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topBackView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        
    }

    @objc func onClearButtonClicked(sender: Any) {
        if self.delegate?.responds(to: #selector(ZLSearchRecordViewDelegate.clearRecord)) ?? false {
            self.delegate?.clearRecord()
        }

    }
    
    // MARK: Lazy View
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = .leastNonzeroMagnitude
        tableView.sectionFooterHeight = .leastNonzeroMagnitude
        tableView.register(ZLCommonTableViewCell.self, forCellReuseIdentifier: "ZLCommonTableViewCell")
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = .leastNonzeroMagnitude
        }
        return tableView
    }()
    
    lazy var topBackView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named:"ZLCellBack")
        return view
    }()

    lazy var recordLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named:"ZLLabelColor1")
        label.font = .zlMediumFont(withSize: 14)
        label.text = ZLLocalizedString(string: "SearchRecord", comment: "")
        return label
    }()

    lazy var clearButton: UIButton = {
       let button = UIButton()
        button.setTitle(ZLLocalizedString(string: "ClearSearchRecord", comment: ""), for: .normal)
        button.setTitleColor(UIColor(named:"ZLLabelColor3"), for: .normal)
        button.titleLabel?.font = .zlMediumFont(withSize: 13)
        button.addTarget(self, action: #selector(onClearButtonClicked(sender:)), for: .touchUpInside)
        return button
    }()
}
