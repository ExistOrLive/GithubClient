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

class ZLEditIssueController: ZLBaseViewController {
    
    // Entry Params
    var loginName: String?
    var repoName: String?
    var number: Int = 0
    
    private var data: IssueEditInfoQuery.Data?
    
    private var _sectionType = [ZLEditIssueSectionType]()
    private var _refreshEvent = PublishRelay<Void>()
    private var _titleEvent = BehaviorRelay<String>(value: ZLLocalizedString(string: "Issue", comment: ""))

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        sendRequest()
    }
    
    lazy var editIssueView: ZLEditIssueView = {
        ZLEditIssueView()
    }()

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
                addSubViewModel(viewModel)
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
            addSubViewModel(viewModel)
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
                    addSubViewModel(viewModel)
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
            addSubViewModel(viewModel)
            _sectionType.append(.milestone([viewModel]))
        } else {
            _sectionType.append(.milestone([ZLIssueNoneCellData(info: ZLLocalizedString(string: "No milestone", comment: ""))]))
        }
    }
    
    func reloadView() {
        // 刷新
        _refreshEvent.accept(())
    }
}

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
    
    func onCloseButtonClicked() {
        onBackButtonClicked(nil)
    }
}

// MARK: Request
extension ZLEditIssueController {
    
    func sendRequest() {
        
        guard let loginName = self.loginName,
              let repoName = self.repoName else {
                  return
              }
        
        view.showProgressHUD()
        
        ZLServiceManager.sharedInstance.eventServiceModel?.getIssueEditInfo(withLoginName: loginName,
                                                                            repoName: repoName,
                                                                            number: Int32(number),
                                                                            serialNumber: NSString.generateSerialNumber())
        { [weak self] result in
            
            UIView.dismissProgressHUD()
            
            if result.result {
                guard let data = result.data as? IssueEditInfoQuery.Data else {
                    return
                }
                self?.data = data
                self?.generateSubViewModel()
                let title = data.repository?.issue?.title ?? ""
                self?._titleEvent.accept(title)
                self?.reloadView()
            } else {
                guard let errorModel = result.data as? ZLGithubRequestErrorModel else {
                    return
                }
                ZLLog_Info(errorModel.message)
            }
        }
    }
}


