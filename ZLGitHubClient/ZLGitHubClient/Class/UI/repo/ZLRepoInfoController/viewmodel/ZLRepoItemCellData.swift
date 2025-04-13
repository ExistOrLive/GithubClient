//
//  ZLRepoItemCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/3/21.
//  Copyright © 2025 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZMMVVM


class ZLRepoItemCellData: ZMBaseTableViewCellViewModel {
    
    let cellType: ZLRepoInfoCellType
    // presenter
    let presenter: ZLRepoInfoPresenter
    
    init(cellType: ZLRepoInfoCellType, presenter: ZLRepoInfoPresenter) {
        self.cellType = cellType
        self.presenter = presenter
        super.init()
    }
    
    override var zm_cellID: any ZMBaseCellUniqueIDProtocol {
        cellType
    }
    
  
    override var zm_cellReuseIdentifier: String {
        return "ZLCommonTableViewCell"
    }
    
    override dynamic var zm_cellHeight: CGFloat {
        50
    }
    
    
    override func zm_onCellSingleTap() {
        switch cellType {
        case .commit:
            onCommitClicked()
        case .branch:
            onBranchClicked()
        case .language:
            onLanguageClicked()
        case .code:
            onCodeClicked()
        case .action:
            onActionClicked()
        case .pullRequest:
            onPrClicked()
        case .discusstion:
            onDiscussionClicked()
        default:
            break
        }
    }
    
}

extension ZLRepoItemCellData: ZLCommonTableViewCellDataSourceAndDelegate {

    var canClick: Bool {
        true
    }

    var title: String {
        switch cellType {
        case .commit:
            return ZLLocalizedString(string: "commit", comment: "提交")
        case .branch:
            return ZLLocalizedString(string: "branch", comment: "分支")
        case .language:
            return ZLLocalizedString(string: "Language", comment: "语言")
        case .code:
            return ZLLocalizedString(string: "code", comment: "代码")
        case .action:
            return ZLLocalizedString(string: "action", comment: "action")
        case .pullRequest:
            return ZLLocalizedString(string: "pull request", comment: "合并请求")
        case .discusstion:
            return ZLLocalizedString(string: "Discussions", comment: "讨论")
        case .release:
            return ZLLocalizedString(string: "Releases", comment: "发行版")
        default:
            return ""
        }
    }

    var info: String {
        switch cellType {
        case .branch:
            return presenter.currentBranch ?? ""
        case .language:
            return presenter.repoModel?.language ?? ""
        case .pullRequest:
            let count = presenter.repoModel?.open_pullRequests_count ?? 0
            if count > 0 {
                return "\(count)"
            } else {
                return ""
            }
        case .release:
            let count = presenter.repoModel?.releases_count ?? 0
            if count > 0 {
                return "\(count)"
            } else {
                return ""
            }
        case .code:
            let diskUsage = presenter.repoModel?.diskUsage ?? 0
            if diskUsage > 0 {
                if diskUsage > 1000000 {
                    return "\(diskUsage / 1000000) GB"
                } else if diskUsage > 1000 {
                    return "\(diskUsage / 1000) MB"
                } else {
                    return "\(diskUsage) KB"
                }
            } else {
                return  ""
            }
        case .discusstion:
            let count = presenter.repoModel?.discussions_count ?? 0
            if count > 0 {
                return "\(count)"
            } else {
                return  ""
            }
        default:
            return ""
        }
    }
    
    var showSeparateLine: Bool {
        true
    }

}


extension ZLRepoItemCellData {
    func onCommitClicked() {
        let controller = ZLRepoCommitController()
        controller.repoFullName = presenter.repoFullName
        controller.branch = presenter.currentBranch
        zm_viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func onBranchClicked() {
    
        ZLRepoBranchesView.showRepoBranchedView(repoFullName: presenter.repoFullName,
                                                currentBranch: presenter.currentBranch ?? "" ) { [weak self] (branch: String) in
            guard let self = self else { return }
            self.presenter.changeBranch(newBranch: branch)
        }
    }
    
    func onLanguageClicked() {
        
        guard let language = presenter.repoModel?.language,
              !language.isEmpty else {
                        return
                    }
        ZLRepoLanguagesPercentView.showRepoLanguagesPercentView(fullName: presenter.repoFullName)
    }
    
    func onCodeClicked() {
        let controller = ZLRepoContentController()
        controller.branch = presenter.currentBranch
        controller.repoFullName = presenter.repoFullName
        controller.path = ""
        zm_viewController?.navigationController?.pushViewController(controller, animated: true)
    }

    
    func onActionClicked() {
        let workflowVC = ZLRepoWorkflowsController()
        workflowVC.repoFullName = presenter.repoFullName
        zm_viewController?.navigationController?.pushViewController(workflowVC, animated: true)
    }
    
    func onPrClicked() {
        let controller = ZLRepoPullRequestController()
        controller.repoFullName = presenter.repoFullName
        zm_viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func onDiscussionClicked() {
        let controller = ZLRepoDiscussionController()
        controller.login = presenter.repoModel?.owner?.loginName
        controller.repoName = presenter.repoModel?.name
        zm_viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
