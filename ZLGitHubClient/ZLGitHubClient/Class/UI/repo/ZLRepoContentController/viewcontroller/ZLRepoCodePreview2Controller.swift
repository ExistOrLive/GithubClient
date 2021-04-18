//
//  ZLRepoCodePreviewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/24.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import WebKit

class ZLRepoCodePreview2Controller: ZLBaseViewController {
    
    // model
    let repoFullName : String
    let path : String
    let branch : String
    
    var codeContent : ZLGithubContentModel?
    // view
    var markdownView : MarkdownView?
    
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
        
        self.markdownView = MarkdownView()
        self.contentView.addSubview(self.markdownView!)
        self.markdownView!.snp.makeConstraints({(make) in
            make.edges.equalToSuperview()
        })
        
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
                SVProgressHUD.dismiss()
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
        if self.codeContent?.content == nil
        {
            codeStr = "empty content"
        }
        else
        {
            let data  = Data.init(base64Encoded: self.codeContent!.content!, options: .ignoreUnknownCharacters)
            if data == nil
            {
                codeStr = "load Error"
            }
            else
            {
                codeStr = String.init(data: data!, encoding: .utf8) ?? "load Error"
            }
        }
        
        let markdownStr = "```\n"+codeStr+"\n```";
        
        self.markdownView?.load(markdown: markdownStr, baseUrl: nil, enableImage: false)
        
    }
}

