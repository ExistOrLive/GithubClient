//
//  ZLPullRequestCommentTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/26.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import WebKit

protocol ZLPullRequestCommentTableViewCellDelegate : NSObjectProtocol{
    func getActorAvatarUrl() -> String
    func getActorName() -> String
    func getTime() -> String
    func getCommentHtml() -> String
    func getCommentText() -> String
    
    func onAvatarButtonClicked() -> Void
    func didRowHeightChange(height: CGFloat)
    func didClickLink(url: URL)
}

class ZLPullRequestCommentTableViewCell: UITableViewCell {
    
    fileprivate weak var delegate: ZLPullRequestCommentTableViewCellDelegate?
        
    private var cacheHtml: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        webView.configuration.userContentController.removeAllUserScripts()
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "onHTMLHeightChange")
    }
    
    func setUpUI(){
        
        self.selectionStyle = .none
        
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(backView)
        
        backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        }
        
        backView.addSubview(avatarButton)
        avatarButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
       
        backView.addSubview(actorLabel)
        actorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarButton.snp.right).offset(10)
            make.top.equalTo(avatarButton)
        }
        
        backView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarButton.snp.right).offset(10)
            make.bottom.equalTo(avatarButton)
        }
        
        backView.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(avatarButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
        }

        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLSeperatorLineColor")
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalTo(backView.snp.top)
            make.left.equalToSuperview().offset(40)
            make.width.equalTo(1)
        }
    }
    
    func fillWithData(data : ZLPullRequestCommentTableViewCellDelegate) {
        self.delegate = data
        avatarButton.sd_setImage(with: URL(string: data.getActorAvatarUrl()), for: .normal, placeholderImage: UIImage(named: "default_avatar"))
        actorLabel.text = data.getActorName()
        timeLabel.text = data.getTime()
        webView.loadHTMLString(data.getCommentHtml(), baseURL: nil)
    }
    
    @objc func onAvatarButtonClicked(){
        self.delegate?.onAvatarButtonClicked()
    }
    
    // MARK: scriptHandler
    private lazy var scriptHandler: ZLPullRequestCommentScriptMessageHandler = {
        let handler = ZLPullRequestCommentScriptMessageHandler()
        handler.cell = self
        return handler
    }()
    
    
    // MARK: View
    
    private lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = UIColor(named: "ZLIssueCommentCellColor")
        return backView
    }()
    
    private lazy var avatarButton: UIButton = {
        let tmpAvatarButton = UIButton(type: .custom)
        tmpAvatarButton.cornerRadius = 20
        tmpAvatarButton.addTarget(self, action: #selector(onAvatarButtonClicked), for: .touchUpInside)
        return tmpAvatarButton
    }()
    
    private lazy var actorLabel: UILabel = {
        let label1 = UILabel()
        label1.textColor = UIColor(named: "ZLLabelColor1")
        label1.font = UIFont(name: Font_PingFangSCMedium, size: 15)
        return label1
    }()
    
    private lazy var timeLabel: UILabel = {
        let label2 = UILabel()
        label2.textColor = UIColor(named: "ZLLabelColor2")
        label2.font = UIFont(name: Font_PingFangSCRegular, size: 12)
        return label2
    }()
    
    private lazy var webView: WKWebView = {
        let userContentController = WKUserContentController()
        // 注册回调 传入的scriptHandler是强引用
        userContentController.add(scriptHandler,name: "onHTMLHeightChange")
        // 在HTML页面加载前插入脚本
        let script = WKUserScript(source: ZLPullRequestCommentTableViewCell.getHTMLHeightScript, injectionTime:.atDocumentStart , forMainFrameOnly: false)
        userContentController.addUserScript(script)
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.userContentController = userContentController
        
        let webView = WKWebView(frame: CGRect.zero, configuration: webViewConfig)
        webView.navigationDelegate = self
        webView.scrollView.backgroundColor = UIColor.clear
        webView.backgroundColor = UIColor.clear
        webView.scrollView.isScrollEnabled = false
        return webView
    }()
        
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
                                         
                                         window.setInterval("getHTMLHeight()",500)
                                      """#
}

extension ZLPullRequestCommentTableViewCell : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url {
                self.delegate?.didClickLink(url: url)
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//      let script = "let array = document.getElementsByTagName('html');array[0].offsetHeight"
//
//      webView.evaluateJavaScript(script) { [weak self] result, error in
//        if let _ = error { return }
//
//        if let height = result as? CGFloat {
//            self?.delegete?.didRowHeightChange(height: height + 110)
//        }
//      }
    }
}

class ZLPullRequestCommentScriptMessageHandler: NSObject, WKScriptMessageHandler {
    
    weak var cell: ZLPullRequestCommentTableViewCell?
    
    deinit{
        print("ZLIssueCommentScriptMessageHandler deinit")
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // height change
        if "onHTMLHeightChange" == message.name {
            guard let height = message.body as? CGFloat else {
                return
            }
            cell?.delegate?.didRowHeightChange(height: height + 110)
        }
    }
}

