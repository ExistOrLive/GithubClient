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

enum PatchType {
    case normal
    case renamed
    case image
    case binary
    case largeChanged
}

class ZLCommitInfoPatchCellData: ZMBaseTableViewCellViewModel {
    
    private var cellHeight: CGFloat = 0
    
    let model: ZLGithubFileDiffModel
    var patchStr: String = ""
    var imagePath: String = ""
    var type: PatchType = .normal
  
    
    var cacheHtml: String?
    
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
        return webView
    }()
    
    override var zm_cellHeight: CGFloat {
        return cellHeight
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLCommitInfoPatchCell"
    }
    
    override func zm_clearCache() {
        super.zm_clearCache()
        generateHTML()
        _webView.loadHTML(cacheHtml ?? "", baseURL: Bundle.main.bundleURL)
    }
    
    init(model: ZLGithubFileDiffModel, cellHeight: CGFloat?) {
        self.model = model
        super.init()
        self.initData(model: model)
        if let cellHeight = cellHeight {
            self.cellHeight = cellHeight
        }
        generateHTML()
        _webView.loadHTML(cacheHtml ?? "", baseURL: Bundle.main.bundleURL)
    }
    
    func initData(model: ZLGithubFileDiffModel) {
        if !model.patch.isEmpty {
            let patch = model.patch
            self.patchStr = patch.htmlEscaped()
            self.type = .normal
        } else if model.changes == 0 && model.status == "renamed" {
            self.type = .renamed
        } else if model.changes > 0 {
            self.type = .largeChanged
        } else {
            let pathExtension = (model.filename as NSString).pathExtension.lowercased()
            if ["png","jpg","jpeg","gif","svg","webp","bmp","icon"].contains(pathExtension) {
                self.type = .image
                let imagePath = model.raw_url
                self.imagePath = imagePath.htmlEscaped()
            } else {
                self.type = .binary
            }
        }
    }
    
}

// MARK: - HTML
extension ZLCommitInfoPatchCellData {
    
 
    var isLight: Bool {
        if #available(iOS 12.0, *) {
            return getRealUserInterfaceStyle() == .light
        } else {
            return true
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

extension ZLCommitInfoPatchCellData {
    
    func generateHTML() {
        var gitPatchDivContent = ""
        switch type {
        case .normal:
            let tag = parsePatchAndGenerateHTML(patchText: self.patchStr)
            gitPatchDivContent = tag?.toHTMLString() ?? ""
        case .image:
            gitPatchDivContent = "<img src=\"\(imagePath)\" class=\"img_binary\"/>"
        case .binary,.largeChanged,.renamed:
            var text = ""
            switch type {
            case .binary:
                text = ZLLocalizedString(string:"Binary File Patch", comment: "")
            case .largeChanged:
                text = ZLLocalizedString(string:"Large File Changed", comment: "")
            case .renamed:
                text = ZLLocalizedString(string:"File Renamed", comment: "")
            default:
                break
            }
            if isLight {
                gitPatchDivContent = "<div class=\"div_binary\">\(text)</div>"
            } else {
                gitPatchDivContent = "<div class=\"div_binary dark\">\(text)</div>"
            }
        }
     
        let htmlURL: URL? = Bundle.main.url(forResource: "gitpatchV2", withExtension: "html")
        
        if let url = htmlURL {
            
            do {
                let htmlStr = try String.init(contentsOf: url)
                let newHtmlStr = NSMutableString.init(string: htmlStr)
                
                let htmlRange = (newHtmlStr as NSString).range(of: "<html>")
                if  htmlRange.location != NSNotFound, !isLight {
                    newHtmlStr.insert(" class=\"dark\"", at: htmlRange.location + 5 )
                }
                
                let divRange = (newHtmlStr as NSString).range(of: "</div>")
                if  divRange.location != NSNotFound {
                    newHtmlStr.insert(gitPatchDivContent, at: divRange.location)
                }
                
                self.cacheHtml = newHtmlStr as String
                
            } catch {
                ZLToastView.showMessage("load Diff Patch failed")
            }
        }
    }
}

// MARK: - parse and generate html
extension ZLCommitInfoPatchCellData {
    
    class HTMLTag {
        let name: String
        var classList: [String] = []
        var children: [HTMLTag] = []
        var textContent: String = ""
        
        init(name: String) {
            self.name = name
        }
        
        func toHTMLString() -> String {
                var html = "<" + name
                
                // 添加class属性
                if !classList.isEmpty {
                    html += " class=\"" + classList.joined(separator: " ") + "\""
                }
                
                html += ">"
                
                // 添加文本内容
                if !textContent.isEmpty {
                    html += textContent
                }
                
                // 添加子元素
                for child in children {
                    html += child.toHTMLString()
                }
                
                html += "</" + name + ">"
                
                return html
            }
    }
    

    func parsePatchAndGenerateHTML(patchText: String) -> HTMLTag? {
        let patchLines = patchText.split(separator: "\n")
        guard !patchLines.isEmpty else { return nil }
        
        var currentOldLineNumber = 0;
        var currentNewLineNumber = 0;
        
        let tableTag = HTMLTag(name: "table")
        let tbody = HTMLTag(name: "tbody")
        tableTag.children = [tbody]
        
        
        patchLines.forEach { line in
            
            if (
                line.hasPrefix("diff --git") ||
                line.hasPrefix("index") ||
                line.hasPrefix("--- a") ||
                line.hasPrefix("+++ b")
            ) {
                return;
            }
            
            if (line.hasPrefix("@@")) {
                let (tr, oldLineNumber, newLineNumber ) = generateFileLineTr(line: String(line));
                tbody.children.append(tr)
                currentOldLineNumber = oldLineNumber;
                currentNewLineNumber = newLineNumber;

            } else if (line.hasPrefix("+")) {
                let ( tr, newNum ) = generateAdditionTr(
                    line: String(line),
                    newLineNumber: currentNewLineNumber
                );
                tbody.children.append(tr)
                currentNewLineNumber = newNum;
            } else if (line.hasPrefix("-")) {
                let ( tr, oldNum ) = generateDeletionTr(
                    line: String(line),
                    oldLineNumber: currentOldLineNumber
                );
                tbody.children.append(tr);
                currentOldLineNumber = oldNum;
            } else {
                let (tr, oldNum, newNum) = generateNormalTr(
                    line: String(line),
                    oldLineNumber: currentOldLineNumber,
                    newLineNumber: currentNewLineNumber
                );
                tbody.children.append(tr);
                currentOldLineNumber = oldNum;
                currentNewLineNumber = newNum;
            }
        }
        
        return tableTag
    }
        
    // @@ -138,28 +136,72 @@ extension ZLCommitInfoController
    func generateFileLineTr(line: String) -> (HTMLTag, Int, Int) {
        let ( tr, td_lineNumber, td_lineContent, div_lineNumber, div_lineContent ) =
            generatePatchLineTr();
        
        let (oldStart, oldLines, newStart, newLines) = parseGitChangeLine(line);

        div_lineContent.textContent = line;

        td_lineNumber.classList.append("patch");
        td_lineContent.classList.append("patch");

        return ( tr, oldStart, newStart );
    }
    
    // +//    func requestDiscussionComment(isLoadNew: Bool) {
    func generateAdditionTr(line: String, newLineNumber: Int) -> (HTMLTag, Int) {
        let ( tr, td_lineNumber, td_lineContent, div_lineNumber, div_lineContent ) =
            generatePatchLineTr();

        div_lineNumber.textContent = "\(newLineNumber)"
        div_lineContent.textContent = line;
        td_lineNumber.classList.append("add");
        td_lineContent.classList.append("add");

        let newNum = newLineNumber + 1;
        
        return ( tr, newNum );
    }

    // -//    func requestCommitDiffInfo() {
    func generateDeletionTr(line: String, oldLineNumber: Int) -> (HTMLTag, Int) {
        let (tr, td_lineNumber, td_lineContent, div_lineNumber, div_lineContent) =
            generatePatchLineTr();

        div_lineNumber.textContent = "\(oldLineNumber)"
        div_lineContent.textContent = line;
        td_lineNumber.classList.append("delete");
        td_lineContent.classList.append("delete");

        let oldNum = oldLineNumber + 1;
        return ( tr, oldNum );
    }

    func generateNormalTr(line: String, oldLineNumber: Int, newLineNumber: Int) -> (HTMLTag, Int, Int) {
        let ( tr, td_lineNumber, td_lineContent, div_lineNumber, div_lineContent ) =
            generatePatchLineTr();

        div_lineNumber.textContent = "\(newLineNumber)";
        div_lineContent.textContent = line;

        let oldNum = oldLineNumber + 1;
        let newNum = newLineNumber + 1;
        return ( tr, oldNum, newNum );
    }
    
    
    
    func parseGitChangeLine(_ str: String) -> (Int,Int,Int,Int) {
        let pattern = #"^@@ -(\d+),(\d+) \+(\d+),(\d+) @@"#
        
        guard let rangeMatch = str.range(of: pattern, options: .regularExpression) else {
            return (0,0,0,0)
        }
        
        let numbers = str[rangeMatch].components(separatedBy: CharacterSet.decimalDigits.inverted)
            .filter { !$0.isEmpty }
            .compactMap { Int($0) }
        
        guard numbers.count == 4 else {
            return (0,0,0,0)
        }
        
        return (numbers[0],numbers[1],numbers[2],numbers[3])
    }
    
    
    func generatePatchLineTr() -> (HTMLTag,HTMLTag,HTMLTag,HTMLTag,HTMLTag){
        let tr = HTMLTag(name: "tr")
        let td_lineNumber = HTMLTag(name: "td")
        let div_lineNumber = HTMLTag(name:"div")
        let td_lineContent = HTMLTag(name:"td")
        let div_lineContent = HTMLTag(name:"div")
        td_lineNumber.children = [div_lineNumber]
        td_lineContent.children = [div_lineContent]
        
        td_lineNumber.classList = ["td_linenum"]
        td_lineContent.classList = ["td_lineContent"]
        div_lineContent.classList = ["div_lineContent"]
        
        if(!isLight) {
            td_lineNumber.classList.append("dark");
            td_lineContent.classList.append("dark");
        }
   
        tr.children.append(td_lineNumber);
        tr.children.append(td_lineContent);

        return (tr, td_lineNumber, td_lineContent, div_lineNumber, div_lineContent)
    }

}

extension String {
    func htmlEscaped() -> String {
        return self
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
}
