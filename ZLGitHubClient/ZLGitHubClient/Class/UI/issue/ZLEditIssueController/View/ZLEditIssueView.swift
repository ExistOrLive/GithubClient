//
//  ZLEditIssueView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/21.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import RxSwift
import ZLBaseExtension

enum ZLEditIssueOperationType {
    case closeOrOpen
    case lock
    case subscribe
}

enum ZLEditIssueSectionType {
    case assignees([ZLGithubItemTableViewCellDataProtocol])
    case label(ZLGithubItemTableViewCellDataProtocol)
    case project([ZLGithubItemTableViewCellDataProtocol])
    case milestone([ZLGithubItemTableViewCellDataProtocol])
    case operation([ZLGithubItemTableViewCellDataProtocol])
}

protocol ZLEditIssueViewDelegateAndSource: NSObjectProtocol {
    
    var sectionTypes: [ZLEditIssueSectionType] { get }
    
    var refreshEvent: Observable<Void> { get }
    
    var titleObservable: Observable<String> { get }
    
    var viewerCanUpdate : Bool { get }
    
    func onCloseAction()
    
    func onEditAssigneeAction()
}


class ZLEditIssueView: ZLBaseView {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    weak var delegate: ZLEditIssueViewDelegateAndSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: lazy view
    
    private lazy var headerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named:"ZLNavigationBarBackColor")
        return view
    }()
    
    private lazy var closeButton: UIButton = {
       let button = ZLBaseButton()
        button.setTitle(ZLLocalizedString(string: "Close", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.zlRegularFont(withSize: 14)
        return button
    }()
        
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor(named: "ZLNavigationBarTitleColor")
        label.font = UIFont(name:Font_PingFangSCMedium , size: 18)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.text = ZLLocalizedString(string: "Comment", comment: "")
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.initCommonTableView()
        tableView.register(ZLSimpleUserTableViewCell.self, forCellReuseIdentifier: "ZLSimpleUserTableViewCell")
        tableView.register(ZLIssueLabelsCell.self, forCellReuseIdentifier: "ZLIssueLabelsCell")
        tableView.register(ZLIssueProjectCell.self, forCellReuseIdentifier: "ZLIssueProjectCell")
        tableView.register(ZLIssueMilestoneCell.self, forCellReuseIdentifier: "ZLIssueMilestoneCell")
        tableView.register(ZLIssueNoneCell.self, forCellReuseIdentifier: "ZLIssueNoneCell")
        tableView.register(ZLIssueOperateCell.self, forCellReuseIdentifier: "ZLIssueOperateCell")
        tableView.registerHeaderFooterView(ZLEditIssueHeaderView.self)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}

extension ZLEditIssueView {
    
    func setupUI() {
        
        addSubview(headerView)
        addSubview(tableView)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(closeButton)
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top).offset(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.bottom.equalToSuperview()
            make.left.equalTo(100)
            make.right.equalTo(-100)
        }
        
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 70, height: 30))
            make.bottom.equalTo(-15)
            make.left.equalTo(10)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        closeButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.delegate?.onCloseAction()
        }).disposed(by: disposeBag)
    }
    
    override func tintColorDidChange() {
        tableView.reloadData()
    }
}

extension ZLEditIssueView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let sectionType = delegate?.sectionTypes[indexPath.section] else {
            return UITableViewCell()
        }
        
        switch sectionType {
        case let .assignees(dataSources):
            let datasource = dataSources[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: datasource.getCellReuseIdentifier(), for: indexPath)
            if let cell = cell as? ZLSimpleUserTableViewCell,
               let cellData = datasource as? ZLSimpleUserTableViewCellDataSource {
                cell.fillWithData(viewData: cellData)
            }
            if let cell = cell as? ZLIssueNoneCell,
               let cellData = datasource as? ZLIssueNoneCellDataSource {
                cell.fillWithData(viewData: cellData)
            }
            return cell 
        case let .label(dataSource):
            let cell = tableView.dequeueReusableCell(withIdentifier: dataSource.getCellReuseIdentifier(), for: indexPath)
            if let cell = cell as? ZLIssueLabelsCell,
               let cellData = dataSource as? ZLIssueLabelsCellDataSource {
                cell.fillWithData(viewData: cellData)
            }
            if let cell = cell as? ZLIssueNoneCell,
               let cellData = dataSource as? ZLIssueNoneCellDataSource {
                cell.fillWithData(viewData: cellData)
            }
            return cell
        case let .milestone(dataSources):
            let datasource = dataSources[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: datasource.getCellReuseIdentifier(), for: indexPath)
            if let cell = cell as? ZLIssueMilestoneCell,
               let cellData = datasource as? ZLIssueMilestoneCellDelegateAndDataSource {
                cell.fillWithData(viewData: cellData)
            }
            if let cell = cell as? ZLIssueNoneCell,
               let cellData = datasource as? ZLIssueNoneCellDataSource {
                cell.fillWithData(viewData: cellData)
            }
            return cell
        case let .project(dataSources):
            let datasource = dataSources[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: datasource.getCellReuseIdentifier(), for: indexPath)
            if let cell = cell as? ZLIssueProjectCell,
               let cellData = datasource as?  ZLIssueProjectCellDataSourceAndDeledate{
                cell.fillWithData(viewData: cellData)
            }
            if let cell = cell as? ZLIssueNoneCell,
               let cellData = datasource as? ZLIssueNoneCellDataSource {
                cell.fillWithData(viewData: cellData)
            }
            return cell
        case let .operation(dataSources):
            let dataSource = dataSources[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: dataSource.getCellReuseIdentifier(), for: indexPath)
            if let cell = cell as? ZLIssueOperateCell,
               let cellData = dataSource as? ZLIssueOperateCellDataSource {
                cell.fillWithData(viewData: cellData)
            }
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        delegate?.sectionTypes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = delegate?.sectionTypes[section] else {
            return 0
        }
        
        switch sectionType {
        case let .assignees(dataSources):
            return dataSources.count
        case .label:
            return 1
        case let .milestone(dataSources):
            return dataSources.count
        case let .project(dataSources):
            return dataSources.count
        case let .operation(dataSources):
            return dataSources.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = delegate?.sectionTypes[section] else {
            return CGFloat.leastNormalMagnitude
        }
        switch sectionType {
        case .project, .label, .assignees, .milestone:
            return 50
        case .operation:
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == delegate?.sectionTypes.count ?? 0 - 1 {
            return 30
        } else {
            return CGFloat.leastNonzeroMagnitude
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(ZLEditIssueHeaderView.self)
        headerView.editButton.isHidden = true
        guard let sectionType = delegate?.sectionTypes[section] else {
            return headerView
        }
        
        switch sectionType {
        case .assignees:
            headerView.fillWithData(viewData: (ZLLocalizedString(string: "Assignee", comment: ""), { [weak self] in
                self?.delegate?.onEditAssigneeAction()
            }))
            if delegate?.viewerCanUpdate ?? false {
                headerView.editButton.isHidden = false
            }
        case .label:
            headerView.fillWithData(viewData: (ZLLocalizedString(string: "Label", comment: ""), nil))
        case .milestone:
            headerView.fillWithData(viewData: (ZLLocalizedString(string: "Milestone", comment: ""), nil))
        case .project:
            headerView.fillWithData(viewData: (ZLLocalizedString(string: "Project", comment: ""), nil))
        case .operation:
            let view = UIView()
            view.backgroundColor = .clear
            return view
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view 
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}


extension ZLEditIssueView: ViewUpdatable {
    func fillWithData(viewData: ZLEditIssueViewDelegateAndSource) {
        delegate = viewData
        viewData.refreshEvent.subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewData.titleObservable.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    }
}

