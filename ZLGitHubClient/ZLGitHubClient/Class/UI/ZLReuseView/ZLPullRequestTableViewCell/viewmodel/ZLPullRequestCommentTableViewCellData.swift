//
//  ZLPullRequestCommentTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/26.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import WebKit
import ZLGitRemoteService
import ZMMVVM

class ZLPullRequestCommentTableViewCellData: ZMBaseTableViewCellViewModel {

    typealias CommentData = PrInfoQuery.Data.Repository.PullRequest.TimelineItem.Node.AsIssueComment

    let data: CommentData

    private var cacheHtml: String?
    private var cellHeight: CGFloat = 110
    
    lazy var webView: ZLReportHeightWebView = {
        let webView = ZLReportHeightWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 30, height: UIScreen.main.bounds.size.height))
        webView.navigationDelegate = self
        webView.scrollView.backgroundColor = UIColor.clear
        webView.backgroundColor = UIColor.clear
        webView.scrollView.isScrollEnabled = false
        webView.reportHeightBlock = { [weak self] in
            
            guard let self ,
                  let webViewHeight = self.webView.cacheHeight,
                  webViewHeight + 110 != self.cellHeight else {
                return
            }
            
            self.cellHeight =  webViewHeight + 110
            (self.zm_superViewModel as? ZMBaseTableViewContainerProtocol)?.tableView.performBatchUpdates({
                
            })
        }
        return webView
    }()

    init(data: CommentData, cellHeight: CGFloat? ) {
        self.data = data
        super.init()
        if let cellHeight = cellHeight {
            self.cellHeight = cellHeight
        }
        webView.loadHTMLString(self.getCommentHtml(), baseURL: nil)
    }
    

    override var zm_cellReuseIdentifier: String {
        return "ZLPullRequestCommentTableViewCell"
    }

    override  var zm_cellHeight: CGFloat {
        return cellHeight
    }

    override func zm_clearCache() {
        super.zm_clearCache()
        self.cacheHtml = nil
        self.webView.loadHTMLString(self.getCommentHtml(), baseURL: nil)
    }

    func getHtmlStr() -> String {

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
                    let bodyHtml = data.bodyHtml.isEmpty ? ZLLocalizedString(string: "NoDescription", comment: "") : data.bodyHtml
                    newHtmlStr.insert("<article class=\"markdown-body entry-content container-lg\" itemprop=\"text\">\(bodyHtml)</article>", at: range.location)
                }
                return newHtmlStr as String

            } catch {
                print(error)
            }
            return data.bodyHtml
        } else {
            return data.bodyHtml
        }
    }

}

extension ZLPullRequestCommentTableViewCellData: ZLPullRequestCommentTableViewCellDelegate {

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
        if let html = cacheHtml {
            return html
        } else {
            let html = getHtmlStr()
            cacheHtml = html
            return html
        }
    }

    func getCommentText() -> String {
        return data.bodyText
    }

    func onAvatarButtonClicked() {
        if let login = data.author?.login, let vc = ZLUIRouter.getUserInfoViewController(loginName: login) {
            self.zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func didRowHeightChange(height: CGFloat) {
        if height == cellHeight {
            return
        }
        cellHeight = height
        (self.zm_superViewModel as? ZMBaseTableViewContainerProtocol)?.tableView.performBatchUpdates({
            
        })
       // self.super?.getEvent(nil, fromSubViewModel: self)
    }

    func didClickLink(url: URL) {
        ZLUIRouter.openURL(url: url)
    }

}

extension ZLPullRequestCommentTableViewCellData: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url {
                ZLUIRouter.openURL(url: url)
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }

    }
}
