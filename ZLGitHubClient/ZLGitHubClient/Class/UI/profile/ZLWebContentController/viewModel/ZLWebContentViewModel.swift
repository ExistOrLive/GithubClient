//
//  ZLWebContentViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/21.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLUIUtilities
import ZLBaseExtension
import WebKit

class ZLWebContentViewModel: ZLBaseViewModel {
    
    private weak var webContentView: ZLWebContentView?
    
    private var url: URL?

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        super.bindModel(targetModel, andView: targetView)
        
        guard var url = targetModel as? URL else {
            ZLToastView.showMessage("Invalid URL")
            return
        }
        
        if url.scheme == nil {
            if let newUrl = URL(string: "https://\(url.absoluteString)"),
               newUrl.host != nil {
                url = newUrl
            } else {
                ZLToastView.showMessage("Invalid URL")
                return
            }
        }
        
        guard let view = targetView as? ZLWebContentView else {
            return
        }
        self.url = url
        self.webContentView = view
        self.webContentView?.delegate = self
          
        if let url = self.url {
            let request = URLRequest(url: url,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 60)
            webContentView?.loadRequest(request)
        }
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
                self?.viewController?.navigationController?.popViewController(animated: false)
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
            viewController?.title = title 
        }
    }
}
