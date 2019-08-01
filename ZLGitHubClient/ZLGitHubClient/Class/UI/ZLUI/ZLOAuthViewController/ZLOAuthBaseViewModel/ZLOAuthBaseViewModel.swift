//
//  ZLOAuthBaseViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/8.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

fileprivate let OAuthCallBackURL = "https://github.com/organizations/MengAndJie/CallBack"

class ZLOAuthBaseViewModel: ZLBaseViewModel {
    
    weak var baseView: ZLOAuthBaseView?
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if !(targetView is ZLOAuthBaseView)
        {
            return;
        }
        
        self.baseView = targetView as? ZLOAuthBaseView
        self.baseView?.delegate = self;
        self.baseView?.webView.delegate = self;
        
        if (targetModel != nil) && (targetModel is URLRequest)
        {
            self.baseView?.webView.loadRequest(targetModel as! URLRequest);
        }

    }
    
    
}

// MARK: ZLOAuthBaseViewDelegate
extension ZLOAuthBaseViewModel: ZLOAuthBaseViewDelegate
{
    func onBackButtonClicked(button: UIButton)
    {
        self.baseView?.webView.stopLoading();
        self.viewController?.dismiss(animated: true, completion: nil);
    }
}


// MARK: UIWebViewDelegate
extension ZLOAuthBaseViewModel: UIWebViewDelegate
{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool
    {
        ZLLog_Info("OAuth: shouldStartLoadWith \(String(describing: request.url))");
        
        if (request.url?.absoluteString ?? "").hasPrefix(OAuthCallBackURL)
        {
            // 登陆成功获取token
            ZLLoginServiceModel.shared().getAccessToken(request.url!.query!);
            self.viewController?.dismiss(animated: true, completion: nil);
            return false;
        }
        else
        {
            return true;
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        
    }
}
