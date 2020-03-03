//
//  ZLRepoFooterInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
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
            make.height.equalTo(20)
            make.top.equalTo(self.progressView.snp_bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func loadMarkdown(markDown: String)
    {
        self.stopLoad()
    
        self.markdownView.load(markdown: markDown, enableImage: true)
        
        self.markdownView.onRendered = { (height:CGFloat) in
            self.progressView.setProgress(1.0, animated: true)
            self.markdownView.snp.updateConstraints { (make) in
                    make.height.equalTo(height + 40)
            }
            self.markdownView.webView?.scrollView.removeObserver(self, forKeyPath: "contentSize")
        }

        self.markdownView.webView?.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func stopLoad()
    {
        if self.markdownView.webView?.isLoading ?? false
        {
            self.markdownView.webView?.stopLoading()
            self.markdownView.webView?.scrollView.removeObserver(self, forKeyPath: "contentSize")
        }
        self.markdownView.webView?.removeFromSuperview()
        self.markdownView.webView = nil
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentSize"
        {
//            guard let size : CGSize = change?[.newKey] as? CGSize else
//            {
//                return
//            }
//
//            self.markdownView.snp.updateConstraints { (make) in
//                make.height.equalTo(size.height + 10)
//            }
            
            if self.markdownView.webView != nil
            {
                let script = "document.body.scrollHeight;"
                self.markdownView.webView?.evaluateJavaScript(script) { [weak self] result, error in
                    if let _ = error { return }
                    if let height = result as? CGFloat {
                        self?.markdownView.snp.updateConstraints { (make) in
                                make.height.equalTo(height + 40)
                        }
                    }
                }
            }
          
            
        }
        
    }
    
}
