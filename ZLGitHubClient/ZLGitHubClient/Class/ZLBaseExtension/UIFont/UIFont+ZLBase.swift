//
//  UIFont+ZLExtension.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/11/7.
//  Copyright © 2021 ZM. All rights reserved.
//

import Foundation

// 常用字形
public enum ZLFontKind: String {
    case italic = "Italic"
    case thin = "Thin"
    case bold = "Bold"
    case boldItalic = "BoldItalic"
    case thinItalic = "ThinItalic"
    case light = "Light"
    case lightItalic = "LightItalic"
    case regular = "Regular"
    case medium = "Medium"
    case mediumItalic = "MediumItalic"
    case semibold = "Semibold"
    case condensedBold = "CondensedBold"
    case condensedBlack = "CondensedBlack"
    case ultralight = "Ultralight"
    case ultraLightItalic = "UltraLightItalic"
}

// 常用字体
public enum ZLFontFamily: String {
    case pingFangSC = "PingFangSC"
    case pingFangHK = "PingFangHK"
    case helveticaNeue = "HelveticaNeue"
    case dinCondensed = "DINCondensed"
}

extension UIFont {
    public static func zlFont(kind: ZLFontKind, family: ZLFontFamily, size: CGFloat) -> UIFont {
        UIFont.zlFont(withName: "\(family.rawValue)-\(kind.rawValue)", size: size)
    }
}
