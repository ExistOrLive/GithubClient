//
//  ZLEditAssigneesView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/31.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import FFPopup
import ZLBaseUI
import ZLBaseExtension

class ZLEditAssigneeModel: NSObject {
    var id: String = ""
    var login: String = ""
    var avatar: String = ""
    var selected: Bool = false
}

class ZLEditAssigneesView: UIView {

    fileprivate var originalSelectedAssignees: [ZLEditAssigneeModel] = []
    
    fileprivate var selectedAssignees: [ZLEditAssigneeModel] = []

    fileprivate var unselectedAssignees: [ZLEditAssigneeModel] = []
    
    fileprivate var pop: FFPopup?
    
    fileprivate var resultBlock: (([String],[String]) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor(named: "ZLPopUpBackColor")
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        
        addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(saveButton)
        addSubview(tableView)

        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }

        saveButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.size.equalTo(CGSize(width: 60, height: 25))
            make.centerY.equalToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }

    }
    
    private func setOriginalData(pop: FFPopup,
                                 data: [ZLEditAssigneeModel],
                                 resultBlock: (([String],[String]) -> Void)?) {
        self.pop = pop
        self.resultBlock = resultBlock
        for assignee in data {
            if assignee.selected {
                originalSelectedAssignees.append(assignee)
                selectedAssignees.append(assignee)
            } else {
                unselectedAssignees.append(assignee)
            }
        }
        self.tableView.reloadData()
    }
    
    @objc private func onSaveButtonClicked() {
        var selectedId: [String] = []
        var removedId: [String] = []
        
        for assignee in selectedAssignees {
            if !originalSelectedAssignees.contains(assignee) {
                selectedId.append(assignee.id)
            }
        }
        
        for assignee in unselectedAssignees {
            if originalSelectedAssignees.contains(assignee) {
                removedId.append(assignee.id)
            }
        }
        
        if selectedId.isEmpty && removedId.isEmpty {
            ZLToastView.showMessage("No Change")
        } else {
            resultBlock?(selectedId,removedId)
        }
        
        pop?.dismiss(animated: true)
       
    }
    
    // MARK: Lazy View
    private lazy var headerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "ZLPopUpTitleBackView")
        return view
    }()

    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor(named:"ZLPopupTitleColor")
        label.font = .zlMediumFont(withSize: 15)
        label.text = ZLLocalizedString(string: "Assignee", comment: "")
        return label
    }()

    private lazy var saveButton: UIButton = {
        let button = ZLBaseButton()
        button.setTitle(ZLLocalizedString(string: "Save", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(onSaveButtonClicked), for: .touchUpInside)
        button.titleLabel?.font = UIFont.zlRegularFont(withSize: 12)
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.initCommonTableView()
        tableView.register(ZLSimpleUserTableViewCell.self, forCellReuseIdentifier: "ZLSimpleUserTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}

// MARK: UITableView
extension ZLEditAssigneesView: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return selectedAssignees.count
        } else {
            return unselectedAssignees.count
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 && self.selectedAssignees.isEmpty {
            return 40
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 && self.selectedAssignees.isEmpty {
            let label = UILabel()
            label.backgroundColor = UIColor(named: "ZLCellBack")
            label.textColor = UIColor(named: "ZLLabelColor2")
            label.font = UIFont(name: Font_PingFangSCRegular, size: 12)
            label.textAlignment = .center
            label.text = ZLLocalizedString(string: "No one assigned", comment: "")
            return label
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.font = UIFont(name: Font_PingFangSCRegular, size: 12)
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(15)
            make.bottom.equalToSuperview().offset(-5)
        }

        label.text = section == 0 ? ZLLocalizedString(string: "SELECTED", comment: "") : ZLLocalizedString(string: "UNSELECTED", comment: "")
        return view
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSimpleUserTableViewCell") as? ZLSimpleUserTableViewCell {
            tableViewCell.avatarImageView.snp.updateConstraints { make in
                make.size.equalTo(25)
            }
            tableViewCell.fullNameLabel.font = UIFont(name: Font_PingFangSCMedium, size: 11)
            
            var assignee: ZLEditAssigneeModel? = nil
            if indexPath.section == 0 {
                assignee = selectedAssignees[indexPath.row]
                if indexPath.row == selectedAssignees.count - 1 {
                    tableViewCell.singleLineView.isHidden = true
                } else {
                    tableViewCell.singleLineView.isHidden = false
                }
            } else {
                assignee = unselectedAssignees[indexPath.row]
                if indexPath.row == unselectedAssignees.count - 1 {
                    tableViewCell.singleLineView.isHidden = true
                } else {
                    tableViewCell.singleLineView.isHidden = false
                }
            }
            tableViewCell.fullNameLabel.text = assignee?.login
            tableViewCell.avatarImageView.sd_setImage(with: URL(string: assignee?.avatar ?? ""), placeholderImage: UIImage(named: "default_avatar"))
        
            return tableViewCell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        45
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // 移除
            let assignee = selectedAssignees.remove(at: indexPath.row)
            unselectedAssignees.insert(assignee, at: 0)
        } else {
            // 添加
            let assignee = unselectedAssignees.remove(at: indexPath.row)
            selectedAssignees.append(assignee)
        }
        tableView.reloadData()
    }

}


extension ZLEditAssigneesView {
    
    static func showEditAssigneesView(data: [ZLEditAssigneeModel],
                                      resultBlock: (([String],[String]) -> Void)?) {
        let view = ZLEditAssigneesView(frame: CGRect(x: 0, y: 0, width: 280, height:400))
        let popup: FFPopup = FFPopup(contentView: view,
                                     showType: .bounceIn,
                                     dismissType: .bounceOut,
                                     maskType: FFPopup.MaskType.dimmed,
                                     dismissOnBackgroundTouch: true,
                                     dismissOnContentTouch: false)
        view.setOriginalData(pop: popup , data: data, resultBlock: resultBlock)
        popup.show(layout: .Center)
    }
    
}


