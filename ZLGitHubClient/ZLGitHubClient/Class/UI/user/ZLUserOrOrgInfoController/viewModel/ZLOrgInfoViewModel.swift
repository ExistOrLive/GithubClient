//
//  ZLOrgInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/12.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLOrgInfoViewModel: ZLBaseViewModel {

    // data 
    private var orgInfoModel: ZLGithubOrgModel?
    private var pinnedRepositories: [ZLGithubRepositoryBriefModel] = []

    // subViewModel
    private var subViewModelArray: [[ZLGithubItemTableViewCellData]] = []

    // viewCallBack
    private var viewCallback: (() -> Void)?
    private var readMeCallback: (() -> Void)?

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        super.bindModel(targetModel, andView: targetView)

        guard let view = targetView as? ZLUserInfoView else {
            return
        }

        guard let model = targetModel as? ZLGithubOrgModel else {
            return
        }
        orgInfoModel = model

        generateSubViewModel()

        view.fillWithData(delegateAndDataSource: self)

        getUserPinnedRepos()
    }

    override func update(_ targetModel: Any?) {
        guard let model = targetModel as? ZLGithubOrgModel else {
            return
        }
        orgInfoModel = model

        generateSubViewModel()

        viewCallback?()
        readMeCallback?()

        getUserPinnedRepos()
    }

    func generateSubViewModel() {

        guard let model = orgInfoModel else { return }

        self.subViewModelArray.removeAll()

        for subViewModel in self.subViewModels {
            subViewModel.removeFromSuperViewModel()
        }

        // headerCellData
        let headerCellData = ZLOrgInfoHeaderCellData(data: model)
        self.subViewModelArray.append([headerCellData])
        self.addSubViewModel(headerCellData)

        var itemCellDatas = [ZLGithubItemTableViewCellData]()

        // company
        if model.repositories > 0 {
             let cellData = ZLCommonTableViewCellData(canClick: true,
                                                      title: ZLLocalizedString(string: "repositories", comment: ""),
                                                      info: "\(model.repositories)",
                                                      cellHeight: 50) { [weak self] in

                 if let login = self?.orgInfoModel?.loginName,
                    let vc = ZLUIRouter.getVC(key: ZLUIRouter.UserAdditionInfoController, params: ["login": login, "type": ZLUserAdditionInfoType.repositories.rawValue]) {
                     vc.hidesBottomBarWhenPushed = true
                     self?.viewController?.navigationController?.pushViewController(vc, animated: true)
                 }

             }
            itemCellDatas.append(cellData)
        }

        // address
        if let location = model.location,
           !location.isEmpty {
            let cellData = ZLCommonTableViewCellData(canClick: false,
                                                     title: ZLLocalizedString(string: "location", comment: ""),
                                                     info: location,
                                                     cellHeight: 50)
           itemCellDatas.append(cellData)
        }

        // email
        if let email = model.email,
           !email.isEmpty {

            let cellData = ZLCommonTableViewCellData(canClick: true,
                                                     title: ZLLocalizedString(string: "email", comment: ""),
                                                     info: email,
                                                     cellHeight: 50) {

                if let url = URL(string: "mailto:\(email)"),
                   UIApplication.shared.canOpenURL(url) {

                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
           itemCellDatas.append(cellData)
        }

        // blog
        if let blog = model.blog,
           !blog.isEmpty {

            let cellData = ZLCommonTableViewCellData(canClick: true,
                                                     title: ZLLocalizedString(string: "blog", comment: ""),
                                                     info: blog,
                                                     cellHeight: 50) {

                if let url = URL.init(string: blog) {
                    ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,
                                          params: ["requestURL": url],
                                          animated: true)
                }
            }
           itemCellDatas.append(cellData)
        }

        if !itemCellDatas.isEmpty {
            self.addSubViewModels(itemCellDatas)
            self.subViewModelArray.append(itemCellDatas)
        }

        if !pinnedRepositories.isEmpty {
            let pinnedReposCellData = ZLPinnedRepositoriesTableViewCellData(repos: pinnedRepositories)
            self.addSubViewModel(pinnedReposCellData)
            self.subViewModelArray.append([pinnedReposCellData])
        }
    }

}

extension ZLOrgInfoViewModel: ZLUserInfoViewDelegateAndDataSource {

    var html_url: String? {
        orgInfoModel?.html_url
    }

    // datasource
    var loginName: String {
        orgInfoModel?.loginName ?? ""
    }

    var cellDatas: [[ZLGithubItemTableViewCellDataProtocol]] {
        subViewModelArray
    }

    // delegate
    func loadNewData() {
        getUserInfo()
    }

    func onLinkClicked(url: URL?) {
        if let realurl = url {
            ZLUIRouter.openURL(url: realurl)
        }
    }

    func setCallBack(callback: @escaping () -> Void) {
        viewCallback = callback
    }
    func setReadMeCallBack(callback: @escaping () -> Void) {
        readMeCallback = callback
    }
}

// MARK: Request
extension ZLOrgInfoViewModel {

    func getUserInfo() {

        guard let loginName = orgInfoModel?.loginName else {
            ZLToastView.showMessage("login name is nil")
            viewCallback?()
            return
        }

        ZLServiceManager.sharedInstance.userServiceModel?.getUserInfo(withLoginName: loginName,
                                                                      serialNumber: NSString.generateSerialNumber()) { [weak self] model in

            guard let self = self else { return }

            if model.result {

                if let model = model.data as? ZLGithubOrgModel {
                    self.update(model)
                }
            } else {

                if let model = model.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage("Get User Info Failed \(model.message)")
                }
            }
        }
    }

    func getUserPinnedRepos() {

        guard let loginName = orgInfoModel?.loginName else {
            return
        }

        ZLServiceManager.sharedInstance.userServiceModel?.getOrgPinnedRepositories(loginName,
                                                                                   serialNumber: NSString.generateSerialNumber()) { [weak self] model in

            guard let self = self else { return }

            if model.result {
                if let data = model.data as? [ZLGithubRepositoryBriefModel] {
                    self.pinnedRepositories = data
                    self.generateSubViewModel()
                    self.viewCallback?()
                }
            } else {
                if let model = model.data as? ZLGithubRequestErrorModel {
                    ZLLog_Info(model.message)
                }
            }
        }
    }
}
