//
//  ZLOAuthBaseViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/8.
//  Copyright © 2019 ZTE. All rights reserved.
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
        print("OAuth: shouldStartLoadWith %@",request.url?.absoluteString ?? "");
        
        if (request.url?.absoluteString ?? "").hasPrefix(OAuthCallBackURL)
        {
            // 登陆成功获取token
            ZLGithubHttpClient.default().getAccessToken(request.url!.query!);
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
