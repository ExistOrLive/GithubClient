//
//  ZLRepoCodePreview4Controller.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/10/15.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

import UIKit
import WebKit

/**
 *  从 GitHub 网页代码部分显示
 */

class ZLRepoCodePreview4Controller: ZLBaseViewController {
    
    // model
    let contentModel : ZLGithubContentModel
    let repoFullName : String
    let branch : String
    
    var htmlStr : String?
    // view
    var webView : WKWebView?
    
    init(repoFullName: String, contentModel : ZLGithubContentModel, branch : String)
    {
        self.repoFullName = repoFullName
        self.contentModel = contentModel
        self.branch = branch
        super.init(nibName:nil, bundle:nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        
        self.sendQueryContentRequest()

    }
    
    func setUpUI(){
        self.title = self.contentModel.path
        
        self.zlNavigationBar.backButton.isHidden = false
        let button = UIButton.init(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: ZLIconFont.More.rawValue,
                                                     attributes: [.font:UIFont.zlIconFont(withSize: 30),
                                                                  .foregroundColor:UIColor.label(withName:"ICON_Common")]),
                                  for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)
        
        self.zlNavigationBar.rightButton = button
        
    }
    
    
    func switchToWebVC() {
        self.switchToWebVc(urlString: self.contentModel.html_url)
    }
    
    func switchToWebVc(urlString : String){
        if let url = URL.init(string: urlString),
           let vc = ZLUIRouter.getVC(key: ZLUIRouter.WebContentController, params: ["requestURL":url]){
            if var viewControllers = self.navigationController?.viewControllers,
               !viewControllers.isEmpty {
                viewControllers[viewControllers.count - 1] = vc
                self.navigationController?.setViewControllers(viewControllers, animated: false)
            }
        }
    }
    
    @objc func onMoreButtonClick(button : UIButton) {
        guard let url = URL(string: self.contentModel.html_url) else {
            return
        }
        button.showShareMenu(title: url.absoluteString, url: url, sourceViewController: self )
    }
    
    
}



extension ZLRepoCodePreview4Controller {
    
    func sendQueryContentRequest(){
        
        SVProgressHUD.show()
        
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepositoryFileContent(withHTMLURL: self.contentModel.html_url,
                                                                                   branch: self.branch,
                                                                                   serialNumber: NSString.generateSerialNumber())
        {[weak weakSelf = self](resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false{
                SVProgressHUD.dismiss()
                weakSelf?.switchToWebVC()
                return
            }

            guard let data : String = resultModel.data as? String else{
                
                SVProgressHUD.dismiss()
                weakSelf?.switchToWebVC()
                return;
            }

            let code = "<article class=\"markdown-body entry-content container-lg\" itemprop=\"text\">\(data)</article>"
            
            weakSelf?.startLoadCode(codeHtml: code)
        }
    }
    
    func startLoadCode(codeHtml : String){
        
        let htmlURL: URL? = Bundle.main.url(forResource: "github_style", withExtension: "html")
        
        if let url = htmlURL {
            
            do {
                let htmlStr = try String.init(contentsOf: url)
                let newHtmlStr = NSMutableString.init(string: htmlStr)
                
                let range = (newHtmlStr as NSString).range(of:"</body>")
                if  range.location != NSNotFound{
                    newHtmlStr.insert(codeHtml, at: range.location)
                }
                
                let controller = WKUserContentController()
                let configuration = WKWebViewConfiguration()
                configuration.userContentController = controller
                
                let wv = WKWebView(frame: CGRect.init(), configuration: configuration)
                
                self.contentView.addSubview(wv)
                wv.snp.makeConstraints({(make) in
                    make.edges.equalToSuperview()
                })
                wv.uiDelegate = self
                wv.navigationDelegate = self
                wv.loadHTMLString(newHtmlStr as String, baseURL: nil)
                
            }catch{
                ZLToastView.showMessage("load Code index html failed");
                SVProgressHUD.dismiss()
            }
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
    
    func getFileType(fileExtension: String) -> String {
        let dic = ["cpp":"c++",
                   "m":"objc",
                   "mm":"objc",
                   "h":"c",
                   "hpp":"c++"]
        return dic[fileExtension] ?? fileExtension
    }
}


extension ZLRepoCodePreview4Controller : WKUIDelegate,WKNavigationDelegate
{
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void)
    {
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void)
    {
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void)
    {
        
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    }
       
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        if let urlStr = self.contentModel.download_url {
            
            let baseURLStr = (URL.init(string: urlStr) as NSURL?)?.deletingLastPathComponent?.absoluteString
            let addBaseScript = "let a = '\(baseURLStr ?? "")';let array = document.getElementsByTagName('img');for(i=0;i<array.length;i++){let item=array[i];if(item.getAttribute('src').indexOf('http') == -1){item.src = a + item.getAttribute('src');}}"
            
            webView.evaluateJavaScript(addBaseScript) { (result : Any?, error : Error?) in
                
            }
        }
        
        SVProgressHUD.dismiss()
        
    }
    
    
}
