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

class ZLCommitInfoFileCellData: ZMBaseTableViewCellViewModel {
    
    let model: ZLGithubFileModel
    
    init(model: ZLGithubFileModel) {
        self.model = model
        super.init()
    }
    
    override var zm_cellReuseIdentifier: String {
        return "ZLCommitInfoFileCell"
    }
}

extension ZLCommitInfoFileCellData: ZLCommitInfoFileCellSourceAndDelegate {
    
    var fileName: String {
        model.filename
    }
    
    var filePatchContent: NSAttributedString {
        var lines = model.patch.split(separator: "\n")
        var content = NSMutableAttributedString()
        for (index,line) in lines.enumerated() {
            var attributedLine = String(line)
                .asMutableAttributedString()
            if line.hasPrefix("@@") {
                attributedLine
                    .foregroundColor(.label(withName: "PatchInfoText"))
                    .font(.zlRegularFont(withSize: 15))
                    .backgroundColor(.label(withName: "PatchInfoback"))
                
            } else if line.hasPrefix("-") {
                attributedLine
                    .foregroundColor(.label(withName: "PatchTextColor"))
                    .font(.zlRegularFont(withSize: 14))
                    .backgroundColor(.label(withName: "PatchDeleteBack"))
                
            } else if line.hasPrefix("+") {
                attributedLine
                    .foregroundColor(.label(withName: "PatchTextColor"))
                    .font(.zlRegularFont(withSize: 14))
                    .backgroundColor(.label(withName: "PatchAddBack"))
                
            } else {
                attributedLine
                    .foregroundColor(.label(withName: "PatchTextColor"))
                    .font(.zlRegularFont(withSize: 14))
            }
            if index == 0 {
                content.append(attributedLine)
            } else {
                content.append("\n".asMutableAttributedString())
                content.append(attributedLine)
            }
        }
        
        content.paraghStyle(NSMutableParagraphStyle().lineSpacing(4))
        return content
    }
}
