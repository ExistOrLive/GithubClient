//
//  ZLReadMeView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/10/22.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import WebKit
import ZLGitRemoteService
import ZLBaseExtension
import ZLUIUtilities

@objc protocol ZLReadMeViewDelegate: NSObjectProtocol {

    @objc optional func onLinkClicked(url: URL?)

    @objc optional func getReadMeContent(result: Bool)

    @objc optional func loadEnd(result: Bool)

    @objc optional func notifyNewHeight(height: CGFloat)
}

class ZLReadMeView: UIView {


    // delegate
    weak var delegate: ZLReadMeViewDelegate?
    
    // model
    private var fullName: String?
    private var branch: String?

    private var readMeModel: ZLGithubContentModel?
    private var htmlStr: String?
    private var serialNumber: String?
    
    var hasRequestData: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(named: "ZLCellBack")
        addSubview(titleLabel)
        addSubview(refreshButton)
        addSubview(progressView)
        addSubview(webView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(20)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.top.equalTo(20)
            make.size.equalTo(CGSize(width: 60, height: 25))
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(60)
            make.height.equalTo(1)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(20)
            make.height.equalTo(20)
            make.left.right.equalToSuperview()
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // 外观模式切换
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
                self.reRender()
            }
        }
    }

    // 开始渲染页面
    private func startRender(codeHtml: String) {

        let htmlURL: URL? = Bundle.main.url(forResource: "github_style", withExtension: "html")

        let cssURL: URL?

        if #available(iOS 12.0, *) {
            if getRealUserInterfaceStyle() == .light {
                cssURL = Bundle.main.url(forResource: "github_style_markdown", withExtension: "css")
            } else {
                cssURL = Bundle.main.url(forResource: "github_style_dark_markdown", withExtension: "css")
            }
        } else {
            cssURL = Bundle.main.url(forResource: "github_style_markdown", withExtension: "css")
        }

        if let url = htmlURL {

            do {
                let htmlStr = try String.init(contentsOf: url)
                let newHtmlStr = NSMutableString.init(string: htmlStr)

                let range1 = (newHtmlStr as NSString).range(of: "<style>")
                if  range1.location != NSNotFound {
                    newHtmlStr.insert("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no\"/>", at: range1.location)
                }

                if let cssURL = cssURL {
                    let cssStr = try String.init(contentsOf: cssURL)
                    let range = (newHtmlStr as NSString).range(of: "</style>")
                    if  range.location != NSNotFound {
                        newHtmlStr.insert(cssStr, at: range.location)
                    }
                }

                let range = (newHtmlStr as NSString).range(of: "</body>")
                if  range.location != NSNotFound {
                    newHtmlStr.insert(codeHtml, at: range.location)
                }

                self.webView.loadHTMLString(newHtmlStr as String, baseURL: nil)

            } catch {
                ZLToastView.showMessage("load Code index html failed")
            }
        } else {
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "contentSize"{

            guard let size: CGSize = change?[NSKeyValueChangeKey.newKey] as? CGSize else {
                return
            }

            if (self.delegate?.responds(to: #selector(ZLReadMeViewDelegate.notifyNewHeight(height:)))) ?? false {
                self.delegate?.notifyNewHeight?(height: size.height + 81)
            }
            
            ZLMainThreadDispatch {
                self.webView.snp.updateConstraints { make in
                    make.height.equalTo(size.height)
                }
            }
        }

    }

    deinit {
        self.webView.scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    // MARK: Lazy view
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named:"ZLLabelColor1")
        label.font = .zlMediumFont(withSize: 17)
        label.text = "ReadMe"
        return label
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = UIColor(rgb: 0x000000, alpha: 0.3)
        progressView.trackTintColor = .white
        progressView.progress = 0.0
        return progressView
    }()

    lazy var refreshButton: UIButton = {
        let button = ZMButton()
        button.titleLabel?.font = .zlMediumFont(withSize: 10)
        button.setTitle(ZLLocalizedString(string: "refresh", comment: "刷新"), for: .normal)
        button.addTarget(self, action: #selector(onRefreshButtonClicked(_:)), for: .touchUpInside)
        return button
    }()

    lazy var webView: WKWebView = {
        let webview = WKWebView()
        webview.scrollView.backgroundColor = UIColor.clear
        webview.scrollView.isScrollEnabled = false
        webview.contentScaleFactor = 1.0
        webview.backgroundColor = UIColor.clear
        webview.uiDelegate = self
        webview.navigationDelegate = self
        
        webview.scrollView.maximumZoomScale = 1
        webview.scrollView.minimumZoomScale = 1
        webview.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        return webview
    }()

}

// MARK: - Action
extension ZLReadMeView {
    @objc func onRefreshButtonClicked(_ sender: Any) {
        self.reload()
    }
}

// MARK: - Outer Method
extension ZLReadMeView {
    /// 加载github readme
    ///  - parameters:
    ///      - fullName: 仓库fullname
    ///      - branch: 分支
    func startLoad(fullName: String, branch: String?) {

        self.stopload()

        self.fullName = fullName
        self.branch = branch

        self.progressView.progress = 0.3

        let serialNumber = NSString.generateSerialNumber()
        self.serialNumber = serialNumber
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoReadMeInfo(withFullName: fullName ,
                                                                            branch: branch ,
                                                                            isHTML: true,
                                                                            serialNumber: serialNumber) { [weak weakSelf = self](resultModel: ZLOperationResultModel) in

            if weakSelf?.serialNumber ?? "" != resultModel.serialNumber {
                return
            }
            
            if resultModel.result == false {
                weakSelf?.startRender(codeHtml: "Some Error Happened")
                return
            }

            guard let data: String = resultModel.data as? String else {
                weakSelf?.startRender(codeHtml: "Some Error Happened")
                return
            }
            
            weakSelf?.hasRequestData = true

            if weakSelf?.delegate?.responds(to: #selector(ZLReadMeViewDelegate.getReadMeContent(result:))) ?? false {
                weakSelf?.delegate?.getReadMeContent?(result: resultModel.result)
            }

            weakSelf?.htmlStr = data
            weakSelf?.startRender(codeHtml: data)
            weakSelf?.progressView.progress = 0.75
        }

        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoReadMeInfo(withFullName: fullName ,
                                                                            branch: branch ,
                                                                            isHTML: false,
                                                                            serialNumber: serialNumber) { [weak self](resultModel: ZLOperationResultModel) in

            guard let self = self,
                  self.serialNumber ?? "" == resultModel.serialNumber,
                  resultModel.result == true,
                  let data: ZLGithubContentModel = resultModel.data as? ZLGithubContentModel else {
                return
            }

            self.readMeModel = data

            if self.webView.isLoading == false
                && self.htmlStr != nil {
                self.reRender()
            }
        }
    }

    func stopload() {
        self.serialNumber = nil
        self.readMeModel = nil
        self.htmlStr = nil

        self.progressView.progress = 0.0
        self.progressView.isHidden = false
        self.webView.stopLoading()
    }

    /// 仅重新渲染网页
    func reRender() {
        if let html = self.htmlStr {
            self.startRender(codeHtml: html)
        }
    }

    /// 重新请求加载网页
    func reload() {
        if let fullName = self.fullName {
            self.startLoad(fullName: fullName, branch: self.branch)
        }
    }

    /// 国际化刷新
    func justUpdate() {
        self.refreshButton.setTitle(ZLLocalizedString(string: "refresh", comment: "刷新"), for: .normal)
    }
    
}

// MARK: - WKWebview
extension ZLReadMeView: WKNavigationDelegate, WKUIDelegate {

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {

    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {

    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {

    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard var urlStr = navigationAction.request.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }
        
        if navigationAction.navigationType == .linkActivated {
            
            decisionHandler(.cancel)
            
            if ZLCommonURLManager.openURL(urlStr: urlStr) {
                return
            }
        
            if urlStr.starts(with: "about:blank%23") {
                if  let range = urlStr.range(of: "about:blank%23") {
                    urlStr.removeSubrange(range)
                    let url = URL(string: "\(self.readMeModel?.html_url ?? "")#\(urlStr))")
                    if self.delegate?.responds(to: #selector(ZLReadMeViewDelegate.onLinkClicked(url:))) ?? false {
                        self.delegate?.onLinkClicked?(url: url)
                    }
                    return
                }
            }
            
            var url = URL(string: urlStr)
            if url?.host == nil {
                // 如果是相对路径，组装baseurl
                url = (URL.init(string: self.readMeModel?.html_url ?? "") as NSURL?)?.deletingLastPathComponent
                url = URL(string: "\(url?.absoluteString ?? "")\(urlStr)")
            }
            if self.delegate?.responds(to: #selector(ZLReadMeViewDelegate.onLinkClicked(url:))) ?? false {
                self.delegate?.onLinkClicked?(url: url)
            }
            
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.progressView.progress = 1.0
        self.progressView.isHidden = true
        self.fixPicture()
        if self.delegate?.responds(to: #selector(ZLReadMeViewDelegate.loadEnd(result:))) ?? false {
            self.delegate?.loadEnd?(result: self.htmlStr != nil)
        }
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
       /// 当页面白屏时，reloadData
        webView.reload()
    }


    func fixPicture() {
        if let download_url = self.readMeModel?.download_url {
            let baseURLStr = (URL.init(string: download_url) as NSURL?)?.deletingLastPathComponent?.absoluteString
            let addBaseScript = "let a = '\(baseURLStr ?? "")';let array = document.getElementsByTagName('img');for(i=0;i<array.length;i++){let item=array[i];if(item.getAttribute('src').indexOf('http') == -1){item.src = a + item.getAttribute('src');}}"

            webView.evaluateJavaScript(addBaseScript) { (_: Any?, _: Error?) in

            }
        }
    }

}
