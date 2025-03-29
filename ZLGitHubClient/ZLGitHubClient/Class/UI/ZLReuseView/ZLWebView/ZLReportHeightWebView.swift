//
//  ZLReportHeightWebView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/3/28.
//  Copyright © 2025 ZM. All rights reserved.
//

import Foundation
import WebKit

class ZLReportHeightWebView: WKWebView {
    
    var cacheHeight: CGFloat?
    
    var reportHeightBlock: (() -> Void)?
    
    
    lazy var scriptHandler: ZLReportHeightScriptMessageHandler = {
        let scriptHandler = ZLReportHeightScriptMessageHandler()
        scriptHandler.reportHeight = { [weak self] height in
            guard let self else { return }
            print("dasdasdas \(height)")
            if let cacheHeight = self.cacheHeight, cacheHeight == height {
                return
            }
            self.cacheHeight = height
            self.reportHeightBlock?()
            
        }
        return scriptHandler
    }()
    
    deinit {
        configuration.userContentController.removeAllUserScripts()
        configuration.userContentController.removeScriptMessageHandler(forName: "onHTMLHeightChange")
    }
    
    init(frame: CGRect) {
        let userContentController = WKUserContentController()
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.userContentController = userContentController
        super.init(frame: frame,configuration: webViewConfig)
        
        // 注册回调 传入的scriptHandler是强引用
        userContentController.add(scriptHandler, name: "onHTMLHeightChange")
        // 在HTML页面加载前插入脚本
        let script = WKUserScript(source: Self.getHTMLHeightScript, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        userContentController.addUserScript(script)
    }
    
    override func loadHTMLString(_ string: String, baseURL: URL?) -> WKNavigation? {
        cacheHeight = nil
        return super.loadHTMLString(string, baseURL: baseURL)
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



class ZLReportHeightScriptMessageHandler: NSObject, WKScriptMessageHandler {
    
    var reportHeight: ((CGFloat) -> Void)?
    
    deinit {
        print("ZLReportHeightScriptMessageHandler deinit")
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // height change
        if "onHTMLHeightChange" == message.name {
            guard let height = message.body as? CGFloat else {
                return
            }
            reportHeight?(height)
        }
    }
    
}
