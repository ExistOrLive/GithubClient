//
//  ZLLoginViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLLoginViewModel: ZLBaseViewModel,ZLLoginBaseViewDelegate {

    weak var baseView: ZLLoginBaseView?
    
    // 登陆操作的流水号
    private var loginSerialNumber : String?
    
    deinit {
        ZLLoginServiceModel.shared().unRegisterObserver(self, name: ZLLoginResult_Notification)
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        if !(targetView is ZLLoginBaseView)
        {
            return;
        }
        
        self.baseView = targetView as? ZLLoginBaseView;
        self.baseView?.delegate = self;
        
        // 注册对于登陆结果的通知
        ZLLoginServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notificaiton:)), name:ZLLoginResult_Notification)
        
        self.loginSerialNumber = NSString.generateSerialNumber()
        ZLLoginServiceModel.shared().startOAuth(self.loginSerialNumber!)
        
        self.reloadView()
    }
    
    
    override func vcLifeCycle_viewWillAppear() {
         self.reloadView()
    }
    
    func reloadView()
    {
        let loginName = ZLKeyChainManager.sharedInstance().getUserAccount()
        let headImageUrlStr = ZLKeyChainManager.sharedInstance().getHeadImageURL()
        let imageUrl = URL.init(string: headImageUrlStr)
        
        self.baseView?.userLoginNameLabel.text = loginName
        if imageUrl != nil
        {
           self.baseView?.userHeadImageView.setImageWith(imageUrl!, placeholderImage: nil)
        }
        
        switch(ZLLoginServiceModel.shared().currentLoginStep())
        {
        case ZLLoginStep_init:do{
            self.baseView?.loginButton.isEnabled = true
            self.baseView?.loginInfoLabel.text = nil
            self.baseView?.activityIndicator.isHidden = true
            }
        case ZLLoginStep_checkIsLogined:do{
            self.baseView?.loginButton.isEnabled = false
            self.baseView?.loginInfoLabel.text = "ZLLoginStep_checkIsLogined"
            self.baseView?.activityIndicator.isHidden = false
            self.baseView?.activityIndicator.startAnimating()
            }
        case ZLLoginStep_logining:do{
            self.baseView?.loginButton.isEnabled = false
            self.baseView?.loginInfoLabel.text = "ZLLoginStep_logining"
            self.baseView?.activityIndicator.isHidden = false
            self.baseView?.activityIndicator.startAnimating()
            }
        case ZLLoginStep_getToken:do{
            self.baseView?.loginButton.isEnabled = false
            self.baseView?.loginInfoLabel.text = "ZLLoginStep_getToken"
            self.baseView?.activityIndicator.isHidden = false
            self.baseView?.activityIndicator.startAnimating()
            }
        case ZLLoginStep_Success:do{
            self.baseView?.loginButton.isEnabled = true
            self.baseView?.loginInfoLabel.text = "ZLLoginStep_Success"
            self.baseView?.activityIndicator.isHidden = true
            self.baseView?.activityIndicator.stopAnimating()
            }
        default:
            break;
        }
    }

    func onLoginButtonClicked() {

        // 开始登陆认证
        self.loginSerialNumber = NSString.generateSerialNumber()
        ZLLoginServiceModel.shared().startOAuth(self.loginSerialNumber!)
        
        self.reloadView()
       
    }
    
    
    // MARK: onNotificationArrived
    @objc func onNotificationArrived(notificaiton: Notification)
    {
        switch notificaiton.name{
            
        case ZLLoginResult_Notification: do{
            
            guard let loginProcess : ZLLoginProcessModel = notificaiton.params as? ZLLoginProcessModel else
            {
                return
            }
            
            if self.loginSerialNumber! != loginProcess.serialNumber
            {
                ZLLog_Info("loginProcess: self.loginSerialNumber[\(self.loginSerialNumber!)] loginProcess.serialNumber[\(loginProcess.serialNumber)] not match")
                return
            }
            
            if loginProcess.result == false
            {
                self.baseView?.loginButton.isUserInteractionEnabled = true;
                self.baseView?.activityIndicator.isHidden = true;
                let controller: UIAlertController = UIAlertController.init(title: "登陆失败", message: nil, preferredStyle: UIAlertControllerStyle.alert);
                let action: UIAlertAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: nil);
                                controller.addAction(action);
                self.viewController?.present(controller, animated: true, completion: nil);
                
                self.loginSerialNumber = nil;
            }
            else
            {
                if loginProcess.loginStep == ZLLoginStep_logining
                {
                    let vc:ZLOAuthViewController = ZLOAuthViewController();
                    vc.modalPresentationStyle = .fullScreen
                    vc.loginProcessModel = loginProcess
                    self.viewController?.present(vc, animated: false, completion: nil);
                }
                else if loginProcess.loginStep == ZLLoginStep_Success
                {
                    self.baseView?.activityIndicator.isHidden = true;
                    let appDelegate:AppDelegate  = UIApplication.shared.delegate! as! AppDelegate;
                    appDelegate.switchToMainController();
                }
            }
            
            
            self.reloadView()
            
            }
        default:
            break;
        }
    }
}
