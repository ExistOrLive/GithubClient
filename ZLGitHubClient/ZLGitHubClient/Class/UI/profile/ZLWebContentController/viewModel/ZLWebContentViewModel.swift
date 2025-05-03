//
//  ZLWebContentViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/21.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import WebKit
import ZMMVVM

class ZLWebContentViewModel: ZMBaseViewModel {
    
    private(set) var url: URL?
    
    init(url: URL?) {
        super.init()
        
        guard let url = url else {
            ZLToastView.showMessage("Invalid URL")
            return
        }
        
        self.url = url
        
        if url.scheme == nil {
            self.url = URL(string: "https://\(url.absoluteString)")
        }
    }

    var webContentView: ZLWebContentView? {
        zm_view as? ZLWebContentView
    }
}


extension ZLWebContentViewModel: ZLWebContentViewDelegate {
    
    @objc func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let urlStr = navigationAction.request.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }
        
        if ZLCommonURLManager.openURL(urlStr: urlStr, completionHandler: { [weak self] result in
            if result, urlStr == self?.url?.absoluteString {
                self?.zm_viewController?.navigationController?.popViewController(animated: false)
            }
        }) {
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }

    @objc func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

    @objc func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        if let url = webView.url {
            
            if let scheme = url.scheme,
               scheme == "https" ||
                scheme == "http" {
                return
            }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
            
    }

    @objc func onTitleChange(title: String?) {
        if let title = title {
            zm_viewController?.title = title 
        }
    }
}
