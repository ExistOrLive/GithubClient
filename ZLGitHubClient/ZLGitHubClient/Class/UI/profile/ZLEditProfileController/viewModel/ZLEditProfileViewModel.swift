//
//  ZLEditProfileViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/26.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import SVProgressHUD

class ZLEditProfileViewModel: ZLBaseViewModel {
    
    // view
    private weak var editProfileView : ZLEditProfileView?
    
    // model
    private var userInfoModel: ZLGithubUserModel?
    
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let targetView = targetView as? ZLEditProfileView else {
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
        
        SVProgressHUD.show()
        
        let bio = self.editProfileView?.contentView?.personalDescTextView.text
        let company = self.editProfileView?.contentView?.companyTextField.text
        let location = self.editProfileView?.contentView?.addressTextField.text
        let blog = self.editProfileView?.contentView?.blogTextField.text
        
        ZLServiceManager.sharedInstance.viewerServiceModel?.updateUserProfile(blog: blog,
                                                                              location: location,
                                                                              bio: bio,
                                                                              company: company,
                                                                              serialNumber: NSString.generateSerialNumber())
        { (operationResultModel) in
            
            SVProgressHUD.dismiss()
            
            if operationResultModel.result == true
            {
                ZLLog_Info("update public profile success")
                self.viewController?.navigationController?.popViewController(animated: true)
                ZLToastView.showMessage("保存成功")
            }
            else
            {
                ZLLog_Info("update public profile failed")
                ZLToastView.showMessage("保存失败")
            }
        }
        
    }
        
    func setUpSaveButton()
    {        
        let button = ZLBaseButton.init(type: .custom)
        button.titleLabel?.font = UIFont.zlRegularFont(withSize: 14)
        button.setTitle(ZLLocalizedString(string: "Save",comment: "保存"), for: .normal)
        
        button.frame = CGRect.init(x: 0, y: 0, width: 70, height: 30)
        button.addTarget(self, action: #selector(onSaveButtonClicked), for: .touchUpInside)
        
        let vc = self.viewController
        vc?.zlNavigationBar.rightButton = button
    }
    
}

extension ZLEditProfileViewModel{

    func setViewDataForEditProfileView(){
        self.editProfileView?.contentView?.personalDescTextView.text = userInfoModel?.bio
        self.editProfileView?.contentView?.companyTextField.text = userInfoModel?.company
        self.editProfileView?.contentView?.addressTextField.text = userInfoModel?.location
        self.editProfileView?.contentView?.blogTextField.text = userInfoModel?.blog
    }
    
}


