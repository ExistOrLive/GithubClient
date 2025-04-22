//
//  ZLRepoHeaderCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/6/4.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import ZLUIUtilities
import ZLGitRemoteService
import ZMMVVM

class ZLRepoHeaderCellData: ZMBaseTableViewCellViewModel {
        
    override var zm_cellID: any ZMBaseCellUniqueIDProtocol {
        return ZLRepoInfoCellType.header
    }
    
    // model
    var repoInfoModel: ZLGithubRepositoryModelV2? {
        presenter.repoModel
    }
    
    // presenter
    let presenter: ZLRepoInfoPresenter
    

    
    init(presenter: ZLRepoInfoPresenter) {
        self.presenter = presenter
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLRepoInfoHeaderCell"
    }
}


// MARK: - ZLRepoInfoHeaderCellDataSourceAndDelegate
extension ZLRepoHeaderCellData: ZLRepoInfoHeaderCellDataSourceAndDelegate {
    
    var ownerLogin: String {
        repoInfoModel?.owner?.loginName ?? ""
    }
    
    var avatarUrl: String {
        repoInfoModel?.owner?.avatar_url ?? ""
    }
    var repoName: String {
        repoInfoModel?.full_name ?? ""
    }
    var sourceRepoName: String? {
        repoInfoModel?.sourceRepoFullName
    }
    
    var updatedTime: String {
        guard let date: NSDate = self.repoInfoModel?.updated_at as NSDate? else {
            return ""
        }
        return date.dateLocalStrSinceCurrentTime()
    }
    
    var desc: String {
        repoInfoModel?.desc_Repo ?? ""
    }
    
    var issueNum: Int {
        repoInfoModel?.open_issues_count ?? 0
    }

    var starsNum: Int {
        repoInfoModel?.stargazers_count ?? 0
    }

    var forksNum: Int {
        repoInfoModel?.forks_count ?? 0
    }

    var watchersNum: Int {
        repoInfoModel?.subscribers_count ?? 0
    }
    
    var watched: Bool? {
        presenter.viewerIsWatch
    }
    var starred: Bool? {
        presenter.viewerIsStar
    }
    
    func onAvatarButtonClicked() {
        if let loginName = repoInfoModel?.owner?.loginName {
            if let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName: loginName) {
                zm_viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
            }
        }
    }
    
    func onStarButtonClicked() {
        let hud = ZLProgressHUD.show(view: zm_viewController?.view, animated: false)
        presenter.starRepo { [weak self] result, msg in
            ZLProgressHUD.dismiss(hud: hud, animated: false)
            guard let self else { return }
            if !result, !msg.isEmpty {
                ZLToastView.showMessage(msg,
                                        sourceView: self.zm_viewController?.view)
            }
        }
    }
    
    func onForkButtonClicked() {
        let hud = ZLProgressHUD.show(view: zm_viewController?.view, animated: false)
        presenter.forkRepo { [weak self] result, msg in
            ZLProgressHUD.dismiss(hud: hud, animated: false)
            guard let self = self else { return }
            if result {
                ZLToastView.showMessage(ZLLocalizedString(string: "Fork Success", comment: ""), sourceView: self.zm_viewController?.view)
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Fork Fail", comment: ""), sourceView: self.zm_viewController?.view)
            }
        }
    }
    
    func onWatchButtonClicked() {
        let hud =  ZLProgressHUD.show(view: zm_viewController?.view, animated: false)
        presenter.watchRepo { [weak self] result, msg in
            ZLProgressHUD.dismiss(hud: hud, animated: false)
            guard let self = self else { return }
            if !result, !msg.isEmpty {
                ZLToastView.showMessage(msg,
                                        sourceView: self.zm_viewController?.view)
            }
        }
    }

    func onIssuesNumButtonClicked() {
        let vc: ZLRepoIssuesController = ZLRepoIssuesController()
        vc.repoFullName = presenter.repoFullName
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onStarsNumButtonClicked() {
        let vc: ZLRepoStargazersController = ZLRepoStargazersController.init()
        vc.repoFullName = presenter.repoFullName
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onForksNumButtonClicked() {
        let vc: ZLRepoForkedReposController = ZLRepoForkedReposController()
        vc.repoFullName = presenter.repoFullName
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onWatchersNumButtonClicked() {
        let vc: ZLRepoWatchedUsersController = ZLRepoWatchedUsersController.init()
        vc.repoFullName = presenter.repoFullName
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onSourceRepoClicked() {
        if let repoFullName = presenter.repoModel?.sourceRepoFullName,
           let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
