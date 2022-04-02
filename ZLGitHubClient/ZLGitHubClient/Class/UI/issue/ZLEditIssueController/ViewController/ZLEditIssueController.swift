//
//  ZLEditIssueController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/20.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import RxSwift
import RxRelay
import ZLGitRemoteService

class ZLEditIssueController: ZLBaseViewController {
    
    // Entry Params
    var loginName: String?
    var repoName: String?
    var number: Int = 0
    
    var refreshStatusBlock: (() -> Void)?
    
    private var data: IssueEditInfoQuery.Data?
    
    private var _sectionType = [ZLEditIssueSectionType]()
    private var _refreshEvent = PublishRelay<Void>()
    private var _titleEvent = BehaviorRelay<String>(value: ZLLocalizedString(string: "Issue", comment: ""))


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestNewData()
    }
    
    lazy var editIssueView: ZLEditIssueView = {
        ZLEditIssueView()
    }()

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension ZLEditIssueController {
    
    func setupUI() {
    
        contentView.addSubview(editIssueView)
        editIssueView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // bind 
        editIssueView.fillWithData(viewData: self)
    }
    
    func generateSubViewModel() {
        
        let subViewModels = self.subViewModels
        for viewModel in subViewModels {
            viewModel.removeFromSuperViewModel()
        }
        _sectionType.removeAll()
        
        // assignees
        if let assignees = data?.repository?.issue?.assignees.nodes,
           !assignees.isEmpty {
            var assigneesViewModels = [ZLSimpleUserTableViewCellData]()
            for assignee in assignees {
                let viewModel = ZLSimpleUserTableViewCellData(loginName: assignee?.login ?? "", avatarUrl: assignee?.avatarUrl ?? "")
                assigneesViewModels.append(viewModel)
            }
            _sectionType.append(.assignees(assigneesViewModels))
        } else {
            _sectionType.append(.assignees([ZLIssueNoneCellData(info: ZLLocalizedString(string: "No one assigned", comment: ""))]))
        }
        
        // label
        if let labels = data?.repository?.issue?.labels,
           !(labels.nodes?.isEmpty ?? false) {
            let viewModel = ZLIssueLabelsCellData(data: labels)
            _sectionType.append(.label(viewModel))
        } else {
            _sectionType.append(.label(ZLIssueNoneCellData(info: ZLLocalizedString(string: "None yet", comment: ""))))
        }
        
        // project
        if let projects = data?.repository?.issue?.projectCards.nodes,
           !projects.isEmpty {
            var projectViewModels = [ZLIssueProjectCellData]()
            for project in projects {
                if let project = project {
                    let viewModel = ZLIssueProjectCellData(data: project)
                    projectViewModels.append(viewModel)
                }
            }
            _sectionType.append(.project(projectViewModels))
        } else {
            _sectionType.append(.project([ZLIssueNoneCellData(info: ZLLocalizedString(string: "None yet", comment: ""))]))
        }
        
        // milestone
        if let milestone = data?.repository?.issue?.milestone {
            let viewModel = ZLIssueMileStoneCellData(data: milestone)
            _sectionType.append(.milestone([viewModel]))
        } else {
            _sectionType.append(.milestone([ZLIssueNoneCellData(info: ZLLocalizedString(string: "No milestone", comment: ""))]))
        }
        
        // Operation
        var operationsCellDatas = [ZLGithubItemTableViewCellData]()
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
            _sectionType.append(.operation(operationsCellDatas))
        }
        

    }
    
    func reloadView() {
        // 刷新
        _refreshEvent.accept(())
    }
    
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
}

// MARK: - ZLEditIssueViewDelegateAndSource
extension ZLEditIssueController: ZLEditIssueViewDelegateAndSource {
   
    var sectionTypes: [ZLEditIssueSectionType] {
        _sectionType
    }
    
    var refreshEvent: Observable<Void> {
        _refreshEvent.asObservable()
    }
    
    var titleObservable: Observable<String> {
        _titleEvent.asObservable()
    }
    
    var viewerCanUpdate: Bool {
        data?.repository?.issue?.viewerCanUpdate ?? false
    }
    
    func onCloseAction() {
        onBackButtonClicked(nil)
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
        
        guard let loginName = self.loginName,
              let repoName = self.repoName else {
                  return
              }
        
        view.showProgressHUD()
        
        ZLEventServiceShared()?.getIssueEditInfo(withLoginName: loginName,
                                                 repoName: repoName,
                                                 number: Int32(number),
                                                 serialNumber: NSString.generateSerialNumber())
        { [weak self] result in
            
            guard let self = self else { return }
            
            self.view.dismissProgressHUD()
            
            if result.result {
                guard let data = result.data as? IssueEditInfoQuery.Data else {
                    return
                }
                self.data = data
                self.generateSubViewModel()
                let title = data.repository?.issue?.title ?? ""
                self._titleEvent.accept(title)
                self.reloadView()
            } else {
                guard let errorModel = result.data as? ZLGithubRequestErrorModel else {
                    return
                }
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


