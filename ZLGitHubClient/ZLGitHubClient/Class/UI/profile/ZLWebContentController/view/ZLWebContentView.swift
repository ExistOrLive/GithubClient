//
//  ZLWebContentView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/28.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import WebKit
import ZLGitRemoteService
import ZLBaseUI
import ZLBaseExtension
import ZLUtilities

@objc protocol ZLWebContentViewDelegate: NSObjectProtocol {
    @objc func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)

    @objc func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)

    @objc optional func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!)

    @objc optional func onTitleChange(title: String?)
}

extension ZLWebContentViewDelegate {
    func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
         decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
}

class ZLWebContentView: ZLBaseView {
    
    // MARK: UIView
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect.zero)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        return webView
    }()
    
    private lazy var processView: UIProgressView = {
       let processView = UIProgressView()
        return processView
    }()
        
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLTabBarBackColor")
        if getRealUserInterfaceStyle() == .light {
            view.layer.shadowColor = UIColor.black.cgColor
        } else {
            view.layer.shadowColor = UIColor.white.cgColor
        }
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: -1.5)
        return view
    }()
    
    private lazy var promptLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.font = .init(name: Font_PingFangSCMedium, size: 15)
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.iconFontImage(withText: ZLIconFont.BackArrow.rawValue,
                                              fontSize: 25,
                                              color: UIColor.label(withName: "CommonOperationColor")),
                        for: .normal)
        button.setImage(UIImage.iconFontImage(withText: ZLIconFont.BackArrow.rawValue,
                                              fontSize: 25,
                                              color: UIColor.label(withName: "DisabledColor")),
                        for: .disabled)
        button.addTarget(self, action: #selector(onGoBackButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var forwardButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.iconFontImage(withText: ZLIconFont.NextArrow.rawValue,
                                              fontSize: 25,
                                              color: UIColor.label(withName: "CommonOperationColor")),
                        for: .normal)
        button.setImage(UIImage.iconFontImage(withText: ZLIconFont.NextArrow.rawValue,
                                              fontSize: 25,
                                              color: UIColor.label(withName: "DisabledColor")),
                        for: .disabled)
        button.addTarget(self, action: #selector(onGoForwardButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var reloadOrStopButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.iconFontImage(withText: ZLIconFont.Close.rawValue,
                                              fontSize: 25,
                                              color: UIColor.label(withName: "CommonOperationColor")),
                        for: .normal)
        button.setImage(UIImage.iconFontImage(withText: ZLIconFont.Reload.rawValue,
                                              fontSize: 25,
                                              color: UIColor.label(withName: "CommonOperationColor")),
                        for: .highlighted)
        button.addTarget(self, action: #selector(onReloadOrStopLoadButtonCicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var safariButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.iconFontImage(withText: ZLIconFont.Safari.rawValue,
                                              fontSize: 25,
                                              color: UIColor.label(withName: "CommonOperationColor")),
                        for: .normal)
        button.addTarget(self, action: #selector(openInSafari), for: .touchUpInside)
        return button
    }()
    
    
    //
    
    private var originRequest: URLRequest?
    
    @objc private(set) var isLoading: Bool = false               // 是否在加载请求
    
    @objc var currentURL: URL? {
        webView.url 
    }

    @objc weak var delegate: ZLWebContentViewDelegate?
    

    deinit {
        removeObservers()
    }
    
    @objc override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addObservers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        addObservers()
    }
    
    
    @objc func loadRequest(_ request: URLRequest) {
        originRequest = request
        webView.load(request)
    }
    

    private func setupUI() {
        addSubview(stackView)
        addSubview(bottomView)
        addSubview(promptLabel)
        bottomView.addSubview(buttonStackView)
        
        stackView.addArrangedSubview(processView)
        stackView.addArrangedSubview(webView)
        
        buttonStackView.addArrangedSubview(backButton)
        buttonStackView.addArrangedSubview(forwardButton)
        buttonStackView.addArrangedSubview(reloadOrStopButton)
        buttonStackView.addArrangedSubview(safariButton)
        
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-45)
        }
        
        processView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        promptLabel.snp.makeConstraints { make in
            make.center.equalTo(webView)
            make.size.equalTo(CGSize(width: 200, height: 200))
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // 外观模式切换
        super.traitCollectionDidChange(previousTraitCollection)
        guard #available(iOS 13.0, *), self.traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle else {
            return
        }
        if getRealUserInterfaceStyle() == .light {
            bottomView.layer.shadowColor = UIColor.black.cgColor
        } else {
            bottomView.layer.shadowColor = UIColor.white.cgColor
        }
    }
}

// MARK: Observer
extension ZLWebContentView {
    
    private func addObservers() {
        webView.addObserver(self, forKeyPath: "title", options: [.new,.initial], context: nil)
        webView.addObserver(self, forKeyPath: "canGoBack", options: [.new,.initial], context: nil)
        webView.addObserver(self, forKeyPath: "canGoForward", options: [.new,.initial], context: nil)
       // webView.addObserver(self, forKeyPath: "isLoading", options: [.new,.initial], context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: [.new,.initial], context: nil)
    }
    
    private func removeObservers() {
        webView.removeObserver(self, forKeyPath: "title", context: nil)
        webView.removeObserver(self, forKeyPath: "canGoBack", context: nil)
        webView.removeObserver(self, forKeyPath: "canGoForward", context: nil)
       // webView.removeObserver(self, forKeyPath: "isLoading", context: nil)
        webView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {

        if "title" == keyPath {
            let newTitle = change?[NSKeyValueChangeKey.newKey] as? String
            if self.delegate?.responds(to: #selector(ZLWebContentViewDelegate.onTitleChange(title:))) ?? false {
                self.delegate?.onTitleChange?(title: newTitle)
            }
        } else if "canGoBack" == keyPath {
            guard let value: Bool = change?[NSKeyValueChangeKey.newKey] as? Bool else {
                return
            }
            
            if value {
                self.backButton.isEnabled = true
            } else {
                self.backButton.isEnabled = false
            }
        } else if "canGoForward" == keyPath {
            guard let value: Bool = change?[NSKeyValueChangeKey.newKey] as? Bool else {
                return
            }
            if value {
                self.forwardButton.isEnabled = true
            } else {
                self.forwardButton.isEnabled = false
            }
        } else if "estimatedProgress" == keyPath {
            guard let progress = change?[NSKeyValueChangeKey.newKey] as? Double else {
                return
            }
            processView.progress = Float(progress)
            processView.isHidden = progress == 1.0
            reloadOrStopButton.isHighlighted = progress == 1.0
            isLoading = progress < 1.0
            
        }

    }
}

// MARK: Action
extension ZLWebContentView {
    @objc private func onGoBackButtonClicked() {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @objc private func onGoForwardButtonClicked() {
        if webView.canGoForward {
            webView.goForward()
        }
    }

    @objc private func onReloadOrStopLoadButtonCicked() {
        if webView.isLoading {
            webView.stopLoading()
        } else {
            webView.reload()
        }
    }

    @objc private func openInSafari() {
        if let url = self.webView.url,
           UIApplication.shared.canOpenURL(url) {
            
            UIApplication.shared.open(url, options: [:], completionHandler: {(_: Bool) in
            })
        } else if let url = self.originRequest?.url,
                  UIApplication.shared.canOpenURL(url) {
            
            UIApplication.shared.open(url, options: [:], completionHandler: {(_: Bool) in
            })
        }
    }

}

// MARK: WKUIDelegate,WKNavigationDelegate
extension ZLWebContentView: WKUIDelegate, WKNavigationDelegate {
   
    func webViewDidClose(_ webView: WKWebView) {
        ZLLog_Debug("ZLWebContentView: webViewDidClose")
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // WkWebView 处理 open new window
        if !(navigationAction.targetFrame?.isMainFrame ?? false) {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    /// 1. 决定是否发出请求
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        ZLLog_Debug("ZLWebContentView: webView:decidePolicyForNavigationAction: type[\(navigationAction.navigationType)] request[\(navigationAction.request)]]")
        promptLabel.text = nil
        if self.delegate?.responds(to: #selector(ZLWebContentViewDelegate.webView(_:navigationAction:decisionHandler:))) ?? false {
            self.delegate?.webView(webView, navigationAction: navigationAction, decisionHandler: decisionHandler)
        } else {
            decisionHandler(.allow)
        }
    }

    /// 2. 开始发出请求
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {

        ZLLog_Debug("ZLWebContentView: webView:didStartProvisionalNavigation navigation[\(String(describing: navigation))]")
    }

    /// 3. 请求重定向
    func webView(_ webView: WKWebView,
                 didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {

        ZLLog_Debug("ZLWebContentView: webView:didReceiveServerRedirectForProvisionalNavigation navigation[\(String(describing: navigation))]")
        if self.delegate?.responds(to: #selector(ZLWebContentViewDelegate.webView(_:didReceiveServerRedirectForProvisionalNavigation:))) ?? false {
            self.delegate?.webView?(webView, didReceiveServerRedirectForProvisionalNavigation: navigation)
        }
    }

    /// 4. 请求失败
    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        ZLLog_Debug("ZLWebContentView: webView:didFailProvisionalNavigation navigation[\(String(describing: navigation))] error[\(error.localizedDescription)]")
        promptLabel.text = error.localizedDescription
    }

    /// 5. 收到响应，决定是否处理响应
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        //
        ZLLog_Debug("ZLWebContentView: webView:decidePolicyForNavigationResponse: response[\(navigationResponse.response)]")

        if  self.delegate?.responds(to: #selector(ZLWebContentViewDelegate.webView(_:navigationResponse:decisionHandler:))) ?? false {
            self.delegate?.webView(webView, navigationResponse: navigationResponse, decisionHandler: decisionHandler)
        } else {
            decisionHandler(.allow)
        }
    }

    /**
     * 收到请求的响应，开始刷新界面
     *
     **/
    /// 6. 处理请求， 开始刷新页面
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        ZLLog_Debug("ZLWebContentView: webView:didCommit navigation[\(String(describing: navigation))]")
    }

    /// 7.  页面渲染失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ZLLog_Debug("ZLWebContentView: webView:didFail navigation[\(String(describing: navigation))] error[\(error.localizedDescription)]")
    }

    /// 8. 页面渲染结束
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ZLLog_Debug("ZLWebContentView: webView:didFinish navigation[\(String(describing: navigation))]")
    }
    
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
       /// 当页面白屏时，reloadData
        webView.reload()
    }
}
