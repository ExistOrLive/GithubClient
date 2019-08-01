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
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        if !(targetView is ZLLoginBaseView)
        {
            return;
        }
        
        self.baseView = targetView as? ZLLoginBaseView;
        self.baseView?.delegate = self;
        
        // 注册对于登陆结果的通知
        ZLLoginServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notificaiton:)), name:ZLLoginResult_Notification)
    }
    
    deinit {
        ZLLoginServiceModel.shared().unRegisterObserver(self, name: ZLLoginResult_Notification)
    }
    
    func onLoginButtonClicked() {

        self.baseView?.loginButton.isUserInteractionEnabled = false;
        self.baseView?.activityIndicator.isHidden = false;
        self.baseView?.activityIndicator.startAnimating();
        
        // 开始登陆认证
        ZLLoginServiceModel.shared().startOAuth();
       
    }
    
    
    // MARK: onNotificationArrived
    @objc func onNotificationArrived(notificaiton: Notification)
    {
        switch notificaiton.name{
            
        case ZLLoginResult_Notification: do{
            
            guard let loginResult : ZLLoginResultModel = notificaiton.params as? ZLLoginResultModel else
            {
                return
            }
            
            if loginResult.isNeedContinuedLogin
            {
                let vc:ZLOAuthViewController = ZLOAuthViewController();
                vc.request = loginResult.loginRequest;
                self.viewController?.present(vc, animated: false, completion: nil);
            }
            else if loginResult.result
            {
                self.baseView?.activityIndicator.isHidden = true;
                let appDelegate:AppDelegate  = UIApplication.shared.delegate! as! AppDelegate;
                appDelegate.switchToMainController();
            }
            else
            {
                self.baseView?.loginButton.isUserInteractionEnabled = true;
                self.baseView?.activityIndicator.isHidden = true;
                let controller: UIAlertController = UIAlertController.init(title: "登陆失败", message: nil, preferredStyle: UIAlertControllerStyle.alert);
                let action: UIAlertAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: nil);
                controller.addAction(action);
                self.viewController?.present(controller, animated: true, completion: nil);
                
            }
            
            }
        default:
            break;
        }
    }
}
