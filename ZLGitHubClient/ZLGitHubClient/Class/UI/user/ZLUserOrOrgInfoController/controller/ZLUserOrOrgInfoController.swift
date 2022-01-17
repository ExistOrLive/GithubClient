//
//  ZLUserOrOrgInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/4/10.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLUserOrOrgInfoController: ZLBaseViewController {

    // Outer Property
    @objc var loginName: String?

    // view
    private lazy var userInfoView: ZLUserInfoView = {
        ZLUserInfoView()
    }()

    // subviewModel
    var userInfoViewModel: ZLUserInfoViewModel?
    var orgInfoViewModel: ZLOrgInfoViewModel?

    // model
    var model: ZLBaseObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let login = loginName else {
            ZLToastView.showMessage(ZLLocalizedString(string: "loginName is nil", comment: ""))
            return
        }

        title = login

        contentView.addSubview(userInfoView)
        userInfoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        setSharedButton()

        sendRequest()
    }

    func sendRequest() {

        let userOrOrgInfo =  ZLServiceManager.sharedInstance.userServiceModel?.getUserInfo(withLoginName: loginName ?? "",
                                                                                           serialNumber: NSString.generateSerialNumber()) { [weak self](resultModel) in
            SVProgressHUD.dismiss()

            guard let self = self else { return }

            if resultModel.result == true {

                if let userModel = resultModel.data as? ZLGithubUserModel {

                    if let userInfoViewModel = self.userInfoViewModel {
                        userInfoViewModel.update(userModel)
                    } else {
                        self.orgInfoViewModel?.removeFromSuperViewModel()
                        self.orgInfoViewModel = nil
                        let userInfoViewModel = ZLUserInfoViewModel()
                        self.addSubViewModel(userInfoViewModel)
                        userInfoViewModel.bindModel(userModel, andView: self.userInfoView)
                        self.userInfoViewModel = userInfoViewModel
                    }

                } else if let orgModel = resultModel.data as? ZLGithubOrgModel {

                    if let orgInfoViewModel = self.orgInfoViewModel {
                        orgInfoViewModel.update(orgModel)
                    } else {
                        self.userInfoViewModel?.removeFromSuperViewModel()
                        self.userInfoViewModel = nil
                        let orgInfoViewModel = ZLOrgInfoViewModel()
                        self.addSubViewModel(orgInfoViewModel)
                        orgInfoViewModel.bindModel(orgModel, andView: self.userInfoView)
                        self.orgInfoViewModel = orgInfoViewModel
                    }

                } else {
                    ZLToastView.showMessage("User or Org Info invalid format")
                }
            } else if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                ZLToastView.showMessage("get user info failed [\(errorModel.statusCode)](\(errorModel.message)")
            } else {
                ZLToastView.showMessage("User or Org Info invalid format")
            }
        }

        if let userModel = userOrOrgInfo as? ZLGithubUserModel {
            let userInfoViewModel = ZLUserInfoViewModel()
            addSubViewModel(userInfoViewModel)
            userInfoViewModel.bindModel(userModel, andView: userInfoView)
            self.userInfoViewModel = userInfoViewModel
        } else if let orgModel = userOrOrgInfo as? ZLGithubOrgModel {
            let orgInfoViewModel = ZLOrgInfoViewModel()
            addSubViewModel(orgInfoViewModel)
            orgInfoViewModel.bindModel(orgModel, andView: userInfoView)
            self.orgInfoViewModel = orgInfoViewModel
        } else {
            SVProgressHUD.show()
        }
    }

    func setSharedButton() {

        let button = UIButton.init(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: ZLIconFont.More.rawValue,
                                                     attributes: [.font: UIFont.zlIconFont(withSize: 30),
                                                                  .foregroundColor: UIColor.label(withName: "ICON_Common")]),
                                  for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)

        self.zlNavigationBar.rightButton = button
    }

    // action
    @objc func onMoreButtonClick(button: UIButton) {

        guard let login = loginName else { return }
        var html_url = self.userInfoViewModel?.html_url ?? ""
        if html_url.isEmpty {
            html_url = self.orgInfoViewModel?.html_url ?? ""
        }
        guard let url = URL(string: html_url) else { return }

        button.showShareMenu(title: url.absoluteString, url: url, sourceViewController: self)
    }

}
