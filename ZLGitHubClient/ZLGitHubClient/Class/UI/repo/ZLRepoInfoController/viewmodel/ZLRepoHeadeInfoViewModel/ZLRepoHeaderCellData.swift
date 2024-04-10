//
//  ZLRepoHeaderCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/6/4.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import ZLUIUtilities
import RxSwift
import ZLGitRemoteService
import ZLBaseUI

class ZLRepoHeaderCellData: ZLTableViewBaseCellData {
    
    let disposeBag =  DisposeBag()
    
    // model
    var repoInfoModel: ZLGithubRepositoryModel
    
    // presenter
    let presenter: ZLRepoInfoPresenter?
    
    // ViewUpdatable
    weak var viewUptable: ZLViewUpdatable?
    
    init(repoInfoModel: ZLGithubRepositoryModel, presenter: ZLRepoInfoPresenter?) {
        self.repoInfoModel = repoInfoModel
        self.presenter = presenter
        super.init()
        bindData()
        self.cellReuseIdentifier = "ZLRepoInfoHeaderCell"
    }
    
    func bindData() {
        
        presenter?.viewerIsStarObservable.share().subscribe(onNext: { [weak self] isStar in
            self?.viewUptable?.justUpdateView()
        }).disposed(by: disposeBag)
        
        presenter?.viewerIsWatchObservable.share().subscribe(onNext: { [weak self] isWatch in
            self?.viewUptable?.justUpdateView()
        }).disposed(by: disposeBag)
    }
}


// MARK: - ZLViewUpdatableDataModel
extension ZLRepoHeaderCellData: ZLViewUpdatableDataModel {
    func setViewUpdatable(_ view: ZLViewUpdatable) {
        self.viewUptable = view
    }
}

// MARK: - ZLRepoInfoHeaderCellDataSourceAndDelegate
extension ZLRepoHeaderCellData: ZLRepoInfoHeaderCellDataSourceAndDelegate {
    
    var ownerLogin: String {
        repoInfoModel.owner?.loginName ?? ""
    }
    
    var avatarUrl: String {
        repoInfoModel.owner?.avatar_url ?? ""
    }
    var repoName: String {
        repoInfoModel.full_name ?? ""
    }
    var sourceRepoName: String? {
        repoInfoModel.sourceRepoFullName
    }
    
    var updatedTime: String {
        guard let date: NSDate = self.repoInfoModel.updated_at as NSDate? else {
            return ""
        }
        return date.dateLocalStrSinceCurrentTime()
    }
    
    var desc: String {
        repoInfoModel.desc_Repo ?? ""
    }
    
    var issueNum: Int {
        repoInfoModel.open_issues_count
    }

    var starsNum: Int {
        repoInfoModel.stargazers_count
    }

    var forksNum: Int {
        repoInfoModel.forks_count
    }

    var watchersNum: Int {
        repoInfoModel.subscribers_count
    }
    
    var watched: Bool {
        presenter?.viewerIsWatch ?? false
    }
    var starred: Bool {
        presenter?.viewerIsStar ?? false
    }
    
    func onAvatarButtonClicked() {
        if let loginName = repoInfoModel.owner?.loginName {
            if let userInfoVC = ZLUIRouter.getUserInfoViewController(loginName: loginName) {
                self.viewController?.navigationController?.pushViewController(userInfoVC, animated: true)
            }
        }
    }
    
    func onStarButtonClicked() {
        ZLProgressHUD.show(view: viewController?.view, animated: true)
        presenter?.starRepo().subscribe(onNext: { [weak self] messageModel in
            guard let self = self else { return }
            ZLProgressHUD.dismiss(view: self.viewController?.view, animated: true)
            if messageModel.result == false,
               !messageModel.error.isEmpty{
                ZLToastView.showMessage(messageModel.error, sourceView: self.viewController?.view)
            }
        }).disposed(by: disposeBag)
    }
    
    func onForkButtonClicked() {
        ZLProgressHUD.show(view: viewController?.view, animated: true)
        presenter?.forkRepo().subscribe(onNext: { [weak self] messageModel in
            guard let self = self else { return }
            ZLProgressHUD.dismiss(view: self.viewController?.view, animated: true)
            if messageModel.result == true {
                ZLToastView.showMessage(ZLLocalizedString(string: "Fork Success", comment: ""), sourceView: self.viewController?.view)
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Fork Fail", comment: ""), sourceView: self.viewController?.view)
            }
        }).disposed(by: disposeBag)
    }
    
    func onWatchButtonClicked() {
        ZLProgressHUD.show(view: viewController?.view, animated: true)
        presenter?.watchRepo().subscribe(onNext: { [weak self] messageModel in
            guard let self = self else { return }
            ZLProgressHUD.dismiss(view: self.viewController?.view, animated: true)
            if messageModel.result == false,
               !messageModel.error.isEmpty{
                ZLToastView.showMessage(messageModel.error, sourceView: self.viewController?.view)
            } 
        }).disposed(by: disposeBag)
    }

    func onIssuesNumButtonClicked() {
        let vc: ZLRepoIssuesController = ZLRepoIssuesController()
        vc.repoFullName = repoInfoModel.full_name
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onStarsNumButtonClicked() {
        let vc: ZLRepoStargazersController = ZLRepoStargazersController.init()
        vc.repoFullName = repoInfoModel.full_name
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onForksNumButtonClicked() {
        let vc: ZLRepoForkedReposController = ZLRepoForkedReposController()
        vc.repoFullName = repoInfoModel.full_name
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onWatchersNumButtonClicked() {
        let vc: ZLRepoWatchedUsersController = ZLRepoWatchedUsersController.init()
        vc.repoFullName = repoInfoModel.full_name
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onSourceRepoClicked() {
        if let repoFullName = repoInfoModel.sourceRepoFullName,
           let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: repoFullName) {
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
