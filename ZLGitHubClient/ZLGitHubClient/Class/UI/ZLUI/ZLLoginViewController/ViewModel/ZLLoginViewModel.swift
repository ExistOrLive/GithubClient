//
//  ZLLoginViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZTE. All rights reserved.
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
    }
    
    func onLoginButtonClicked() {

        self.baseView?.loginButton.isUserInteractionEnabled = false;
        self.baseView?.activityIndicator.isHidden = false;
        self.baseView?.activityIndicator.startAnimating();
        
        weak var weakSelf: ZLLoginViewModel? = self
        ZLGithubHttpClient.default().startOAuth { (request:URLRequest?, isNeedContinuedLogin: Bool, isSuccess: Bool) in
            DispatchQueue.main.async {
                if isNeedContinuedLogin
                {
                    let vc:ZLOAuthViewController = ZLOAuthViewController();
                    vc.request = request;
                    weakSelf!.viewController?.present(vc, animated: false, completion: nil);
                }
                else if isSuccess
                {
                    weakSelf!.baseView?.activityIndicator.isHidden = true;
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
                    weakSelf!.viewController?.present(controller, animated: true, completion: nil);
                    
                }
            }
        }
    }
}
