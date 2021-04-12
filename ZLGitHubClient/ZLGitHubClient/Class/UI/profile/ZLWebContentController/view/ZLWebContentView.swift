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
    @objc func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    
    @objc func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)
    
    @objc optional func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!);
    
    
    @objc optional func onTitleChange(title: String?) -> Void;
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
    
    @objc @IBOutlet private weak var progressView: UIProgressView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet private weak var toolBar: UIToolbar!           // 工具栏
    
    @objc var webView : WKWebView?
    
    var promptLabel : UILabel = UILabel.init()
    

    // toolbarbutton
    private var backBarButtonItem : UIBarButtonItem?
    private var forwardBarButtonItem : UIBarButtonItem?
    private var reloadOrStoploadBarButtonItem : UIBarButtonItem?
    private var safariBarButtonItem : UIBarButtonItem?
    
    
    private(set) var isLoading : Bool = false               // 是否在加载请求
    
    @objc weak var delegate : ZLWebContentViewDelegate?
    
    
    deinit {
        self.webView?.removeObserver(self, forKeyPath: "title", context: nil)
        self.webView?.removeObserver(self, forKeyPath: "canGoBack", context: nil)
        self.webView?.removeObserver(self, forKeyPath: "canGoForward", context: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        let webViewConfig = WKWebViewConfiguration.init()
        let webView : WKWebView = WKWebView.init(frame: self.containerView.bounds,configuration: webViewConfig)
        webView.autoresizingMask = UIView.AutoresizingMask.init(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        self.containerView.insertSubview(webView, belowSubview: self.toolBar)
        self.webView = webView
        self.webView?.scrollView.backgroundColor = UIColor.clear
        self.webView?.uiDelegate = self
        self.webView?.navigationDelegate = self
        
        self.containerView.addSubview(self.promptLabel)
        self.promptLabel.preferredMaxLayoutWidth = ZLScreenWidth - 150
        self.promptLabel.numberOfLines = 0
        self.promptLabel.textColor = UIColor.lightGray
        self.promptLabel.font = UIFont.init(name: Font_PingFangSCMedium, size: 15)
        self.promptLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.setUpToolBar()
        
        self.webView?.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
        self.webView?.addObserver(self, forKeyPath: "canGoBack", options: NSKeyValueObservingOptions.new, context: nil)
        self.webView?.addObserver(self, forKeyPath: "canGoForward", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    
    func setUpToolBar()
    {
        let backBarButtonItem : UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back"), style: .plain, target: self, action: #selector(onGoBackButtonClicked))
        backBarButtonItem.isEnabled = false
        backBarButtonItem.width = ZLKeyWindowWidth / 4
        self.backBarButtonItem = backBarButtonItem
        
        let forwardBarButtonItem : UIBarButtonItem =  UIBarButtonItem.init(image: UIImage.init(named: "next"), style: .plain, target: self, action: #selector(onGoForwardButtonClicked))
        forwardBarButtonItem.isEnabled = false
        forwardBarButtonItem.width = ZLKeyWindowWidth / 4
        self.forwardBarButtonItem = forwardBarButtonItem
        
        let reloadOrStoploadBarButtonItem : UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "close"), style: .plain, target: self, action: #selector(onReloadOrStopLoadButtonCicked))
        reloadOrStoploadBarButtonItem.width = ZLKeyWindowWidth / 4
        self.reloadOrStoploadBarButtonItem = reloadOrStoploadBarButtonItem
        
        let safariBarButtonItem : UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "safari"), style: .plain, target: self, action: #selector(openInSafari))
        safariBarButtonItem.width = ZLKeyWindowWidth / 4
        self.safariBarButtonItem = safariBarButtonItem
        
        let barButtonItems = [backBarButtonItem,forwardBarButtonItem,reloadOrStoploadBarButtonItem,safariBarButtonItem]
        
        self.toolBar.setItems(barButtonItems, animated: false)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.forwardBarButtonItem?.width = ZLKeyWindowWidth / 4
        self.backBarButtonItem?.width =  ZLKeyWindowWidth / 4
        self.reloadOrStoploadBarButtonItem?.width = ZLKeyWindowWidth / 4
        self.safariBarButtonItem?.width = ZLKeyWindowWidth / 4
    }
    

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if("title" == keyPath)
        {
            let newTitle = change?[NSKeyValueChangeKey.newKey] as? String
            if self.delegate?.responds(to: #selector(ZLWebContentViewDelegate.onTitleChange(title:))) ?? false {
                self.delegate?.onTitleChange?(title: newTitle)
            }
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
        self.promptLabel.text = nil
        self.reloadOrStoploadBarButtonItem?.image = UIImage.init(named: "close")
        self.isLoading = true
    }
    
    func setGetResponseStatus()
    {
        self.progressView.isHidden = false
        self.progressView.progress = ZLWebContentProgress.getResponse.rawValue
    }
    
    func setFaildRequestStatus(text : String)
    {
        self.progressView.isHidden = true
        self.progressView.progress = ZLWebContentProgress.getResponse.rawValue
        self.reloadOrStoploadBarButtonItem?.image = UIImage.init(named: "reload")
        self.isLoading = false
        self.promptLabel.text = text
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
        self.reloadOrStoploadBarButtonItem?.image = UIImage.init(named: "reload")
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
    
    
    @objc func openInSafari() {
        if self.webView?.url != nil {
            UIApplication.shared.open(self.webView!.url!, options: [:], completionHandler: {(result : Bool) in
                
            })
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
        if self.delegate != nil && self.delegate!.responds(to: #selector(ZLWebContentViewDelegate.webView(_:didReceiveServerRedirectForProvisionalNavigation:)))
        {
            self.delegate?.webView?(webView, didReceiveServerRedirectForProvisionalNavigation: navigation)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ZLLog_Debug("ZLWebContentView: webView:didStartProvisionalNavigation navigation[\(String(describing: navigation))]")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        ZLLog_Debug("ZLWebContentView: webView:didFailProvisionalNavigation navigation[\(String(describing: navigation))] error[\(error.localizedDescription)]")
        
        self.setFaildRequestStatus(text: error.localizedDescription)
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
