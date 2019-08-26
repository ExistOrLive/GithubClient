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
    
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if !(targetView is ZLEditProfileView)
        {
            ZLLog_Warn("targetView is not ZLEditProfileViewDelegate,so return")
        }
        
        self.editProfileView = targetView as? ZLEditProfileView
        self.editProfileView?.delegate = self
        
        
    }

}

extension ZLEditProfileViewModel : ZLEditProfileViewDelegate
{
    func onBackButtonClicked(button: UIButton) {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
    
    func onSaveButtonClicked(button: UIButton) {
        
    }
}
