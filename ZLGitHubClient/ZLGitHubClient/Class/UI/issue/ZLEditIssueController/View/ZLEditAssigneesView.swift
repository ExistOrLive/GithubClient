//
//  ZLEditAssigneesView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/31.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import FFPopup

//class ZLEditAssigneesView: UIView {
//
//    private var selectedAssignees: []
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupUI() {
//        backgroundColor = UIColor(named: "ZLPopUpBackColor")
//
//        addSubview(headerView)
//        headerView.addSubview(titleLabel)
//        headerView.addSubview(saveButton)
//        addSubview(tableView)
//
//        headerView.snp.makeConstraints { make in
//            make.top.left.right.equalToSuperview()
//            make.height.equalTo(80)
//        }
//
//        titleLabel.snp.makeConstraints { make in
//            make.left.equalTo(20)
//            make.centerY.equalToSuperview()
//        }
//
//        saveButton.snp.makeConstraints { make in
//            make.right.equalTo(-20)
//            make.size.equalTo(CGSize(width: 100, height: 60))
//        }
//
//        tableView.snp.makeConstraints { make in
//            make.top.equalTo(headerView.snp.bottom)
//            make.bottom.left.right.equalToSuperview()
//        }
//
//    }
//
//
//    private lazy var headerView: UIView = {
//       let view = UIView()
//        view.backgroundColor = UIColor(named: "ZLPopUpBackColor")
//        return view
//    }()
//
//    private lazy var titleLabel: UILabel = {
//       let label = UILabel()
//        label.textColor = UIColor(named:"ZLPopupTitleColor")
//        return label
//    }()
//
//    private lazy var saveButton: UIButton = {
//        let button = ZLBaseButton()
//        button.setTitle(ZLLocalizedString(string: "Save", comment: ""), for: .normal)
//        return button
//    }()
//
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
//        tableView.initCommonTableView()
//        tableView.register(ZLSimpleUserTableViewCell.self, forCellReuseIdentifier: "ZLSimpleUserTableViewCell")
//        tableView.delegate = self
//        tableView.dataSource = self
//        return tableView
//    }()
//}
//
//// MARK: UITableView
//extension ZLEditAssigneesView: UITableViewDelegate,UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        0
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        2
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = UIColor.clear
//        let label = UILabel()
//        label.textColor = UIColor(named: "ZLLabelColor2")
//        label.font = UIFont(name: Font_PingFangSCRegular, size: 14)
//        view.addSubview(label)
//        label.snp.makeConstraints { (make) in
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(15)
//            make.bottom.equalToSuperview().offset(-5)
//        }
//
//        label.text = section == 0 ? ZLLocalizedString(string: "SELECTED", comment: "") : ZLLocalizedString(string: "UNSELECTED", comment: "")
//        return view
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSimpleRepoTableViewCell") as? ZLSimpleRepoTableViewCell {
//            return tableViewCell
//        } else {
//            return UITableViewCell()
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        60
//    }
//
//
//}
