//
//  UIColor+ZLExtension.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/11/8.
//  Copyright © 2021 ZM. All rights reserved.
//

import Foundation

// MARK: Color

public func ZLRGBValue_H(colorValue: UInt) -> UIColor {
    return UIColor(rgb: colorValue, alpha: 1.0) ?? UIColor.white
}

public func ZLRGBAValue_H(colorValue: UInt, alphaValue: CGFloat) -> UIColor {
    return UIColor(rgb: colorValue, alpha: alphaValue) ?? UIColor.white
}

public func ZLRGBValueStr_H(colorValue: String) -> UIColor {
    return UIColor(hexString: colorValue, alpha: 1.0) ?? UIColor.white
}

public func ZLRGBValueStr_H(colorValue: String, alphaValue: CGFloat) -> UIColor {
    return UIColor(hexString: colorValue, alpha: Float(alphaValue)) ?? UIColor.white
}

public func ZLRawColor(name: String) -> UIColor? {
    if let color = UIColor(named: name) {
        return UIColor(cgColor: color.cgColor)
    } else {
        return nil
    }
}

public func ZLRawLabelColor(name: String) -> UIColor {
    let color = UIColor.label(withName: name)
    return UIColor(cgColor: color.cgColor)
}

public func ZLRawLinkColor(name: String) -> UIColor {
    let color = UIColor.linkColor(withName: name)
    return UIColor(cgColor: color.cgColor)
}

public func ZLRawBackColor(name: String) -> UIColor {
    let color = UIColor.back(withName: name)
    return UIColor(cgColor: color.cgColor)
}

extension UIColor {
    public convenience init?(rgb: UInt) {
        self.init(rgb: rgb, alpha: 1)
    }

    public convenience init?(hexString: String) {
        self.init(hexString: hexString, alpha: 1)
    }
}
