//
//  ZLOAuthBaseViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/8.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import WebKit
import ZLGitRemoteService

fileprivate let OAuthCallBackURL = "https://www.existorlive.cn/callback"

class ZLOAuthBaseViewModel: ZLBaseViewModel {
    
    weak var baseView: ZLWebContentView?
    
    var loginProcess :ZLLoginProcessModel?
    
    deinit {
      //  self.clearCookiesForWkWebView()
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if !(targetView is ZLWebContentView)
        {
            return;
        }
        
        guard let vc : ZLBaseViewController = self.viewController else {
            return;
        }
        vc.zlNavigationBar.backButton.removeTarget(vc, action: #selector(ZLBaseViewController.onBackButtonClicked(_:)), for: .touchUpInside)
        vc.zlNavigationBar.backButton.addTarget(self, action: #selector(ZLOAuthBaseViewModel.onBackButtonClick(button:)), for: .touchUpInside)
        
        self.baseView = targetView as? ZLWebContentView
        self.baseView?.delegate = self;
        
        guard let loginProcess : ZLLoginProcessModel = targetModel as? ZLLoginProcessModel else
        {
            ZLLog_Info("targetModel is not valid,return")
            return
        }
        
        self.loginProcess = loginProcess
        self.baseView?.webView?.load(loginProcess.loginRequest)
    }
    
    
}



// MARK: ZLOAuthBaseViewDelegate
extension ZLOAuthBaseViewModel: ZLWebContentViewDelegate
{
    func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        ZLLog_Info("OAuth: shouldStartLoadWith \(String(describing: navigationAction.request.url))");
        
        if (navigationAction.request.url?.absoluteString ?? "").hasPrefix(OAuthCallBackURL){
            
            // 登陆成功获取token
            decisionHandler(.allow)
            
            guard let query = navigationAction.request.url?.query,
                  let serialNumber = self.loginProcess?.serialNumber else {
                return
            }
            
            self.viewController?.dismiss(animated: true, completion: nil);
            ZLServiceManager.sharedInstance.loginServiceModel?.getAccessToken(query,
                                                                              serialNumber: serialNumber)
        }
        else{
            
            decisionHandler(.allow)
        }
        
    }
    
    func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        ZLLog_Info("OAuth: shouldStartLoadWith \(String(describing: navigationResponse.response))");
        
        decisionHandler(.allow)
    }
    

    
    @objc func onBackButtonClick(button: UIButton)
    {
        ZLServiceManager.sharedInstance.loginServiceModel?.stopLogin(self.loginProcess?.serialNumber ?? "")
        self.baseView?.webView?.stopLoading();
        self.viewController?.dismiss(animated: true, completion: nil);
    }
    
    func clearCookiesForWkWebView()
    {
        let types = [WKWebsiteDataTypeCookies,WKWebsiteDataTypeSessionStorage]
        let set = Set(types)
        let date = Date.init(timeIntervalSince1970: TimeInterval.init(0.0))
        WKWebsiteDataStore.default().removeData(ofTypes: set, modifiedSince: date, completionHandler: {() in
            
        })
        

    }
    
}



