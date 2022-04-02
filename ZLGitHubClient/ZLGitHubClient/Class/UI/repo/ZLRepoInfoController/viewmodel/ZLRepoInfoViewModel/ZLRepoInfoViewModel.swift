//
//  ZLRepoInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

enum ZLRepoInfoItemType: Int {
    case file                   // 仓库文件
    case pullRequest            // pullrequest
    case branch                 // 分支
}

class ZLRepoInfoViewModel: ZLBaseViewModel {

    // view
    private var repoInfoView: ZLRepoInfoView!

    // model
    private var repoInfoModel: ZLGithubRepositoryModel?

    private var currentBranch: String?

    // subViewModel
    private var repoHeaderInfoViewModel: ZLRepoHeaderInfoViewModel?

    deinit {
        NotificationCenter.default.removeObserver(self, name: ZLLanguageTypeChange_Notificaiton, object: nil)
        NotificationCenter.default.removeObserver(self, name: ZLUserInterfaceStyleChange_Notification, object: nil)
    }

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {

        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLLanguageTypeChange_Notificaiton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLUserInterfaceStyleChange_Notification, object: nil)

        guard let view = targetView as? ZLRepoInfoView else {
            ZLLog_Warn("targetView is not ZLRepoInfoView")
            return
        }
        repoInfoView = view

        guard let model = targetModel as? ZLGithubRepositoryModel else {
            ZLLog_Warn("targetModel is not ZLGithubRepositoryModel,so return")
            return
        }
        repoInfoModel = model

        if let vc = self.viewController {
            vc.zlNavigationBar.backButton.isHidden = false
            let button = UIButton.init(type: .custom)
            button.setAttributedTitle(NSAttributedString(string: ZLIconFont.More.rawValue,
                                                         attributes: [.font: UIFont.zlIconFont(withSize: 30),
                                                                      .foregroundColor: UIColor.label(withName: "ICON_Common")]),
                                      for: .normal)
            button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
            button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)

            vc.zlNavigationBar.rightButton = button
        }

        self.setViewDataForRepoInfoView()
    }
}

extension ZLRepoInfoViewModel {
    func setViewDataForRepoInfoView() {

        let repoHeaderInfoViewModel = ZLRepoHeaderInfoViewModel()
        self.addSubViewModel(repoHeaderInfoViewModel)
        self.repoHeaderInfoViewModel = repoHeaderInfoViewModel

        // 从服务器查询
        let tmpRepoInfo = ZLServiceManager.sharedInstance.repoServiceModel?.getRepoInfo(withFullName: repoInfoModel?.full_name ?? "",
                                                                      serialNumber: NSString.generateSerialNumber()) {[weak self] (resultModel) in
            if resultModel.result == true, let repoInfoModel = resultModel.data as? ZLGithubRepositoryModel {

                self?.viewController?.title = repoInfoModel.name ?? ZLLocalizedString(string: "repository", comment: "")
                self?.repoInfoModel = repoInfoModel
                self?.repoHeaderInfoViewModel?.update(repoInfoModel)
                self?.repoInfoView.reloadData()

            } else if resultModel.result == false, let errorModel = resultModel.data as? ZLGithubRequestErrorModel {

                ZLToastView.showMessage("get repo info failed [\(errorModel.statusCode)](\(errorModel.message)")

            } else {

                ZLToastView.showMessage("invalid repo info format")

            }
        }

        if let info = tmpRepoInfo {
            repoInfoModel = info
        }

        self.viewController?.title = self.repoInfoModel?.name ?? ZLLocalizedString(string: "repository", comment: "")

        repoHeaderInfoViewModel.bindModel(repoInfoModel, andView: repoInfoView.headerView)

        repoInfoView.fillWithData(delegate: self)

    }
}

extension ZLRepoInfoViewModel {
    @objc func onNotificationArrived(notification: Notification) {
        switch notification.name {
        case ZLLanguageTypeChange_Notificaiton:do {
            self.repoInfoView?.justUpdate()
        }
        case ZLUserInterfaceStyleChange_Notification:do {
            // self.repoInfoView?.readMeView.reRender()
        }
        default:
            break
        }
    }

    @objc func onMoreButtonClick(button: UIButton) {

        guard let title = repoInfoModel?.full_name,
              let url = URL(string: repoInfoModel?.html_url ?? "" ),
              let sourceViewController = viewController else {
                  return
              }

        button.showShareMenu(title: url.absoluteString, url: url, sourceViewController: sourceViewController)
    }
}

extension ZLRepoInfoViewModel: ZLRepoInfoViewDelegate {
    var fullName: String? {
        repoInfoModel?.full_name
    }

    var branch: String? {
        if currentBranch != nil {
            return currentBranch
        } else {
            return repoInfoModel?.default_branch
        }
    }

    var language: String? {
        repoInfoModel?.language
    }

     func onZLRepoItemInfoViewEvent(type: ZLRepoItemType) {

        guard let fullName = self.repoInfoModel?.full_name else {
            return
        }

        switch type {
        case .action : do {
            let workflowVC = ZLRepoWorkflowsController.init()
            workflowVC.repoFullName = fullName
            self.viewController?.navigationController?.pushViewController(workflowVC, animated: true)
            }
        case .branch :do {

            guard let defaultBranch = repoInfoModel?.default_branch else {
                return
            }

            ZLRepoBranchesView.showRepoBranchedView(repoFullName: fullName,
                                                    currentBranch: self.currentBranch ?? defaultBranch ) {(branch: String) in
                self.currentBranch = branch
                self.repoInfoView.reloadData()
                self.repoInfoView.readMeView.startLoad(fullName: fullName, branch: branch)
            }
        }
        case .pullRequest : do {
            let controller = ZLRepoPullRequestController.init()
            controller.repoFullName = fullName
            self.viewController?.navigationController?.pushViewController(controller, animated: true)
            }
        case .code : do {
            let controller = ZLRepoContentController()
            controller.branch = self.currentBranch ?? self.repoInfoModel?.default_branch
            controller.repoFullName = fullName
            controller.path = ""
            self.viewController?.navigationController?.pushViewController(controller, animated: true)
            }
        case .commit : do {
            let controller = ZLRepoCommitController.init()
            controller.repoFullName = fullName
            controller.branch = self.currentBranch ?? self.repoInfoModel?.default_branch
            self.viewController?.navigationController?.pushViewController(controller, animated: true)
            }
        case .language : do {
            guard let language = self.repoInfoModel?.language,
                  !language.isEmpty else {
                return
            }
            ZLRepoLanguagesPercentView.showRepoLanguagesPercentView(fullName: fullName)
            }
        }
    }

    func onLinkClicked(url: URL?) {
        if let realurl = url {
            ZLUIRouter.openURL(url: realurl)
        }
    }
}
