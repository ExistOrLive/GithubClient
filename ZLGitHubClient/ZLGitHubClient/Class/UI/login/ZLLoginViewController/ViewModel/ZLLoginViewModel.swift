//
//  ZLLoginViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLLoginViewModel: ZLBaseViewModel, ZLLoginBaseViewDelegate {

    weak var baseView: ZLLoginBaseView?

    // 登陆操作的流水号
    private var loginSerialNumber: String?

    deinit {
        ZLServiceManager.sharedInstance.loginServiceModel?.unRegisterObserver(self, name: ZLLoginResult_Notification)
    }

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let targetView = targetView as? ZLLoginBaseView else {
            return
        }

        self.baseView = targetView
        self.baseView?.delegate = self

        // 注册对于登陆结果的通知
        ZLServiceManager.sharedInstance.loginServiceModel?.registerObserver(self, selector: #selector(onNotificationArrived(notificaiton:)), name: ZLLoginResult_Notification)

        self.reloadView()
    }

    override func vcLifeCycle_viewWillAppear() {
        self.reloadView()
    }

    func reloadView() {
        switch ZLServiceManager.sharedInstance.loginServiceModel?.currentLoginStep() {
        case ZLLoginStep_init:do {
            self.baseView?.loginButton.isEnabled = true
            self.baseView?.accessTokenButton.isEnabled = true
            self.baseView?.loginInfoLabel.text = nil
            self.baseView?.activityIndicator.isHidden = true
            }
        case ZLLoginStep_checkIsLogined:do {
            self.baseView?.loginButton.isEnabled = false
            self.baseView?.accessTokenButton.isEnabled = false
            self.baseView?.loginInfoLabel.text = ZLLocalizedString(string: "ZLLoginStep_checkIsLogined", comment: "")
            self.baseView?.activityIndicator.isHidden = false
            self.baseView?.activityIndicator.startAnimating()
            }
        case ZLLoginStep_logining:do {
            self.baseView?.loginButton.isEnabled = false
            self.baseView?.accessTokenButton.isEnabled = false
            self.baseView?.loginInfoLabel.text = ZLLocalizedString(string: "ZLLoginStep_logining", comment: "")
            self.baseView?.activityIndicator.isHidden = false
            self.baseView?.activityIndicator.startAnimating()
            }
        case ZLLoginStep_getToken:do {
            self.baseView?.loginButton.isEnabled = false
            self.baseView?.accessTokenButton.isEnabled = false
            self.baseView?.loginInfoLabel.text = ZLLocalizedString(string: "ZLLoginStep_getToken", comment: "")
            self.baseView?.activityIndicator.isHidden = false
            self.baseView?.activityIndicator.startAnimating()
            }
        case ZLLoginStep_checkToken:do {
            self.baseView?.loginButton.isEnabled = false
            self.baseView?.accessTokenButton.isEnabled = false
            self.baseView?.loginInfoLabel.text = ZLLocalizedString(string: "ZLLoginStep_checkToken", comment: "")
            self.baseView?.activityIndicator.isHidden = false
            self.baseView?.activityIndicator.startAnimating()
            }
        case ZLLoginStep_Success:do {
            self.baseView?.loginButton.isEnabled = true
            self.baseView?.accessTokenButton.isEnabled = true
            self.baseView?.loginInfoLabel.text = ZLLocalizedString(string: "ZLLoginStep_Success", comment: "")
            self.baseView?.activityIndicator.isHidden = true
            self.baseView?.activityIndicator.stopAnimating()
            }
        default:
            break
        }
    }

    func onLoginButtonClicked() {

        // 开始登陆认证
        let serialNumber = NSString.generateSerialNumber()
        self.loginSerialNumber = serialNumber
        ZLServiceManager.sharedInstance.loginServiceModel?.startOAuth(serialNumber)

        self.reloadView()
    }

    func onAccessTokenButtonClicked() {

        ZLInputAccessTokenView.showInputAccessTokenViewWithResultBlock(resultBlock: {(token: String?) in
            guard let token = token else {
                ZLToastView.showMessage(ZLLocalizedString(string: "token is nil", comment: ""))
                return
            }

            let serialNumber = NSString.generateSerialNumber()

            self.loginSerialNumber = serialNumber
            ZLServiceManager.sharedInstance.loginServiceModel?.checkTokenIsValid(token, serialNumber: serialNumber)

            self.reloadView()
        })
    }

    // MARK: onNotificationArrived
    @objc func onNotificationArrived(notificaiton: Notification) {
        switch notificaiton.name {

        case ZLLoginResult_Notification: do {

            guard let loginProcess: ZLLoginProcessModel = notificaiton.params as? ZLLoginProcessModel else {
                return
            }

            if self.loginSerialNumber != loginProcess.serialNumber {
                ZLLog_Info("loginProcess: self.loginSerialNumber[\(self.loginSerialNumber ?? "")] loginProcess.serialNumber[\(loginProcess.serialNumber)] not match")
                return
            }

            if loginProcess.result == false {
                self.baseView?.loginButton.isUserInteractionEnabled = true
                self.baseView?.activityIndicator.isHidden = true
                ZLToastView.showMessage("Login Failed: \(loginProcess.errorModel.message)")

                self.loginSerialNumber = nil
            } else {
                if loginProcess.loginStep == ZLLoginStep_logining {
                    let vc: ZLOAuthViewController = ZLOAuthViewController()
                    vc.modalPresentationStyle = .fullScreen
                    vc.loginProcessModel = loginProcess
                    self.viewController?.present(vc, animated: false, completion: nil)
                } else if loginProcess.loginStep == ZLLoginStep_Success {
                    self.baseView?.activityIndicator.isHidden = true
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.switch(toMainController: true)
                }
            }

            self.reloadView()

            }
        default:
            break
        }
    }
}
