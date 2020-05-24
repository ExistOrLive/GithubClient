//
//  ZLRepoFooterInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import WebKit

@objc protocol ZLRepoFooterInfoViewDelegate : NSObjectProtocol {
    
    func onRefreshReadmeAction() -> Void
    
}


class ZLRepoFooterInfoView: ZLBaseView {
    
    weak var delegate : ZLRepoFooterInfoViewDelegate?

    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    var markdownView : MarkdownView!
        
    required init?(coder: NSCoder) {
        self.markdownView = MarkdownView()
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.refreshButton.setTitle(ZLLocalizedString(string: "refresh", comment: "刷新"), for: .normal)
        
        self.markdownView?.isScrollEnabled = true
        self.addSubview(self.markdownView)
        self.markdownView.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.top.equalTo(self.progressView.snp_bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func loadMarkdown(markDown: String, baseUrl: String?)
    {
        self.stopLoad()
    
        self.progressView.isHidden = false
        self.progressView.setProgress(0.3, animated: false)
        
        self.markdownView.load(markdown: markDown,baseUrl:baseUrl, enableImage: true)
        
        self.markdownView.onRendered = { (height:CGFloat) in
            
            self.markdownView.snp.updateConstraints { (make) in
                    make.height.equalTo(height + 40)
            }
            self.markdownView.webView?.scrollView.removeObserver(self, forKeyPath: "contentSize")
            
            UIView.animate(withDuration: 0.3, animations: { () in
                self.progressView.setProgress(1.0, animated: false) }, completion:
                { (result : Bool) in
                    self.progressView.isHidden = true
            })
            
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
    
    
    @IBAction func onRefreshButtonClicked(_ sender: Any) {
        if self.delegate?.responds(to: #selector(ZLRepoFooterInfoViewDelegate.onRefreshReadmeAction)) ?? false {
            self.delegate?.onRefreshReadmeAction()
        }
    }
    
}
