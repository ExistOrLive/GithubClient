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
import ZLUtilities
import ZMMVVM
import WidgetKit

enum ZLLoginStep {
    case initialize
    case oauth
    case gettoken
    case checktoken
    
    var eventTrack: Int {
        switch self {
        case .initialize:
            return 0
        case .oauth:
            return 1
        case .gettoken:
            return 2
        case .checktoken:
            return 3
        }
    }
}

class ZLLoginViewModel: ZMBaseViewModel, ZLLoginBaseViewDelegate {

    var baseView: ZLLoginBaseView? {
        zm_view as? ZLLoginBaseView
    }

    private var oauthManager: ZLGithubOAuthManager?

    // 登陆操作的流水号
    private var loginSerialNumber: String?
    // 登陆步骤
    private(set) var step: ZLLoginStep = .initialize
    
    
    /// datetime
    private var startTime: TimeInterval = 0
    private var endTime: TimeInterval = 0
    

    deinit {
        ZLServiceManager.sharedInstance.loginServiceModel?.unRegisterObserver(self, name: ZLLoginResult_Notification)
    }

    override init() {
        super.init()
        // 注册对于登陆结果的通知
        ZLServiceManager.sharedInstance.loginServiceModel?.registerObserver(self, selector: #selector(onNotificationArrived(notificaiton:)), name: ZLLoginResult_Notification)
    }
    

   

    func onLoginButtonClicked() {
        
        startTime = Date().timeIntervalSince1970
        oauthManager = ZLGithubOAuthManager(client_id: ZLUISharedDataManager.githubClientID,
                                            client_secret: ZLUISharedDataManager.githubClientSecret,
                                            redirect_uri: ZLUISharedDataManager.githubClientCallback)
        
        oauthManager?.startOAuth(type: .code,
                                 delegate: self,
                                 vcBlock: { [weak self] vc in
            vc.modalPresentationStyle = .fullScreen
            self?.zm_viewController?.present(vc, animated: true, completion: nil)
        },
                                 scopes:[.user,.repo,.gist,.notifications,.read_org])
    }

    func onAccessTokenButtonClicked() {

        ZLInputAccessTokenView.showInputAccessTokenView(resultBlock: {(token: String?) in
            guard let token = token else {
                ZLToastView.showMessage(ZLLocalizedString(string: "token is nil", comment: ""))
                return
            }

            let serialNumber = NSString.generateSerialNumber()
            self.loginSerialNumber = serialNumber
            
            ZLServiceManager.sharedInstance.loginServiceModel?.setAccessToken(token,
                                                                              serialNumber: serialNumber)
            self.step = .checktoken
            self.zm_reloadView()
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
            
            if resultModel.result  {
                step = .initialize
                loginSerialNumber = nil
                zm_reloadView()
                ZLToastView.showMessage("Login Success")
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.switch(toMainController: true)
            
                
                // 通知所有Widget更新
                if #available(iOS 14.0, *) {
                    WidgetCenter.shared.reloadAllTimelines()
                }
            } else {
                step = .initialize
                loginSerialNumber = nil
                zm_reloadView()
                guard let errorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    return
                }
                ZLToastView.showMessage("Login Failed: status[\(errorModel.statusCode)] \(errorModel.message)")
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
            zm_reloadView()
        case .getToken:
            step = .gettoken
            zm_reloadView()
            break
        case .fail:
            break
        case .success:
            break
        }
    }
    
    func onOAuthSuccess(token: String) {
        endTime = Date().timeIntervalSince1970
        analytics.log(.githubOAuth(result: true,
                                   step: step.eventTrack,
                                   msg: "success",
                                   duration: endTime - startTime))
        oauthManager = nil
        let serialNumber = NSString.generateSerialNumber()
        loginSerialNumber = serialNumber
        ZLServiceManager.sharedInstance.loginServiceModel?.setAccessToken(token,
                                                                          serialNumber: serialNumber)
        step = .checktoken
        zm_reloadView()
    }
    
    func onOAuthFail(status: ZLGithubOAuthStatus, error: String) {
        endTime = Date().timeIntervalSince1970
        analytics.log(.githubOAuth(result: false,
                                   step: step.eventTrack,
                                   msg: error,
                                   duration: endTime - startTime))
        step = .initialize
        zm_reloadView()
        oauthManager = nil
        ZLToastView.showMessage(error)
    }
}
