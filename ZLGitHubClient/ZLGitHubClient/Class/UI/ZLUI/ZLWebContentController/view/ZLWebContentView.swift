//
//  ZLWebContentView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/28.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import WebKit

class ZLWebContentView: ZLBaseView {

    @objc @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    @objc @IBOutlet weak var titleLabel: UILabel!
    
    @objc @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var collectionView: UIView!
    
    @objc var webView : WKWebView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.topViewHeightConstraint.constant = self.topViewHeightConstraint.constant + ZLStatusBarHeight
        
        let webViewConfig = WKWebViewConfiguration.init()
        let webView : WKWebView = WKWebView.init(frame: self.collectionView.bounds,configuration: webViewConfig)
        webView.autoresizingMask = UIViewAutoresizing.init(rawValue: UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue)
        
        self.collectionView.addSubview(webView)
        self.webView = webView

    }
    
}
