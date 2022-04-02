//
//  ZLIssueLabelsCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/24.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLBaseExtension

class ZLIssueLabelsCellData: ZLGithubItemTableViewCellData {
    
    let data: IssueEditInfoQuery.Data.Repository.Issue.Label
    
    init(data: IssueEditInfoQuery.Data.Repository.Issue.Label) {
        self.data = data
        super.init()
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLIssueLabelsCell"
    }

    override func getCellHeight() -> CGFloat {
        UITableView.automaticDimension
    }
}

extension ZLIssueLabelsCellData: ZLIssueLabelsCellDataSource {
    
    var labelsStr: NSAttributedString? {
       
        guard let labels = data.nodes else {
            return nil
        }
        
        var tags: [NSAttributedStringConvertible?] = []
        for label in labels {
            
            guard let label = label else {
                continue
            }
            let tagColor = ZLRGBValueStr_H(colorValue: label.color)
            var borderColor = UIColor.clear
            var backColor = tagColor
            var textColor = UIColor.isLightColor(tagColor) ? ZLRGBValue_H(colorValue: 0x333333) : UIColor.white
            var borderWidth: CGFloat = 0.0

            if #available(iOS 12.0, *) {
                if getRealUserInterfaceStyle() == .dark {
                    backColor = ZLRGBValueStr_H(colorValue: label.color , alphaValue: 0.2)
                    borderWidth = 1.0 / UIScreen.main.scale
                    borderColor = ZLRGBValueStr_H(colorValue: label.color, alphaValue: 0.5)
                    textColor = ZLRGBValueStr_H(colorValue: label.color)
                }
            }
            
            
            let tag = NSTagWrapper()
                .attributedString(label.name
                                    .asMutableAttributedString()
                                    .font(.zlRegularFont(withSize: 13))
                                    .foregroundColor(textColor))
                .cornerRadius(8.0)
                .borderColor(borderColor)
                .borderWidth(borderWidth)
                .backgroundColor(backColor)
                .edgeInsets(UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10))
                .asImage()?
                .asImageTextAttachmentWrapper()
                .alignment(.centerline)
            
            tags.append(tag)
            tags.append("  ")
        }
        
        let paragraphStyle = NSMutableParagraphStyle().lineSpacing(10)
        let result = NSAttributedStringConvertibleContainer(attributes: [:], convertibles: tags).asMutableAttributedString()
            .paraghStyle(paragraphStyle)
        
        return result
    }
}
