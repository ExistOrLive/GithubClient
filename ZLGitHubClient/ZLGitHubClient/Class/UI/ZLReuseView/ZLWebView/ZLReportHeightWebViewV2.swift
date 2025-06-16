//
//  ZLReportHeightWebViewV2.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/13.
//  Copyright © 2025 ZM. All rights reserved.
//

import Foundation
import WebKit

class ZLReportHeightWebViewV2: WKWebView {


    private func addAppStateObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc private func appWillEnterForeground() {
        self.reload()
    }

  
    var cacheHeight: CGFloat?
    
    var cacheStr: String = ""
    
    var baseURL: URL?
    
    var reportHeightBlock: (() -> Void)?
    
    
    lazy var scriptHandler: ZLReportHeightScriptMessageHandler = {
        let scriptHandler = ZLReportHeightScriptMessageHandler()
        scriptHandler.reportHeight = { [weak self] height in
            guard let self else { return }
            if let cacheHeight = self.cacheHeight, cacheHeight == height {
                return
            }
            self.cacheHeight = height
            self.reportHeightBlock?()
            
        }
        return scriptHandler
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        configuration.userContentController.removeAllUserScripts()
        configuration.userContentController.removeScriptMessageHandler(forName: "onHTMLHeightChange")
    }
    
    init(frame: CGRect) {
        let userContentController = WKUserContentController()
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.userContentController = userContentController
        super.init(frame: frame,configuration: webViewConfig)
        addAppStateObserver()
        
        // 注册回调 传入的scriptHandler是强引用
        userContentController.add(scriptHandler, name: "onHTMLHeightChange")
        // 在HTML页面加载前插入脚本
        let script = WKUserScript(source: Self.getHTMLHeightScript, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        userContentController.addUserScript(script)
        
        
    }
    
    
    func loadHTML(_ string: String, baseURL: URL?) {
        cacheHeight = nil
        cacheStr = string
        super.loadHTMLString(string, baseURL: baseURL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // JS脚本监控HTML高度，0.5秒检查一次，如果变化通知原生cell更新
    static let getHTMLHeightScript = #"""
                                     var currentHeight = 0

                                     function getHTMLHeight() {
                                         let array = document.getElementsByTagName('html')
                                         let offsetHeight = array[0].offsetHeight
                                         if(currentHeight != offsetHeight) {
                                             currentHeight = offsetHeight
                                             window.webkit.messageHandlers.onHTMLHeightChange.postMessage(offsetHeight)
                                         }
                                     }
                                     
                                     window.getHTMLHeight()
                                     window.setInterval("getHTMLHeight()",500)
                                     """#
}
