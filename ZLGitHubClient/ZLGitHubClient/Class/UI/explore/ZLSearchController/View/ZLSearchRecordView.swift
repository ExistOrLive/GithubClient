//
//  ZLSearchRecordView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLBaseExtension
import ZMMVVM

@objc protocol ZLSearchRecordViewDelegate: NSObjectProtocol {
    func didSelectRecord(record: String)
    
    func clearRecord()
    
    var tmpSearchRecordArray: [String] { get }
}

class ZLSearchRecordView: UIView {

    var delegate: ZLSearchRecordViewDelegate? {
        zm_viewModel as? ZLSearchRecordViewDelegate
    }

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
        tableView.delegate = self
        tableView.dataSource = self
        
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

extension ZLSearchRecordView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let delegate {
            return delegate.tmpSearchRecordArray.count
        } else {
            return 0
        }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let record = delegate?.tmpSearchRecordArray[indexPath.row],
              let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLCommonTableViewCell", for: indexPath) as? ZLCommonTableViewCell else {
            return UITableViewCell.init(style: .default, reuseIdentifier: "")
        }
        tableViewCell.titleLabel.text = record
        tableViewCell.titleLabel.font = .zlRegularFont(withSize: 13)
        tableViewCell.titleLabel.textColor = UIColor(named: "ZLLabelColor3")
        tableViewCell.nextLabel.isHidden = false
        tableViewCell.separateLine.isHidden = false
        return tableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let record = delegate?.tmpSearchRecordArray[indexPath.row] else { return }
        delegate?.didSelectRecord(record: record)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}

extension ZLSearchRecordView: ZMBaseViewUpdatableWithViewData {
    func zm_fillWithViewData(viewData: ZLSearchRecordViewDelegate) {
        tableView.reloadData()
    }
}
