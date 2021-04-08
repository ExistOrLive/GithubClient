//
//  ZLIssueCommentTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/16.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import WebKit

class ZLIssueCommentTableViewCellData: ZLGithubItemTableViewCellData {
    
    typealias IssueCommentData = IssueInfoQuery.Data.Repository.Issue.TimelineItem.Node.AsIssueComment
    
    let data : IssueCommentData
    
    let webView : WKWebView = WKWebView()
    
    var webViewHeight : CGFloat = 0
    
    deinit {
        webView.scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    init(data : IssueCommentData) {
        self.data = data
        super.init()
        
        webView.navigationDelegate = self
        webView.scrollView.backgroundColor = UIColor.clear
        webView.backgroundColor = UIColor.clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: [.new,.old], context: nil)
        
        self.loadWebView()
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        super.bindModel(targetModel, andView: targetView)
        if let cell : ZLIssueCommentTableViewCell = targetView as? ZLIssueCommentTableViewCell {
            cell.fillWithData(data:self)
        }
    }
    
    
    override func getCellReuseIdentifier() -> String {
        return "ZLIssueCommentTableViewCell";
    }
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    override func clearCache() {
        super.clearCache()
        self.loadWebView()
    }
    
    
    func loadWebView() {
        
        let htmlURL: URL? = Bundle.main.url(forResource: "github_style", withExtension: "html")
        
        let cssURL : URL?
        
        if #available(iOS 12.0, *) {
            if getRealUserInterfaceStyle() == .light{
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
                
                let range1 = (newHtmlStr as NSString).range(of:"<style>")
                if  range1.location != NSNotFound{
                    newHtmlStr.insert("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no\"/>", at: range1.location)
                }
                
                if cssURL != nil {
                    let cssStr = try String.init(contentsOf: cssURL!)
                    let range = (newHtmlStr as NSString).range(of:"</style>")
                    if  range.location != NSNotFound{
                        newHtmlStr.insert(cssStr, at: range.location)
                    }
                }
                let range = (newHtmlStr as NSString).range(of:"</body>")
                if  range.location != NSNotFound{
                    newHtmlStr.insert("<article class=\"markdown-body entry-content container-lg\" itemprop=\"text\">\(data.bodyHtml)</article>", at: range.location)
                }
                webView.loadHTMLString(newHtmlStr as String, baseURL: nil)
                
            }catch{
               
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "contentSize"{
            guard let size : CGSize = change?[NSKeyValueChangeKey.newKey] as? CGSize else{
                return
            }
            
            self.webViewHeight = size.height
            
            guard let oldSize : CGSize = change?[NSKeyValueChangeKey.oldKey] as? CGSize else {
                return
            }
            
            if oldSize.height != size.height && webView.superview != nil {
                self.super?.getEvent(nil, fromSubViewModel: self)
            }
        }

    }

}

extension ZLIssueCommentTableViewCellData : ZLIssueCommentTableViewCellDelegate {
    func getCommentWebView() -> WKWebView {
        return webView
    }
    
    func getActorAvatarUrl() -> String {
        return data.author?.avatarUrl ?? ""
    }
    
    func getActorName() -> String {
        return data.author?.login ?? ""
    }
    
    func getTime() -> String {
        return NSDate.getLocalStrSinceCurrentTime(withGithubTime: data.publishedAt ?? "" )
    }
    
    func getCommentHtml() -> String {
        return data.bodyHtml
    }
    
    func getCommentText() -> String {
        return data.bodyText
    }
    
    func getCommentWebViewHeight() -> CGFloat {
        return webViewHeight
    }
    
    
}

extension ZLIssueCommentTableViewCellData : WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url{
                ZLUIRouter.openURL(url: url)
            }
        }
        decisionHandler(.cancel)
    }
}
