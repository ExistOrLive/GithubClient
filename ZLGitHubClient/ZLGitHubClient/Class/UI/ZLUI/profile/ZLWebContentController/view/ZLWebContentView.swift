//
//  ZLWebContentView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/28.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import WebKit

enum ZLWebContentProgress : Float {
    case sendRequest = 0.1
    case getResponse = 0.5
    case startLoad = 0.7
    case endLoad = 1.0
}

@objc protocol ZLWebContentViewDelegate : NSObjectProtocol
{
    @objc func onBackButtonClick(button: UIButton)
    
    @objc func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    
    @objc func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)
}

extension ZLWebContentViewDelegate
{
    func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
         decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)
    {
        decisionHandler(.allow)
    }
}

class ZLWebContentView: ZLBaseView {

    @objc @IBOutlet private weak var topViewHeightConstraint: NSLayoutConstraint!
    
    @objc @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet weak var additionButton: UIButton!
    
    @objc @IBOutlet private weak var progressView: UIProgressView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet private weak var toolBar: UIToolbar!           // 工具栏
    
    @objc var webView : WKWebView?
    

    // toolbarbutton
    private var backBarButtonItem : UIBarButtonItem?
    private var forwardBarButtonItem : UIBarButtonItem?
    private var reloadOrStoploadBarButtonItem : UIBarButtonItem?
    
    
    private(set) var isLoading : Bool = false               // 是否在加载请求
    
    @objc var delegate : ZLWebContentViewDelegate?
    @objc var title : String?                               // 预置title
    {
        didSet{
            self.titleLabel.text = self.title as String?
        }
    }
    
    
    deinit {
        self.webView?.removeObserver(self, forKeyPath: "title", context: nil)
        self.webView?.removeObserver(self, forKeyPath: "canGoBack", context: nil)
        self.webView?.removeObserver(self, forKeyPath: "canGoForward", context: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.topViewHeightConstraint.constant = self.topViewHeightConstraint.constant + ZLStatusBarHeight
        
        let webViewConfig = WKWebViewConfiguration.init()
        let webView : WKWebView = WKWebView.init(frame: self.containerView.bounds,configuration: webViewConfig)
        webView.autoresizingMask = UIView.AutoresizingMask.init(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        self.containerView.insertSubview(webView, belowSubview: self.toolBar)
        self.webView = webView
        self.webView?.uiDelegate = self
        self.webView?.navigationDelegate = self
        
        self.setUpToolBar()
        
        self.webView?.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
        self.webView?.addObserver(self, forKeyPath: "canGoBack", options: NSKeyValueObservingOptions.new, context: nil)
        self.webView?.addObserver(self, forKeyPath: "canGoForward", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    
    func setUpToolBar()
    {
        let backBarButtonItem : UIBarButtonItem = UIBarButtonItem.init(title: "上一页", style: .plain, target: self, action: #selector(onGoBackButtonClicked))
        backBarButtonItem.isEnabled = false
        self.backBarButtonItem = backBarButtonItem
        
        let forwardBarButtonItem : UIBarButtonItem = UIBarButtonItem.init(title: "下一页", style: .plain, target: self, action: #selector(onGoForwardButtonClicked))
        forwardBarButtonItem.isEnabled = false
        self.forwardBarButtonItem = forwardBarButtonItem
        
        let reloadOrStoploadBarButtonItem : UIBarButtonItem = UIBarButtonItem.init(title: "停止加载", style:.plain, target: self, action: #selector(onReloadOrStopLoadButtonCicked))
        self.reloadOrStoploadBarButtonItem = reloadOrStoploadBarButtonItem
        
        let barButtonItems = [backBarButtonItem,forwardBarButtonItem,reloadOrStoploadBarButtonItem]
        
        self.toolBar.setItems(barButtonItems, animated: false)
    }
    
    
    
    @IBAction func onBackButtonClicked(_ sender: Any) {
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(ZLWebContentViewDelegate.onBackButtonClick(button:)))
        {
            self.delegate?.onBackButtonClick(button: sender as! UIButton)
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if("title" == keyPath)
        {
            if self.title != nil
            {
                return
            }
            
            let newTitle = change?[NSKeyValueChangeKey.newKey] as? String
            self.titleLabel.text = newTitle
        }
        else if "canGoBack" == keyPath
        {
            guard let value : Bool = change?[NSKeyValueChangeKey.newKey] as? Bool else
            {
                return
            }
            
            if value
            {
                self.backBarButtonItem?.isEnabled = true
            }
            else
            {
                self.backBarButtonItem?.isEnabled = false
            }
        }
        else if "canGoForward" == keyPath
        {
            guard let value : Bool = change?[NSKeyValueChangeKey.newKey] as? Bool else
            {
                return
            }
            
            if value
            {
                self.forwardBarButtonItem?.isEnabled = true
            }
            else
            {
                self.forwardBarButtonItem?.isEnabled = false
            }
        }
        
    }
    
}


// MARK: ZLWebContentProgress
extension ZLWebContentView
{
    func setSendRequestStatus()
    {
        self.progressView.isHidden = false
        self.progressView.progress = ZLWebContentProgress.sendRequest.rawValue
        self.reloadOrStoploadBarButtonItem?.title = "停止加载"
        self.isLoading = true
    }
    
    func setGetResponseStatus()
    {
        self.progressView.isHidden = false
        self.progressView.progress = ZLWebContentProgress.getResponse.rawValue
    }
    
    func setFaildRequestStatus()
    {
        self.progressView.isHidden = true
        self.progressView.progress = ZLWebContentProgress.getResponse.rawValue
        self.reloadOrStoploadBarButtonItem?.title = "重新加载"
        self.isLoading = false
    }
    
    func setStartLoadStatus()
    {
        self.progressView.isHidden = false
        self.progressView.progress = ZLWebContentProgress.startLoad.rawValue
    }
    
    func setEndLoadStatus()
    {
        self.progressView.isHidden = true
        self.progressView.progress = ZLWebContentProgress.endLoad.rawValue
        self.reloadOrStoploadBarButtonItem?.title = "重新加载"
        self.isLoading = false
    }
}

// MARK: UIToolBar
extension ZLWebContentView
{
    @objc func onGoBackButtonClicked()
    {
        if self.webView?.canGoBack ?? false
        {
            self.webView?.goBack()
        }
    }
    
    @objc func onGoForwardButtonClicked()
    {
        if self.webView?.canGoForward ?? false
        {
            self.webView?.goForward()
        }
    }
    
    @objc func onReloadOrStopLoadButtonCicked()
    {
        if self.isLoading
        {
            self.webView?.stopLoading()
        }
        else
        {
            self.webView?.reload()
        }
        
    }
}

// MARK: WKUIDelegate,WKNavigationDelegate
extension ZLWebContentView : WKUIDelegate,WKNavigationDelegate
{
    func webViewDidClose(_ webView: WKWebView) {
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        ZLLog_Debug("ZLWebContentView: webView:decidePolicyForNavigationAction: type[\(navigationAction.navigationType)] request[\(navigationAction.request)]]")
        
        self.setSendRequestStatus()
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(ZLWebContentViewDelegate.webView(_:navigationAction:decisionHandler:)))
        {
            self.delegate?.webView(webView, navigationAction: navigationAction, decisionHandler: decisionHandler)
        }
        else
        {
            decisionHandler(.allow)
        }
        
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        ZLLog_Debug("ZLWebContentView: webView:decidePolicyForNavigationResponse: response[\(navigationResponse.response)]")
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(ZLWebContentViewDelegate.webView(_:navigationResponse:decisionHandler:)))
        {
            self.delegate?.webView(webView, navigationResponse: navigationResponse, decisionHandler: decisionHandler)
        }
        else
        {
            decisionHandler(.allow)
        }
        
        
        self.setGetResponseStatus()
    }
    

    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        ZLLog_Debug("ZLWebContentView: webView:didReceiveServerRedirectForProvisionalNavigation navigation[\(String(describing: navigation))]")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ZLLog_Debug("ZLWebContentView: webView:didStartProvisionalNavigation navigation[\(String(describing: navigation))]")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        ZLLog_Debug("ZLWebContentView: webView:didFailProvisionalNavigation navigation[\(String(describing: navigation))] error[\(error.localizedDescription)]")
        
        self.setFaildRequestStatus()
    }
    
    
    

    /**
     * 收到请求的响应，开始刷新界面
     *
     **/
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        self.setStartLoadStatus()
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        self.setEndLoadStatus()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       
        self.setEndLoadStatus()
    }
}
