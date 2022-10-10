//
//  ZLRepoCodePreviewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/24.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import WebKit
import ZLUIUtilities
import ZLGitRemoteService

class ZLRepoCodePreview2Controller: ZLBaseViewController {

    // model
    let repoFullName: String
    let path: String
    let branch: String

    var codeContent: ZLGithubContentModel?
    // view
    var markdownView: MarkdownView?

    init(repoFullName: String, path: String, branch: String) {
        self.repoFullName = repoFullName
        self.path = path
        self.branch = branch
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUI()

        self.sendQueryContentRequest()
    }

    func setUpUI() {
        self.title = self.path

        let markdownView = MarkdownView()
        self.contentView.addSubview(markdownView)
        markdownView.snp.makeConstraints({(make) in
            make.edges.equalToSuperview()
        })
        self.markdownView = markdownView

    }

    func sendQueryContentRequest() {
        ZLProgressHUD.show()
        weak var weakSelf = self

        ZLServiceManager.sharedInstance.repoServiceModel?.getRepositoryFileInfo(withFullName: self.repoFullName, path: self.path, branch: self.branch, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel: ZLOperationResultModel) in
            ZLProgressHUD.dismiss()

            if resultModel.result == false {
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query content Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                ZLProgressHUD.dismiss()
                return
            }

            guard let data: ZLGithubContentModel = resultModel.data as? ZLGithubContentModel else {
                ZLToastView.showMessage("ZLGithubContentModel transfer error")
                return
            }

            weakSelf?.codeContent = data
            weakSelf?.startLoadCode()

        })
    }

    func startLoadCode() {

        var codeStr = ""
        if let content = self.codeContent?.content {

            if let data  = Data.init(base64Encoded: content, options: .ignoreUnknownCharacters) {

                codeStr = String.init(data: data, encoding: .utf8) ?? "load Error"
            } else {

                codeStr = "load Error"
            }
        } else {

            codeStr = "empty content"
        }

        let markdownStr = "```\n"+codeStr+"\n```"

        self.markdownView?.load(markdown: markdownStr, baseUrl: nil, enableImage: false)

    }
}
