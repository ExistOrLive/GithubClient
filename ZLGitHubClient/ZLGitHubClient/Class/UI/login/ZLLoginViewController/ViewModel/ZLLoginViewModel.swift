//
//  ZLLoginViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLGithubOAuth
import ZLGitRemoteService
import ZLUIUtilities
import ZLBaseUI

enum ZLLoginStep {
    case initialize
    case oauth
    case gettoken
    case checktoken
}

class ZLLoginViewModel: ZLBaseViewModel, ZLLoginBaseViewDelegate {

    weak var baseView: ZLLoginBaseView?

    private var oauthManager: ZLGithubOAuthManager?
    
    // 登陆操作的流水号
    private var loginSerialNumber: String?
    // 登陆步骤
    private var step: ZLLoginStep = .initialize

    deinit {
        ZLServiceManager.sharedInstance.loginServiceModel?.unRegisterObserver(self, name: ZLLoginResult_Notification)
    }

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
       
        guard let targetView = targetView as? ZLLoginBaseView else {
            return
        }

        // 注册对于登陆结果的通知
        ZLServiceManager.sharedInstance.loginServiceModel?.registerObserver(self, selector: #selector(onNotificationArrived(notificaiton:)), name: ZLLoginResult_Notification)

        baseView = targetView
        baseView?.delegate = self
        
        self.reloadView()
    }
    
    func reloadView() {
        switch step {
        case .initialize:
            self.baseView?.loginButton.isEnabled = true
            self.baseView?.accessTokenButton.isEnabled = true
            self.baseView?.loginInfoLabel.text = nil
            self.baseView?.activityIndicator.isHidden = true
            self.baseView?.activityIndicator.stopAnimating()
        case .oauth:
            self.baseView?.loginButton.isEnabled = false
            self.baseView?.accessTokenButton.isEnabled = false
            self.baseView?.loginInfoLabel.text = ZLLocalizedString(string: "ZLLoginStep_logining", comment: "登录中...")
            self.baseView?.activityIndicator.isHidden = false
            self.baseView?.activityIndicator.startAnimating()
        case .gettoken:
            self.baseView?.loginButton.isEnabled = false
            self.baseView?.accessTokenButton.isEnabled = false
            self.baseView?.loginInfoLabel.text = ZLLocalizedString(string: "ZLLoginStep_getToken", comment: "正在获取token....")
            self.baseView?.activityIndicator.isHidden = false
            self.baseView?.activityIndicator.startAnimating()
        case .checktoken:
            self.baseView?.loginButton.isEnabled = false
            self.baseView?.accessTokenButton.isEnabled = false
            self.baseView?.loginInfoLabel.text = ZLLocalizedString(string: "ZLLoginStep_checkToken", comment: "检查token是否有效...")
            self.baseView?.activityIndicator.isHidden = false
            self.baseView?.activityIndicator.startAnimating()
        }
    }
    

    func onLoginButtonClicked() {

        oauthManager = ZLGithubOAuthManager(client_id: ZLUISharedDataManager.githubClientID,
                                            client_secret: ZLUISharedDataManager.githubClientSecret,
                                            redirect_uri: ZLUISharedDataManager.githubClientCallback)
        
        oauthManager?.startOAuth(type: .code,
                                 delegate: self,
                                 vcBlock: { [weak self] vc in
            vc.modalPresentationStyle = .fullScreen
            self?.viewController?.present(vc, animated: true, completion: nil)
        },
                                 scopes:[.user,.repo,.gist,.notifications,.read_org])
    }

    func onAccessTokenButtonClicked() {

        ZLInputAccessTokenView.showInputAccessTokenViewWithResultBlock(resultBlock: {(token: String?) in
            guard let token = token else {
                ZLToastView.showMessage(ZLLocalizedString(string: "token is nil", comment: ""))
                return
            }

            let serialNumber = NSString.generateSerialNumber()
            self.loginSerialNumber = serialNumber
            
            ZLServiceManager.sharedInstance.loginServiceModel?.setAccessToken(token,
                                                                              serialNumber: serialNumber)
            self.step = .checktoken
            self.reloadView()
        })
    }

    // MARK: onNotificationArrived
    @objc func onNotificationArrived(notificaiton: Notification) {
        switch notificaiton.name {

        case ZLLoginResult_Notification: do {
            
            guard let resultModel = notificaiton.params as? ZLOperationResultModel else {
                return
            }
            
            if self.loginSerialNumber != resultModel.serialNumber {
                ZLLog_Info("loginProcess: self.loginSerialNumber[\(self.loginSerialNumber ?? "")] loginProcess.serialNumber[\(resultModel.serialNumber)] not match")
                return
            }
            
            if resultModel.result == false {
                step = .initialize
                loginSerialNumber = nil
                reloadView()
                guard let errorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    return
                }
                ZLToastView.showMessage("Login Failed: status[\(errorModel.statusCode)] \(errorModel.message)")
                
            } else if resultModel.result  {
                step = .initialize
                loginSerialNumber = nil
                reloadView()
                ZLToastView.showMessage("Login Success")
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.switch(toMainController: true)
            }
        }
        default:
            break
        }
    }
}

// MARK: ZLGithubOAuthManagerDelegate
extension ZLLoginViewModel: ZLGithubOAuthManagerDelegate {
    
    func onOAuthStatusChanged(status: ZLGithubOAuthStatus) {
        switch status {
        case .initialized:
            break
        case .authorize:
            step = .oauth
            reloadView()
        case .getToken:
            step = .gettoken
            reloadView()
            break
        case .fail:
            break
        case .success:
            break
        }
    }
    
    func onOAuthSuccess(token: String) {
        oauthManager = nil
        let serialNumber = NSString.generateSerialNumber()
        loginSerialNumber = serialNumber
        ZLServiceManager.sharedInstance.loginServiceModel?.setAccessToken(token,
                                                                          serialNumber: serialNumber)
        step = .checktoken
        reloadView()
    }
    
    func onOAuthFail(status: ZLGithubOAuthStatus, error: String) {
        step = .initialize
        reloadView()
        oauthManager = nil
        ZLToastView.showMessage(error)
    }
}
