//
//  ZLGistCodePreviewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/6/15.
//  Copyright © 2025 ZM. All rights reserved.
//
import UIKit
import WebKit
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService
import ZLUtilities
import ZMMVVM

/**
  *  利用 REST API 获取 md 内容 ； 代码使用markdown接口渲染
 */

class ZLGistCodePreviewController: ZMViewController {

    var fileModel: ZLGithubGistFileModel?
    
    var htmlStr: String?
    
    lazy var linkRouter: ZLGithubMarkDownLinkRouter = {
        let linkRouter = ZLGithubMarkDownLinkRouter(needDealWithRelativePath: false,
                                                    needDealWithAboutBlank: false,
                                                    needDealWithCommonURL: false,
                                                    forbidSamePathNavigation: true)
        return linkRouter
    }()
   

    @objc init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: ZLUserInterfaceStyleChange_Notification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLUserInterfaceStyleChange_Notification, object: nil)
            
        self.sendQueryContentRequest()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if ZLDeviceInfo.isIPhone() {
            guard let appdelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            appdelegate.allowRotation = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if ZLDeviceInfo.isIPhone() {
            guard let appdelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            appdelegate.allowRotation = false
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        super.viewWillTransition(to: size, with: coordinator)

        if ZLDeviceInfo.isIPhone() {
            guard let navigationVC: ZMNavigationController = self.navigationController as? ZMNavigationController else {
                return
            }
            if size.height > size.width {
                // 横屏变竖屏
                self.isZmNavigationBarHidden = false
                navigationVC.forbidGestureBack = false
            } else {
                self.isZmNavigationBarHidden = true
                navigationVC.forbidGestureBack = true
            }
        }
    }

    override func setupUI() {
        super.setupUI()

        self.title = fileModel?.filename
        
        self.contentView.addSubview(webView)
        webView.snp.makeConstraints({(make) in
            make.edges.equalToSuperview()
        })
    }
    
    func openURL(url: URL?) {
        if let realurl = url {
            ZLUIRouter.openURL(url: realurl)
        }
    }
    
    
    // view
    lazy var webView: WKWebView = {
        let wv = WKWebView(frame: CGRect.init())
        wv.backgroundColor = UIColor.clear
        wv.scrollView.backgroundColor = UIColor.clear
        wv.uiDelegate = self
        wv.navigationDelegate = self
        return wv
    }()
}

// MARK: - Action
extension ZLGistCodePreviewController {
    @objc func onNotificationArrived(notification: Notification) {
        if let html = self.htmlStr {
            self.startLoadCode(codeHtml: html)
        }
    }
}

// MARK: - Request
extension ZLGistCodePreviewController {

    func sendQueryContentRequest() {
        
        guard let fileModel else { return }
        
        ZLProgressHUD.show()
        
        let code = "```\(fileModel.language.lowercased())\n\(fileModel.content)\n```"
        
        ZLServiceManager.sharedInstance.additionServiceModel?.renderCodeToMarkdown(withCode: code, serialNumber: NSString.generateSerialNumber(), completeHandle: {[weak self](resultModel: ZLOperationResultModel) in
            
            guard let self = self else { return }
            
            ZLProgressHUD.dismiss()
            
            guard resultModel.result,
                  let data: String = resultModel.data as? String else {
                return
            }
            
            let code = "<article class=\"markdown-body entry-content container-lg\" itemprop=\"text\">\(data)</article>"
            
            self.htmlStr = code
            self.startLoadCode(codeHtml: code)
            
        })
        
        
    }


    func startLoadCode(codeHtml: String) {

        let htmlURL: URL? = Bundle.main.url(forResource: "github_style", withExtension: "html")

        let cssURL: URL?

        if #available(iOS 12.0, *) {
            if getRealUserInterfaceStyle() == .light {
                cssURL = Bundle.main.url(forResource: "github_style", withExtension: "css")
            } else {
                cssURL = Bundle.main.url(forResource: "github_style_dark", withExtension: "css")
            }
        } else {
            cssURL = Bundle.main.url(forResource: "github_style", withExtension: "css")
        }

        if let url = htmlURL {

            do {
                let htmlStr = try String.init(contentsOf: url)
                let newHtmlStr = NSMutableString.init(string: htmlStr)

                let range1 = (newHtmlStr as NSString).range(of: "<style>")
                if  range1.location != NSNotFound {
                    newHtmlStr.insert("<meta name=\"viewport\" content=\"width=device-width\"/>", at: range1.location)
                }

                if let tmoCSSURL = cssURL {
                    let cssStr = try String.init(contentsOf: tmoCSSURL)
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
        }
        ZLProgressHUD.dismiss()
    }
}

extension ZLGistCodePreviewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {

    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {

    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {

    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let urlStr = navigationAction.request.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }
        
        if navigationAction.navigationType == .linkActivated {
            if  linkRouter.dealWithLink(urlStr: urlStr) {
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
    }

}
