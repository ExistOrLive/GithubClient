//
//  ZLRepoCodePreviewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/24.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import WebKit

class ZLRepoCodePreviewController: ZLBaseViewController {
    
    // model
    let repoFullName : String
    let path : String
    let branch : String
    
    var codeContent : ZLGithubContentModel?
    var codeStr : String?
    // view
    var webView : WKWebView?
    
    init(repoFullName : String, path : String, branch : String)
    {
        self.repoFullName = repoFullName
        self.path = path
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
        self.title = self.path
    }
    
    func sendQueryContentRequest()
    {
        SVProgressHUD.show()
        weak var weakSelf = self
        
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepositoryFileInfo(withFullName: self.repoFullName,path: self.path,branch:self.branch,serialNumber: NSString.generateSerialNumber(),completeHandle: {(resultModel : ZLOperationResultModel) in
            SVProgressHUD.dismiss()
            
            if resultModel.result == false
            {
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query content Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }
        
            guard let data : ZLGithubContentModel = resultModel.data as? ZLGithubContentModel else
            {
                ZLToastView.showMessage("ZLGithubContentModel transfer error")
                return;
            }
            
            weakSelf?.codeContent = data
            weakSelf?.startLoadCode()
            
        })
    }
    
    func startLoadCode(){
        
        var codeStr = ""
        
        if let content = self.codeContent?.content{
            
            let data  = Data.init(base64Encoded: content, options: .ignoreUnknownCharacters)
            if data == nil{
                codeStr = "load Error"
            }
            else{
                codeStr = String.init(data: data!, encoding: .utf8) ?? "load Error"
            }
        }
        else{
            
            codeStr = "empty content"
        }
        self.codeStr = codeStr
        
        let htmlURL: URL? = Bundle.main.url(forResource: "codeIndex", withExtension: "html")
        
        if let url = htmlURL {

            do {
                let htmlStr = try String.init(contentsOf: url)
                let range = (htmlStr as NSString).range(of:"</pre>")
                if  range.location != NSNotFound{
                    let newHtmlStr = NSMutableString.init(string: htmlStr)
                    newHtmlStr.insert((codeStr as NSString).htmlEntityEncode(), at: range.location)
                    
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
                }
            }catch{
                ZLToastView.showMessage("load Code index html failed");
            }
        }
    }
}

extension ZLRepoCodePreviewController : WKUIDelegate,WKNavigationDelegate
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
    
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
//    {
//        let codeEncodeStr = (self.codeStr! as NSString).htmlEntityEncode()
//       // let codeEncodeStr = "function a(){\n let c = 1 + 2;\n print(c);\n}"
//        let script = "insertCode('\((codeEncodeStr as NSString).htmlEntityEncode())')"
//        webView.evaluateJavaScript(script, completionHandler: {(obj : Any? , error : Error?) in
//
//        })
//    }
}
