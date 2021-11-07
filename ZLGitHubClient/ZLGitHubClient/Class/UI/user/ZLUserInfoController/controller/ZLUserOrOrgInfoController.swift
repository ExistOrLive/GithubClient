//
//  ZLUserOrOrgInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/4/10.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLUserOrOrgInfoController: ZLBaseViewController {

    @objc var loginName: String?
    
    // view
    var userOrOrgInfoView: ZLUserOrOrgInfoView = {
        ZLUserOrOrgInfoView()
    }()
    
    
    // subviewModel
    var userInfoViewModel: ZLUserInfoViewModel?
    var orgInfoViewModel: ZLOrgInfoViewModel?
    
    // model
    var model: ZLBaseObject?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = loginName
        if loginName?.isEmpty ?? true {
            ZLToastView.showMessage(ZLLocalizedString(string: "loginName is nil", comment: ""))
            return
        }
        
        self.contentView.addSubview(userOrOrgInfoView)
        userOrOrgInfoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        userOrOrgInfoView.fillWithData(self)
        
        self.sendRequest()
    }
    
    func sendRequest() {
        
        let userOrOrgInfo =  ZLServiceManager.sharedInstance.userServiceModel?.getUserInfo(withLoginName: loginName ?? "",
                                                                                           serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel) in
            
            SVProgressHUD.dismiss()
            
            if resultModel.result == true {
                if let userModel = resultModel.data as? ZLGithubUserModel {
                    
                    self?.model = userModel
                    self?.userOrOrgInfoView.reloadData()
                    
                    if self?.userInfoViewModel == nil {
                        
                        let userInfoViewModel = ZLUserInfoViewModel()
                        self?.addSubViewModel(userInfoViewModel)
                        userInfoViewModel.bindModel(userModel, andView: self?.userOrOrgInfoView.userInfoView ?? UIView())
                        self?.userInfoViewModel = userInfoViewModel
                        
                    } else {
                        self?.userInfoViewModel?.update(userModel)
                    }
                    
                } else if let orgModel = resultModel.data as? ZLGithubOrgModel {
                    
                    self?.model = orgModel
                    self?.userOrOrgInfoView.reloadData()
                    
                    if self?.orgInfoViewModel == nil {
                        
                        let orgINfoViewModel = ZLOrgInfoViewModel()
                        self?.addSubViewModel(orgINfoViewModel)
                        orgINfoViewModel.bindModel(orgModel, andView: self?.userOrOrgInfoView.orgInfoView ?? UIView())
                        self?.orgInfoViewModel = orgINfoViewModel
                        
                    } else {
                        self?.orgInfoViewModel?.update(orgModel)
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
            
            self.model = userModel
            self.userOrOrgInfoView.reloadData()
            
            let userInfoViewModel = ZLUserInfoViewModel()
            self.addSubViewModel(userInfoViewModel)
            userInfoViewModel.bindModel(userModel, andView: userOrOrgInfoView.userInfoView)
            self.userInfoViewModel = userInfoViewModel
            
            
        } else if let orgModel = userOrOrgInfo as? ZLGithubOrgModel {
            
            self.model = orgModel
            self.userOrOrgInfoView.reloadData()
            
            let orgINfoViewModel = ZLOrgInfoViewModel()
            self.addSubViewModel(orgINfoViewModel)
            orgINfoViewModel.bindModel(orgModel, andView: userOrOrgInfoView.orgInfoView)
            self.orgInfoViewModel = orgINfoViewModel
            
        } else {
            SVProgressHUD.show()
        }
        

    }
    
}

extension ZLUserOrOrgInfoController: ZLUserOrOrgInfoViewDelegate {
    var isUserView: Bool{
        return self.model is ZLGithubUserModel
    }
    
    var isOrgView: Bool{
        return self.model is ZLGithubOrgModel
    }
}
