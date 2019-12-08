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
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        ZLUserServiceModel.shared().unRegisterObserver(self, name: ZLUpdateUserPublicProfileInfoResult_Notification)
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if !(targetView is ZLEditProfileView)
        {
            ZLLog_Warn("targetView is not ZLEditProfileView,so return")
        }
        
        self.editProfileView = targetView as? ZLEditProfileView
        
        if targetModel == nil || !(targetModel is ZLGithubUserModel)
        {
             ZLLog_Warn("targetModel is not ZLGithubUserModel,so return")
        }
        
        self.setViewDataForEditProfileView(model: targetModel as! ZLGithubUserModel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        ZLUserServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLUpdateUserPublicProfileInfoResult_Notification)
    }
    
    
    @IBAction func onBackButtonClicked(_ sender: Any) {

        self.viewController?.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSaveButtonClicked(_ sender: Any) {
        
        self.editProfileView?.contentView?.resignAllFirstResponder()
        
        let bio = self.editProfileView?.contentView?.personalDescTextView.text
        let company = self.editProfileView?.contentView?.companyTextField.text
        let location = self.editProfileView?.contentView?.addressTextField.text
        let email = self.editProfileView?.contentView?.emailTextField.text
        let blog = self.editProfileView?.contentView?.blogTextField.text
        
        ZLUserServiceModel.shared().updateUserPublicProfileWithemail(email, blog: blog, company: company, location: location, bio: bio, serialNumber: "da")
        
        self.editProfileView?.indicatorView.isHidden = false
        self.editProfileView?.activityIndicator.startAnimating()
        
        
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

// MARK : 监听键盘弹出
extension ZLEditProfileViewModel{
    
    @objc func keyBoardWillShow(notification: Notification)
    {
        guard let userInfo = notification.userInfo else {return}
        let value = userInfo["UIKeyboardFrameBeginUserInfoKey"] as! NSValue
        let keyboardRect = value.cgRectValue
        let keyboradHeight = keyboardRect.size.height
        
        self.editProfileView!.scrollView.contentSize.height = self.editProfileView!.scrollView.contentSize.height + keyboradHeight
    }
    
    @objc func keyBoardWillHide(notification: Notification)
    {
        guard let userInfo = notification.userInfo else {return}
        let value = userInfo["UIKeyboardFrameBeginUserInfoKey"] as! NSValue
        let keyboardRect = value.cgRectValue
        let keyboradHeight = keyboardRect.size.height
        
        self.editProfileView!.scrollView.contentSize.height = self.editProfileView!.scrollView.contentSize.height - keyboradHeight
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
            self.editProfileView?.indicatorView.isHidden = true
            self.editProfileView?.activityIndicator.stopAnimating()
            
            let operationResultModel : ZLOperationResultModel = notification.params as! ZLOperationResultModel
            
            if operationResultModel.result == true
            {
                ZLLog_Info("update public profile success")
                self.viewController?.navigationController?.popViewController(animated: true)
            }
            else
            {
                ZLLog_Info("update public profile failed")
            }
        
            }
        default:
            break;
        }
        
        
    }
}
