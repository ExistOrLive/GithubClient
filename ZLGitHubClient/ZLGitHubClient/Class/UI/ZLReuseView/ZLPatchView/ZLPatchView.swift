//
//  ZLPatchView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/19.
//  Copyright © 2025 ZM. All rights reserved.
//

import UIKit
import WebKit


class ZLPatchView: UIView {
    
    var patchStr: String = ""
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func loadData() {
        guard let url = Bundle.main.url(forResource: "gitpatchV3", withExtension: "html") else {
            return
        }
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
    
    func setPatchStr(patchStr: String) {
        var patch = patchStr
        patch = patch.replacingOccurrences(of: "`", with: "\\`")
        patch = patch.replacingOccurrences(of: "$", with: "\\$")
        self.patchStr = patch
        webView.evaluateJavaScript(renderDiffContentScript())
    }
    
    func renderDiffContentScript() -> String {
        return """
        render(`\(patchStr)`,\(isLight ? "false" : "true"));
        """
    }
    
    var isLight: Bool {
        if #available(iOS 12.0, *) {
            return getRealUserInterfaceStyle() == .light
        } else {
            return true
        }
    }
    
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        webView.scrollView.backgroundColor = UIColor.clear
        webView.backgroundColor = UIColor.clear
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        return webView
    }()
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // 外观模式切换
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
                webView.evaluateJavaScript(renderDiffContentScript())
            }
        }
    }
}


extension ZLPatchView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(renderDiffContentScript())
    }
}

