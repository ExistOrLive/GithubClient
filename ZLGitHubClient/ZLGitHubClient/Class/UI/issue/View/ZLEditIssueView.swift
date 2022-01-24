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

enum ZLEditIssueSectionType {
    case assignees([ZLSimpleUserTableViewCellDataSource])
    case label(ZLIssueLabelsCellDataSource)
    case project([ZLIssueProjectCellDataSourceAndDeledate])
    case milestone([ZLIssueMilestoneCellDelegateAndDataSource])
}

protocol ZLEditIssueViewDelegateAndSource: NSObjectProtocol {
    
    var sectionTypes: [ZLEditIssueSectionType] { get }
    
    var refreshEvent: Observable<Void> { get }
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
    
    lazy var commentButton: UIButton = {
        let button = ZLBaseButton()
        button.setTitle(ZLLocalizedString(string: "comment", comment: ""), for: .normal)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.initCommonTableView()
        tableView.register(ZLSimpleUserTableViewCell.self)
        tableView.register(ZLIssueLabelsCell.self)
        tableView.register(ZLIssueProjectCell.self)
        tableView.register(ZLIssueMilestoneCell.self)
        tableView.registerHeaderFooterView(ZLEditIssueHeaderView.self)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
}

extension ZLEditIssueView {
    
    func setupUI() {
        
        addSubview(commentButton)
        addSubview(tableView)
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(30)
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(commentButton.snp.bottom).offset(10)
            make.bottom.left.right.equalToSuperview()
        }
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
            let cell = tableView.dequeueReusableCell(ZLSimpleUserTableViewCell.self, for: indexPath)
            cell.fillWithData(viewData:datasource)
            return cell 
        case let .label(dataSource):
            let cell = tableView.dequeueReusableCell(ZLIssueLabelsCell.self, for: indexPath)
            cell.fillWithData(viewData:dataSource)
            return cell
        case let .milestone(dataSources):
            let datasource = dataSources[indexPath.row]
            let cell = tableView.dequeueReusableCell(ZLIssueMilestoneCell.self, for: indexPath)
            cell.fillWithData(viewData:datasource)
            return cell
        case let .project(dataSources):
            let datasource = dataSources[indexPath.row]
            let cell = tableView.dequeueReusableCell(ZLIssueProjectCell.self, for: indexPath)
            cell.fillWithData(viewData:datasource)
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
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionType = delegate?.sectionTypes[indexPath.section] else {
            return 0
        }
        switch sectionType {
        case .assignees:
            return 60
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(ZLEditIssueHeaderView.self)
        
        guard let sectionType = delegate?.sectionTypes[section] else {
            return headerView
        }
        
        switch sectionType {
        case .assignees:
            headerView.fillWithData(viewData: (ZLLocalizedString(string: "Assignee", comment: ""), nil))
        case .label:
            headerView.fillWithData(viewData: (ZLLocalizedString(string: "Label", comment: ""), nil))
        case .milestone:
            headerView.fillWithData(viewData: (ZLLocalizedString(string: "Milestone", comment: ""), nil))
        case .project:
            headerView.fillWithData(viewData: (ZLLocalizedString(string: "Project", comment: ""), nil))
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view 
    }
    
}


extension ZLEditIssueView: ViewUpdatable {
    func fillWithData(viewData: ZLEditIssueViewDelegateAndSource) {
        delegate = viewData
        viewData.refreshEvent.subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

