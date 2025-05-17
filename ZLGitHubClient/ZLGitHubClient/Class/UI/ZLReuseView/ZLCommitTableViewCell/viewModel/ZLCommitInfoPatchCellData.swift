//
//  ZLCommitInfoFileCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/11.
//  Copyright © 2025 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService
import ZMMVVM
import WebKit

class ZLCommitInfoPatchCellData: ZMBaseTableViewCellViewModel {
    
    private var cacheHtml: String?
    private var cellHeight: CGFloat = 0
    
    let model: ZLGithubFileModel
    var patchStr: String = ""
    var imagePath: String = ""
    var isBinary: Bool = false
    var isImage: Bool = false
        
    lazy var _webView: ZLReportHeightWebViewV2 = {
        let frame = CGRect(x: 0,
                           y: 0,
                           width: UIScreen.main.bounds.size.width,
                           height: UIScreen.main.bounds.size.height)
        let webView = ZLReportHeightWebViewV2(frame: frame)
        webView.scrollView.backgroundColor = UIColor.clear
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.bounces = false 
        webView.backgroundColor = UIColor.clear
        webView.scrollView.isScrollEnabled = true
        webView.reportHeightBlock = { [weak self, weak webView] in
            
            guard let self ,
                  let webView,
                  let webViewHeight = webView.cacheHeight,
                  webViewHeight != self.cellHeight else {
                return
            }
            
            self.cellHeight =  webViewHeight
            (self.zm_superViewModel as? ZMBaseTableViewContainerProtocol)?.tableView.performBatchUpdates({
                
            })
        }
        let script = WKUserScript(source: self.renderDiffContentScript(), injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        webView.configuration.userContentController.addUserScript(script)
        
        return webView
    }()
        
    override var zm_cellHeight: CGFloat {
        return cellHeight + 60
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLCommitInfoPatchCell"
    }
    
    override func zm_clearCache() {
        super.zm_clearCache()
        _webView.evaluateJavaScript(renderDiffContentScript()) { (result, error) in
                        if let error = error {
                            print("JavaScript 执行错误: \(error)")
                        } else if let result = result {
                            print("JavaScript 执行结果: \(result)")
                        }
        }
    }
    
    init(model: ZLGithubFileModel, cellHeight: CGFloat?) {
        self.model = model
        super.init()
        self.initData(model: model)
        if let cellHeight = cellHeight {
            self.cellHeight = cellHeight
        }
        _webView.loadHTML(self.getGitPatchtHtml(), baseURL: Bundle.main.bundleURL)
//        _webView.evaluateJavaScript(renderDiffContentScript()){ (result, error) in
//            if let error = error {
//                print("JavaScript 执行错误: \(error)")
//            } else if let result = result {
//                print("JavaScript 执行结果: \(result)")
//            }
//        }
    }
    
    
    func initData(model: ZLGithubFileModel) {
        if !model.patch.isEmpty {
            var patch = model.patch
            patch = patch.replacingOccurrences(of: "`", with: "\\`")
            patch = patch.replacingOccurrences(of: "$", with: "\\$")
            self.patchStr = patch
            self.isBinary = false
            self.isImage = false
        } else {
            self.isBinary = true
            let pathExtension = (model.filename as NSString).pathExtension.lowercased()
            if ["png","jpg","jpeg","gif","svg","webp","bmp","icon"].contains(pathExtension) {
                self.isImage = true
                var imagePath = model.blob_url
                imagePath = imagePath.replacingOccurrences(of: "`", with: "\\`")
                imagePath = imagePath.replacingOccurrences(of: "$", with: "\\$")
                self.imagePath = imagePath
            }
        }
        
    }
    
}

// MARK: - HTML
extension ZLCommitInfoPatchCellData {
    
    
    func renderDiffContentScript() -> String {
        if !isBinary {
            return """
            render(`\(patchStr)`,\(isLight ? "false" : "true"));
            """
        } else if isImage {
            return """
            renderImage(`\(imagePath)`);
            """
        } else {
            return """
            renderBinary()
            """
        }
        
    }
    
    
    var isLight: Bool {
        if #available(iOS 12.0, *) {
            return getRealUserInterfaceStyle() == .light
        } else {
            return true
        }
    }
    

    func getGitPatchtHtml() -> String {
        if let html = cacheHtml {
            return html
        } else {
            let html = getHtmlStr()
            cacheHtml = html
            return html
        }
    }
    
    
    func getHtmlStr() -> String {
        let htmlURL: URL? = Bundle.main.url(forResource: "gitpatchV2", withExtension: "html")

        if let url = htmlURL {
            do {
                let htmlStr = try String.init(contentsOf: url)
                let newHtmlStr = NSMutableString.init(string: htmlStr)
                return newHtmlStr as String

            } catch {
                print(error)
            }
            return patchStr
        } else {
            return patchStr
        }
    }
}

// MARK: - ZLCommitInfoPatchCellSourceAndDelegate
extension ZLCommitInfoPatchCellData: ZLCommitInfoPatchCellSourceAndDelegate {
    var fileName: String {
        model.filename
    }
    
    var webView: WKWebView {
        _webView
    }
}

