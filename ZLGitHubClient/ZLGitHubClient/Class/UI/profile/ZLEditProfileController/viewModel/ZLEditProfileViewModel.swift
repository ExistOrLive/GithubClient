//
//  ZLEditProfileViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/26.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension
import ZLGitRemoteService

class ZLEditProfileViewModel: ZLBaseViewModel {

    // view
    private weak var editProfileView: ZLEditProfileContentView?

    // model
    private var userInfoModel: ZLGithubUserModel?

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {

        guard let targetView = targetView as? ZLEditProfileContentView else {
            ZLLog_Warn("targetView is not ZLEditProfileView,so return")
            return
        }

        guard let currentUserModel = ZLServiceManager.sharedInstance.viewerServiceModel?.currentUserModel else {
            ZLToastView.showMessage("get current user info failed")
            return
        }

        self.editProfileView = targetView
        self.setUpSaveButton()

        userInfoModel = currentUserModel

        self.setViewDataForEditProfileView()
    }

    @objc func onSaveButtonClicked(_ sender: Any) {

        self.editProfileView?.endEditing(true)

        ZLProgressHUD.show()

        let bio = self.editProfileView?.bioTextView.text
        let company = self.editProfileView?.companyTextField.text
        let location = self.editProfileView?.addressTextField.text
        let blog = self.editProfileView?.blogTextField.text

        ZLServiceManager.sharedInstance.viewerServiceModel?.updateUserProfile(blog: blog,
                                                                              location: location,
                                                                              bio: bio,
                                                                              company: company,
                                                                              serialNumber: NSString.generateSerialNumber()) { (operationResultModel) in

            ZLProgressHUD.dismiss()

            if operationResultModel.result == true {
                ZLLog_Info("update public profile success")
                self.viewController?.navigationController?.popViewController(animated: true)
                ZLToastView.showMessage(ZLLocalizedString(string: "Save_Success", comment: ""))
            } else {
                ZLLog_Info("update public profile failed")
                ZLToastView.showMessage(ZLLocalizedString(string: "Save_Fail", comment: ""))
            }
        }

    }

    func setUpSaveButton() {
        let button = ZLBaseButton.init(type: .custom)
        button.titleLabel?.font = UIFont.zlRegularFont(withSize: 14)
        button.setTitle(ZLLocalizedString(string: "Save", comment: "保存"), for: .normal)

        button.frame = CGRect.init(x: 0, y: 0, width: 70, height: 30)
        button.addTarget(self, action: #selector(onSaveButtonClicked), for: .touchUpInside)

        let vc = self.viewController
        vc?.zlNavigationBar.rightButton = button
    }

}

extension ZLEditProfileViewModel {

    func setViewDataForEditProfileView() {
        self.editProfileView?.bioTextView.text = userInfoModel?.bio
        self.editProfileView?.companyTextField.text = userInfoModel?.company
        self.editProfileView?.addressTextField.text = userInfoModel?.location
        self.editProfileView?.blogTextField.text = userInfoModel?.blog
    }

}
