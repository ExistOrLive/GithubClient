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

// iconfont
public struct ZLIconFont{
    let rawValue: String
    
    static let IssueOpen = ZLIconFont(rawValue: "\u{e70f}")
    static let IssueClose = ZLIconFont(rawValue: "\u{e737}")
    static let IssueMerge = ZLIconFont(rawValue: "\u{e70f}")
    
    static let NextArrow = ZLIconFont(rawValue: "\u{e688}")
    static let BackArrow = ZLIconFont(rawValue: "\u{e686}")
    
    static let Add = ZLIconFont(rawValue: "\u{e685}")
    static let Close = ZLIconFont(rawValue: "\u{e687}")
    
    static let PR = ZLIconFont(rawValue: "\u{e76e}")
    static let RepoStar = ZLIconFont(rawValue: "\u{e68a}")
    static let RepoFork = ZLIconFont(rawValue: "\u{e799}")
    static let RepoPrivate = ZLIconFont(rawValue: "\u{e7c9}")
    
    
    static let DownArrow = ZLIconFont(rawValue: "\u{e68c}")
    
    static let File = ZLIconFont(rawValue: "\u{e674}")
    static let DirClose = ZLIconFont(rawValue: "\u{e675}")
    static let DirOpen = ZLIconFont(rawValue: "\u{e677}")
    
    static let Filter = ZLIconFont(rawValue: "\u{e676}")
    
    static let More = ZLIconFont(rawValue: "\u{e7e3}")
    
    static let Workflow = ZLIconFont(rawValue: "\u{e77b}")
    
    static let Notification = ZLIconFont(rawValue: "\u{e629}")
    
    static let NoData = ZLIconFont(rawValue: "\u{e662}")
    
    static let Commit = ZLIconFont(rawValue: "\u{e857}")
    
    static let Tag = ZLIconFont(rawValue: "\u{e738}")
    
    static let Alert = ZLIconFont(rawValue: "\u{e637}")
    
    static let Discussion = ZLIconFont(rawValue: "\u{e638}")

}



extension UIFont{
    public static func zlFont(kind: ZLFontKind, family: ZLFontFamily, size: CGFloat) -> UIFont{
        UIFont.zlFont(withName: "\(family.rawValue)-\(kind.rawValue)", size: size)
    }
}
