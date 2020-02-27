//
//  ZLRepoFooterInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import MarkdownView
import WebKit

class ZLRepoFooterInfoView: ZLBaseView {

    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    var markdownView : MarkdownView!
    
    required init?(coder: NSCoder) {
        self.markdownView = MarkdownView()
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.refreshButton.layer.cornerRadius = 5.0
        self.refreshButton.layer.borderColor = UIColor.lightGray.cgColor
        self.refreshButton.layer.borderWidth = 1.0
        
        self.markdownView?.isScrollEnabled = false
        self.addSubview(self.markdownView)
        self.markdownView.snp.makeConstraints { (make) in
            make.top.equalTo(self.progressView.snp_bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func loadMarkdown(markDown: String)
    {
        self.markdownView.load(markdown: markDown, enableImage: true)
        
        guard let webView : WKWebView = self.markdownView.value(forKey: "webView") as? WKWebView else
        {
            return
        }
        
        webView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    
    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentSize"
        {
            
        }
        
    }
    
}
