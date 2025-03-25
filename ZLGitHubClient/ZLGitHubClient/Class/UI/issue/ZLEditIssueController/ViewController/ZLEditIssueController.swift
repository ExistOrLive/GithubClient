//
//  ZLEditIssueController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/20.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import ZMMVVM
import ZLGitRemoteService

enum ZLEditIssueSectionType: String, ZMBaseSectionUniqueIDProtocol {
    var zm_ID: String { return self.rawValue }
    case assignees
    case label
    case project
    case milestone
    case operation
}

enum ZLEditIssueOperationType {
    case closeOrOpen
    case lock
    case subscribe
}

class ZLEditIssueController: ZMTableViewController {
    
    // Entry Params
    var loginName: String?
    var repoName: String?
    var number: Int = 0
    
    var refreshStatusBlock: (() -> Void)?
    
    private var data: IssueEditInfoQuery.Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStatus = .loading
        requestNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        contentView.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(60)
        }
        
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableView.register(ZLSimpleUserTableViewCell.self, forCellReuseIdentifier: "ZLSimpleUserTableViewCell")
        tableView.register(ZLIssueLabelsCell.self, forCellReuseIdentifier: "ZLIssueLabelsCell")
        tableView.register(ZLIssueProjectCell.self, forCellReuseIdentifier: "ZLIssueProjectCell")
        tableView.register(ZLIssueMilestoneCell.self, forCellReuseIdentifier: "ZLIssueMilestoneCell")
        tableView.register(ZLIssueNoneCell.self, forCellReuseIdentifier: "ZLIssueNoneCell")
        tableView.register(ZLIssueOperateCell.self, forCellReuseIdentifier: "ZLIssueOperateCell")
        tableView.register(ZLEditIssueHeaderView.self, forHeaderFooterViewReuseIdentifier: "ZLEditIssueHeaderView")
        tableView.register(ZLCommonSectionHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "ZLCommonSectionHeaderFooterView")
    }
    
    private lazy var headerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named:"ZLNavigationBarBackColor")
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
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
        return view
    }()
    
    private lazy var closeButton: UIButton = {
       let button = ZMButton()
        button.setTitle(ZLLocalizedString(string: "Close", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.zlRegularFont(withSize: 14)
        button.addTarget(self, action: #selector(onBackButtonClicked(_ :)), for:.touchUpInside)
        return button
    }()
        
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor(named: "ZLNavigationBarTitleColor")
        label.font = UIFont(name:Font_PingFangSCMedium , size: 18)
        label.text = ZLLocalizedString(string: "Issue", comment: "")
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()
    
}

extension ZLEditIssueController {
  

    func generateSubViewModel() {
        
        self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
        self.sectionDataArray.removeAll()
        
        // assignees
        let assigneesSectionData = ZMBaseTableViewSectionData(zm_sectionID: ZLEditIssueSectionType.assignees)
        assigneesSectionData.headerData = ZLEditIssueHeaderViewData(sectionType: .assignees)
        if let assignees = data?.repository?.issue?.assignees.nodes,
           !assignees.isEmpty {
            var assigneesViewModels = [ZLSimpleUserTableViewCellData]()
            for assignee in assignees {
                let viewModel = ZLSimpleUserTableViewCellData(loginName: assignee?.login ?? "", avatarUrl: assignee?.avatarUrl ?? "")
                assigneesViewModels.append(viewModel)
            }
            assigneesSectionData.cellDatas = assigneesViewModels
        } else {
            assigneesSectionData.cellDatas = [ZLIssueNoneCellData(info: ZLLocalizedString(string: "No one assigned", comment: ""))]
        }
        self.sectionDataArray.append(assigneesSectionData)
        
        // label
        let labelSectionData = ZMBaseTableViewSectionData(zm_sectionID: ZLEditIssueSectionType.label)
        labelSectionData.headerData = ZLEditIssueHeaderViewData(sectionType: .label)
        if let labels = data?.repository?.issue?.labels,
           !(labels.nodes?.isEmpty ?? false) {
            let viewModel = ZLIssueLabelsCellData(data: labels)
            labelSectionData.cellDatas = [viewModel]
        } else {
            labelSectionData.cellDatas = [ZLIssueNoneCellData(info: ZLLocalizedString(string: "None yet", comment: ""))]
        }
        self.sectionDataArray.append(labelSectionData)
        
        // project
        let projectSectionData = ZMBaseTableViewSectionData(zm_sectionID: ZLEditIssueSectionType.project)
        projectSectionData.headerData = ZLEditIssueHeaderViewData(sectionType: .project)
        if let projects = data?.repository?.issue?.projectCards.nodes,
           !projects.isEmpty {
            let projectViewModels = projects.compactMap {
                if let project = $0 {
                    return ZLIssueProjectCellData(data: project)
                } else {
                    return nil
                }
            }
            projectSectionData.cellDatas = projectViewModels
        } else {
            projectSectionData.cellDatas = [ZLIssueNoneCellData(info: ZLLocalizedString(string: "None yet", comment: ""))]
        }
        self.sectionDataArray.append(projectSectionData)
        
        // milestone
        let milestoneSectionData = ZMBaseTableViewSectionData(zm_sectionID: ZLEditIssueSectionType.milestone)
        milestoneSectionData.headerData = ZLEditIssueHeaderViewData(sectionType: .milestone)
        if let milestone = data?.repository?.issue?.milestone {
            let viewModel = ZLIssueMileStoneCellData(data: milestone)
            milestoneSectionData.cellDatas = [viewModel]
        } else {
            milestoneSectionData.cellDatas = [ZLIssueNoneCellData(info: ZLLocalizedString(string: "No milestone", comment: ""))]
        }
        self.sectionDataArray.append(milestoneSectionData)
        
        
        // Operation
        var operationsCellDatas = [ZMBaseTableViewCellViewModel]()
        if data?.repository?.issue?.viewerCanSubscribe ?? false {
            let turnOn = data?.repository?.issue?.viewerSubscription == .subscribed
            operationsCellDatas.append(ZLIssueOperateCellData(operationType: .subscribe,
                                                              turnOn: turnOn,
                                                              clickBlock: { [weak self] _ in
                self?.onOperationAction(type: .subscribe)
            }))
        }
        
        
        if data?.repository?.issue?.viewerCanUpdate ?? false {
            
//            let turnOn1 = data?.repository?.issue?.locked == true
//            operationsCellDatas.append(ZLIssueOperateCellData(operationType: .lock, turnOn: turnOn1))
        
            let turnOn2 = data?.repository?.issue?.closed == false
            operationsCellDatas.append(ZLIssueOperateCellData(operationType: .closeOrOpen,
                                                              turnOn: turnOn2,
                                                              clickBlock: { [weak self] _ in
                self?.onOperationAction(type: .closeOrOpen)
            }))
        }
        
        if !operationsCellDatas.isEmpty {
            let operationsSectionData = ZMBaseTableViewSectionData(zm_sectionID: ZLEditIssueSectionType.operation)
            operationsSectionData.cellDatas = operationsCellDatas
            operationsSectionData.headerData = ZLCommonSectionHeaderFooterViewDataV2(viewHeight: 20)
            operationsSectionData.footerData = ZLCommonSectionHeaderFooterViewDataV2(viewHeight: 30)
            self.sectionDataArray.append(operationsSectionData)
        }
    
        self.sectionDataArray.forEach { $0.zm_addSuperViewModel(self) }
    }
    
    func reloadView() {
        guard let data else { return }
        self.titleLabel.text = data.repository?.issue?.title ?? ""
        self.tableView.reloadData()
    }
    
    
}

// MARK: - Action
extension ZLEditIssueController {
    func onOperationAction(type: ZLEditIssueOperationType) {
        switch type {
        case .closeOrOpen:
            requestCloseOrReopenIssue()
        case .subscribe:
            requestSubscribeIssue()
        case .lock:
            requestLockIssue()
        }
    }
    
    var viewerCanUpdate: Bool {
        data?.repository?.issue?.viewerCanUpdate ?? false
    }
    
  
    
    func onEditAssigneeAction() {
        guard let participants = data?.repository?.issue?.participants.nodes,
              let assignees = data?.repository?.issue?.assignees.nodes else { return }
        var assigneeModels =  [ZLEditAssigneeModel]()
        for participant in participants {
            let assigneeModel = ZLEditAssigneeModel()
            assigneeModel.login = participant?.login ?? ""
            assigneeModel.id = participant?.id ?? ""
            assigneeModel.avatar = participant?.avatarUrl ?? ""
            
            for tmp in assignees {
                if tmp?.id == participant?.id {
                    assigneeModel.selected = true
                }
            }
            assigneeModels.append(assigneeModel)
        }
        
        ZLEditAssigneesView.showEditAssigneesView(data: assigneeModels) { [weak self] (addIds, removeIds) in
            self?.requestEditAssignee(addID: addIds, removeID: removeIds)
        }
    }
}


// MARK: -  Request

extension ZLEditIssueController {
    
    func requestNewData() {
        
        ZLEventServiceShared()?.getIssueEditInfo(withLoginName: loginName ?? "",
                                                 repoName: repoName ?? "" ,
                                                 number: Int32(number),
                                                 serialNumber: NSString.generateSerialNumber())
        { [weak self] result in
            
            guard let self = self else { return }
            
            if result.result,
               let data = result.data as? IssueEditInfoQuery.Data {
                self.viewStatus = .normal
                self.data = data
                self.generateSubViewModel()
                self.reloadView()
            } else {
                guard let errorModel = result.data as? ZLGithubRequestErrorModel else {
                    return
                }
                self.viewStatus = .error
                ZLToastView.showMessage(errorModel.message)
            }
        }
    }
    
    func requestCloseOrReopenIssue() {
        
        guard let id = data?.repository?.issue?.id,
              let isClosed = data?.repository?.issue?.closed else {
            return
        }
        
        view.showProgressHUD()
        
        ZLServiceManager
            .sharedInstance
            .eventServiceModel?
            .openOrCloseIssue(id,
                              open: isClosed,
                              serialNumber: NSString.generateSerialNumber())
        { [weak self] resultModel in
            
            guard let self = self else { return }
            
            self.view.dismissProgressHUD()
            if resultModel.result {
                self.requestNewData()
                self.refreshStatusBlock?()
            } else {
                ZLToastView.showMessage("Request Failed")
            }
        }
    }
    
    func requestSubscribeIssue() {
        
        guard let id = data?.repository?.issue?.id else {
            return
        }
        
        view.showProgressHUD()
        
        let isSubscribe = data?.repository?.issue?.viewerSubscription == .subscribed
        
        ZLServiceManager
            .sharedInstance
            .eventServiceModel?
            .subscribeOrUnsubscribeSubscription(id,
                                                subscribe: !isSubscribe,
                                                serialNumber: NSString.generateSerialNumber())
        { [weak self] resultModel in
            guard let self = self else { return }
            self.view.dismissProgressHUD()
            if resultModel.result {
                self.requestNewData()
            } else {
                ZLToastView.showMessage("Request Failed")
            }
                
        }
    }
    
    func requestLockIssue() {
        
        guard let id = data?.repository?.issue?.id else {
            return
        }
        
        view.showProgressHUD()
        
        let isLock = data?.repository?.issue?.locked == true
        
        ZLEventServiceShared()?.lockOrUnlockLockable(id,
                                                     lock: !isLock,
                                                     serialNumber: NSString.generateSerialNumber())
        { [weak self] resultModel in
            guard let self = self else { return  }
            self.view.dismissProgressHUD()
            if resultModel.result {
                self.requestNewData()
            } else {
                ZLToastView.showMessage("Request Failed")
            }
        }
    }
    
    
    func requestEditAssignee(addID: [String], removeID: [String]) {
        
        guard let id = data?.repository?.issue?.id else {
            return
        }
        
        view.showProgressHUD()
        
        ZLEventServiceShared()?.editIssueAssignees(withIssueId: id,
                                                   addedList: addID,
                                                   removedList: removeID,
                                                   serialNumber: NSString.generateSerialNumber())
        { [weak self] resultModel in
            guard let self = self else { return  }
            self.view.dismissProgressHUD()
            if resultModel.result {
                self.requestNewData()
            } else {
                ZLToastView.showMessage("Request Failed")
            }
        }
    }
}


