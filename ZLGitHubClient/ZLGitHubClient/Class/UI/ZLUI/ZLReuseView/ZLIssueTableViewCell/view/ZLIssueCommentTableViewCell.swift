//
//  ZLIssueCommentTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/16.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import WebKit

protocol ZLIssueCommentTableViewCellDelegate : NSObjectProtocol{
    func getActorAvatarUrl() -> String
    func getActorName() -> String
    func getTime() -> String
    func getCommentHtml() -> String
    func getCommentText() -> String
}

class ZLIssueCommentTableViewCell: UITableViewCell {
    
    var avatarButton : UIButton!
    var actorLabel : UILabel!
    var timeLabel : UILabel!
    var contentWebView : WKWebView!
    
    var tmpHtml : String?
    
    deinit{
        // self.contentWebView.scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    func setUpUI(){
        
        self.selectionStyle = .none
        
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        let backView = UIView()
        backView.backgroundColor = UIColor(named: "ZLIssueCommentCellColor")
        self.contentView.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        }
        
        let tmpAvatarButton = UIButton(type: .custom)
        tmpAvatarButton.cornerRadius = 20
        backView.addSubview(tmpAvatarButton)
        tmpAvatarButton.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        avatarButton = tmpAvatarButton
        
        let label1 = UILabel()
        label1.textColor = UIColor(named: "ZLLabelColor1")
        label1.font = UIFont(name: Font_PingFangSCMedium, size: 15)
        backView.addSubview(label1)
        label1.snp.makeConstraints { (make) in
            make.left.equalTo(avatarButton.snp.right).offset(10)
            make.top.equalTo(avatarButton)
        }
        actorLabel = label1
        
        let label2 = UILabel()
        label2.textColor = UIColor(named: "ZLLabelColor2")
        label2.font = UIFont(name: Font_PingFangSCRegular, size: 12)
        backView.addSubview(label2)
        label2.snp.makeConstraints { (make) in
            make.left.equalTo(avatarButton.snp.right).offset(10)
            make.bottom.equalTo(avatarButton)
        }
        timeLabel = label2
        
        let webview = WKWebView()
        webview.scrollView.backgroundColor = UIColor.clear
        webview.backgroundColor = UIColor.clear
        webview.uiDelegate = self
        webview.navigationDelegate = self
        webview.scrollView.maximumZoomScale = 1
        webview.scrollView.minimumZoomScale  = 1
        webview.scrollView.isScrollEnabled = false
        backView.addSubview(webview)
        webview.snp.makeConstraints { (make) in
            make.top.equalTo(avatarButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
        contentWebView = webview
       // webview.scrollView.addObserver(self, forKeyPath: "contentSize", options: [.new], context: nil)
        
        
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
    
    
    func fillWithData(data : ZLIssueCommentTableViewCellDelegate) {
        avatarButton.sd_setImage(with: URL(string: data.getActorAvatarUrl()), for: .normal, placeholderImage: UIImage(named: "default_avatar"))
        actorLabel.text = data.getActorName()
        timeLabel.text = data.getTime()
        
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
                
                if cssURL != nil {
                    let cssStr = try String.init(contentsOf: cssURL!)
                    let range = (newHtmlStr as NSString).range(of:"</style>")
                    if  range.location != NSNotFound{
                        newHtmlStr.insert(cssStr, at: range.location)
                    }
                }
                let range = (newHtmlStr as NSString).range(of:"</body>")
                if  range.location != NSNotFound{
                    newHtmlStr.insert("<article class=\"markdown-body entry-content container-lg\" itemprop=\"text\">\(data.getCommentHtml())</article>", at: range.location)
                }
                
                if tmpHtml != newHtmlStr as String {
//                    contentWebView.scrollView.contentSize = CGSize.zero
                    tmpHtml = newHtmlStr as String
                    contentWebView.loadHTMLString(newHtmlStr as String, baseURL: nil)
                }
            }catch{
               
            }
        }
    }
    
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//        if keyPath == "contentSize"{
//            guard let size : CGSize = change?[NSKeyValueChangeKey.newKey] as? CGSize else{
//                return
//            }
//
//            if contentWebView.frame.size.height != size.height {
//                contentWebView.snp.updateConstraints { (make) in
//                    make.height.equalTo(size.height)
//                }
//                if size.height != 0{
//                    var view : UIView? = self
//                    while(!(view is UITableView) && view != nil) {
//                        view = view?.superview
//                    }
//                    if let tableView = view as? UITableView{
//                        tableView.reloadData()
//                    }
//                }
//
//            }
//        }
//
//    }
    
}

extension ZLIssueCommentTableViewCell : WKNavigationDelegate, WKUIDelegate {
        
}
