//
//  ZLEditProfileController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/26.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZMMVVM
import IQKeyboardManager
import ZLGitRemoteService


class ZLEditProfileController: ZMViewController {

    lazy var userInfoModel: ZLGithubUserModel? = {
        ZLViewerServiceShared()?.currentUserModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewDataForEditProfileView()
    }
    
    override func setupUI() {
        super.setupUI()
        self.title = ZLLocalizedString(string: "EditProfile", comment: "编辑主页")
        self.contentView.addSubview(editProfileView)
        editProfileView.snp.makeConstraints({ (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.contentView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.contentView.safeAreaLayoutGuide.snp.right)
        })
        zmNavigationBar.addRightView(saveButton)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared().isEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared().isEnabled = false
    }

    // MARK: Lazy View
    lazy var editProfileView: ZLEditProfileContentView = {
       let view = ZLEditProfileContentView()
        return view
    }()
    
    lazy var saveButton: UIButton = {
        let button = ZMButton()
        button.titleLabel?.font = UIFont.zlRegularFont(withSize: 14)
        button.setTitle(ZLLocalizedString(string: "Save", comment: "保存"), for: .normal)
        button.addTarget(self, action: #selector(onSaveButtonClicked), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 70, height: 30))
        }
        return button
    }()
    
    func setViewDataForEditProfileView() {
        self.editProfileView.bioTextView.text = userInfoModel?.bio
        self.editProfileView.companyTextField.text = userInfoModel?.company
        self.editProfileView.addressTextField.text = userInfoModel?.location
        self.editProfileView.blogTextField.text = userInfoModel?.blog
    }

}

// MARK: - Action 
extension ZLEditProfileController {
    
    @objc func onSaveButtonClicked(_ sender: Any) {
        
        self.editProfileView.endEditing(true)
        
        ZLProgressHUD.show()
        
        let bio = self.editProfileView.bioTextView.text
        let company = self.editProfileView.companyTextField.text
        let location = self.editProfileView.addressTextField.text
        let blog = self.editProfileView.blogTextField.text
        
        ZLViewerServiceShared()?.updateUserProfile(blog: blog,
                                                   location: location,
                                                   bio: bio,
                                                   company: company,
                                                   serialNumber: NSString.generateSerialNumber())
        { [weak self] (operationResultModel) in
    
            ZLProgressHUD.dismiss()
            
            guard let self else { return }
            
            if operationResultModel.result{
                ZLLog_Info("update public profile success")
                self.navigationController?.popViewController(animated: true)
                ZLToastView.showMessage(ZLLocalizedString(string: "Save_Success", comment: ""))
            } else {
                ZLLog_Info("update public profile failed")
                ZLToastView.showMessage(ZLLocalizedString(string: "Save_Fail", comment: ""))
            }
        }

    }
}
