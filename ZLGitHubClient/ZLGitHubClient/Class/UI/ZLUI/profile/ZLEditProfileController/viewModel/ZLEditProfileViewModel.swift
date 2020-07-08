//
//  ZLEditProfileViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/26.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLEditProfileViewModel: ZLBaseViewModel {
    
    // view
    private weak var editProfileView : ZLEditProfileView?
    
    // model
    private var userInfoModel: ZLGithubUserModel?
    
    
    deinit {
        self.removeObservers()
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if !(targetView is ZLEditProfileView)
        {
            ZLLog_Warn("targetView is not ZLEditProfileView,so return")
        }
        
        self.editProfileView = targetView as? ZLEditProfileView
        self.setUpSaveButton()
        
        if targetModel == nil || !(targetModel is ZLGithubUserModel)
        {
             ZLLog_Warn("targetModel is not ZLGithubUserModel,so return")
        }
        
        self.setViewDataForEditProfileView(model: targetModel as! ZLGithubUserModel)
        
        self.addObservers()
    }
    
    
    @objc func onSaveButtonClicked(_ sender: Any) {
        
        self.editProfileView?.endEditing(true)
        
        let bio = self.editProfileView?.contentView?.personalDescTextView.text
        let company = self.editProfileView?.contentView?.companyTextField.text
        let location = self.editProfileView?.contentView?.addressTextField.text
        let email = self.editProfileView?.contentView?.emailTextField.text
        let blog = self.editProfileView?.contentView?.blogTextField.text
        
        ZLUserServiceModel.shared().updateUserPublicProfileWithemail(email, blog: blog, company: company, location: location, bio: bio, serialNumber: "da")
        
        SVProgressHUD.show();
    }
    
    
    func addObservers()
    {
        ZLUserServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLUpdateUserPublicProfileInfoResult_Notification)
    }
    
    func removeObservers()
    {
        ZLUserServiceModel.shared().unRegisterObserver(self, name: ZLUpdateUserPublicProfileInfoResult_Notification)
    }
    
    func setUpSaveButton()
    {
        let attributedTitle = NSAttributedString.init(string: ZLLocalizedString(string: "Save",comment: "保存"), attributes: [NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 14)!,NSAttributedString.Key.foregroundColor:UIColor.black])
        
        let button = UIButton.init(type: .custom)
        button.backgroundColor = ZLRGBValue_H(colorValue: 0xF0F4F6)
        button.layer.borderColor = ZLRGBValue_H(colorValue: 0xC4C8CC).cgColor
        button.layer.borderWidth = 0.3
        button.layer.cornerRadius = 5.0
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 70, height: 30)
        button.addTarget(self, action: #selector(onSaveButtonClicked), for: .touchUpInside)
        
        let vc = self.viewController as? ZLBaseViewController
        vc?.zlNavigationBar.rightButton = button
    }
    
}

extension ZLEditProfileViewModel{

    func setViewDataForEditProfileView(model:ZLGithubUserModel)
    {
        self.userInfoModel = model
        
        self.editProfileView?.contentView?.personalDescTextView.text = model.bio
        self.editProfileView?.contentView?.companyTextField.text = model.company
        self.editProfileView?.contentView?.addressTextField.text = model.location
        self.editProfileView?.contentView?.emailTextField.text = model.email
        self.editProfileView?.contentView?.blogTextField.text = model.blog
    }
    
}


extension ZLEditProfileViewModel
{
    @objc func onNotificationArrived(notification: Notification)
    {
        switch(notification.name)
        {
        case ZLUpdateUserPublicProfileInfoResult_Notification:do
        {
            SVProgressHUD.dismiss();
            
            let operationResultModel : ZLOperationResultModel = notification.params as! ZLOperationResultModel
            
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
        default:
            break;
        }
        
        
    }
}
