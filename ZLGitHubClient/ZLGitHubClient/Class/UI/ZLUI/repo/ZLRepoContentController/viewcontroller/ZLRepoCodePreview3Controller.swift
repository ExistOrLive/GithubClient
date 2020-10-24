//
//  ZLRepoCodePreview3Controller.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/14.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import WebKit


/**
  *  利用 REST API 获取 md 内容 ； 代码使用markdown接口渲染
 */

class ZLRepoCodePreview3Controller: ZLBaseViewController {
    
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
        
        let fileExtension = (URL.init(string: self.contentModel.name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) ?? "") as NSURL?)?.pathExtension ?? ""
        if(fileExtension.lowercased() == "md" || fileExtension.lowercased() == "markdown") {
            self.sendQueryContentRequest()
        } else {
            self.sendRenderMakrdownRequest()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let appdelegate : AppDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        appdelegate.allowRotation = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        guard let appdelegate : AppDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        appdelegate.allowRotation = false
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let navigationVC : ZLBaseNavigationController = self.navigationController as? ZLBaseNavigationController else {
            return
        }
        if size.height > size.width {
            // 横屏变竖屏
            self.setZLNavigationBarHidden(false)
            navigationVC.forbidGestureBack = false
        } else {
            self.setZLNavigationBarHidden(true)
            navigationVC.forbidGestureBack = true
        }
    }
    
    func setUpUI(){
        self.title = self.contentModel.path
        
        self.zlNavigationBar.backButton.isHidden = false
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "run_more"), for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)
        
        self.zlNavigationBar.rightButton = button
        
        
        let wv = WKWebView(frame: CGRect.init())
        
        self.contentView.addSubview(wv)
        wv.snp.makeConstraints({(make) in
            make.edges.equalToSuperview()
        })
        wv.uiDelegate = self
        wv.navigationDelegate = self
        
        self.webView = wv;
    }
    
    
    func switchToWebVC() {
        let webContentVC = ZLWebContentController.init()
        webContentVC.requestURL = URL.init(string: self.contentModel.html_url)
        var viewControllers = self.navigationController?.viewControllers
        if viewControllers != nil {
            viewControllers![viewControllers!.count - 1] = webContentVC
            self.navigationController?.setViewControllers(viewControllers!, animated: false)
        }
        
    }
    
    func openURL(url : URL?){
        let webContentVC = ZLWebContentController.init()
        webContentVC.requestURL = url
        self.navigationController?.pushViewController(webContentVC, animated: true)
    }
    
    @objc func onMoreButtonClick(button : UIButton) {
        let alertVC = UIAlertController.init(title: self.contentModel.path, message: nil, preferredStyle: .actionSheet)
        let alertAction1 = UIAlertAction.init(title: "View in Github", style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            let webContentVC = ZLWebContentController.init()
            webContentVC.requestURL = URL.init(string: self.contentModel.html_url)
            self.navigationController?.pushViewController(webContentVC, animated: true)
        }
        let alertAction2 = UIAlertAction.init(title: "Open in Safari", style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            let url =  URL.init(string: self.contentModel.html_url)
            if url != nil {
                UIApplication.shared.open(url!, options: [:], completionHandler: {(result : Bool) in})
            }
        }
        
        let alertAction3 = UIAlertAction.init(title: "Share", style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            let url =  URL.init(string: self.contentModel.html_url)
            if url != nil {
                let activityVC = UIActivityViewController.init(activityItems: [url!], applicationActivities: nil)
                activityVC.excludedActivityTypes = [.message,.mail,.openInIBooks,.markupAsPDF]
                self.present(activityVC, animated: true, completion: nil)
            }
        }
        
        let alertAction4 = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertVC.addAction(alertAction1)
        alertVC.addAction(alertAction2)
        alertVC.addAction(alertAction3)
        alertVC.addAction(alertAction4)
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    
}



extension ZLRepoCodePreview3Controller {
    
    func sendQueryContentRequest(){
        
        SVProgressHUD.show()
        weak var weakSelf = self
        
        ZLRepoServiceModel.shared().getRepositoryFileHTMLInfo(withFullName: weakSelf!.repoFullName,path: weakSelf!.contentModel.path,branch:weakSelf!.branch,serialNumber: NSString.generateSerialNumber(),completeHandle: {(resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false
            {
                SVProgressHUD.dismiss()
                weakSelf?.switchToWebVC()
                return
            }
            
            guard let data : String = resultModel.data as? String else
            {
                SVProgressHUD.dismiss()
                weakSelf?.switchToWebVC()
                return;
            }
            
            weakSelf?.startLoadCode(codeHtml: data)
        })
    }
    
    func sendRenderMakrdownRequest(){
        
        weak var weakSelf = self
        SVProgressHUD.show()
        ZLRepoServiceModel.shared().getRepositoryFileRawInfo(withFullName: weakSelf!.repoFullName,path: weakSelf!.contentModel.path,branch:weakSelf!.branch,serialNumber: NSString.generateSerialNumber(),completeHandle: {(resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false
            {
                SVProgressHUD.dismiss()
                weakSelf?.switchToWebVC()
                return
            }
            
            guard let data : String = resultModel.data as? String else
            {
                SVProgressHUD.dismiss()
                weakSelf?.switchToWebVC()
                return;
            }
            
            let code = "```\(self.getFileType(fileExtension: URL.init(string: self.contentModel.path)?.pathExtension ?? ""))\n\(data)\n```"
            
            ZLAdditionInfoServiceModel.shared().renderCodeToMarkdown(withCode: code, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
                
                if resultModel.result == false
                {
                    SVProgressHUD.dismiss()
                    weakSelf?.switchToWebVC()
                    return
                }
                
                guard let data : String = resultModel.data as? String else
                {
                    SVProgressHUD.dismiss()
                    weakSelf?.switchToWebVC()
                    return;
                }
                
                let code = "<article class=\"markdown-body entry-content container-lg\" itemprop=\"text\">\(data)</article>"
                
                weakSelf?.startLoadCode(codeHtml: code)
                
            })
        })
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
                
                self.webView?.loadHTMLString(newHtmlStr as String, baseURL: nil)
                
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


extension ZLRepoCodePreview3Controller : WKUIDelegate,WKNavigationDelegate
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
        let urlStr = navigationAction.request.url?.absoluteString;
        
        if navigationAction.navigationType == .linkActivated {
            decisionHandler(.cancel)

            var url : URL? = nil
            
            if urlStr?.count ?? 0 > 0  {
                url = URL.init(string: urlStr!)
                if url?.host == nil {               // 如果是相对路径，组装baseurl
                    url = (URL.init(string: self.contentModel.html_url) as NSURL?)?.deletingLastPathComponent
                    url?.appendPathComponent(urlStr!)
                }
            }
            
            self.openURL(url: url)
        } else {
            decisionHandler(.allow)
        }
    }
       
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        if self.contentModel.download_url != nil {
            let baseURLStr = (URL.init(string: self.contentModel.download_url!) as NSURL?)?.deletingLastPathComponent?.absoluteString
            let addBaseScript = "let a = '\(baseURLStr ?? "")';let array = document.getElementsByTagName('img');for(i=0;i<array.length;i++){let item=array[i];if(item.getAttribute('src').indexOf('http') == -1){item.src = a + item.getAttribute('src');}}"
            
            webView.evaluateJavaScript(addBaseScript) { (result : Any?, error : Error?) in
                
            }
        }
        
        SVProgressHUD.dismiss()
        
    }
    
    
}

