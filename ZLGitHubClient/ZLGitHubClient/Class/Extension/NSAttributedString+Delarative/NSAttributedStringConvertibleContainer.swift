//
//  NSAttributedStringConvertibleContainer.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/11/21.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import Foundation

public class NSAttributedStringConvertibleContainer: NSObject {
    
    private var attributes: [NSAttributedString.Key:Any] = [:]
    
    private var convertibles: [NSAttributedStringConvertible?] = []
    
    init(attributes: [NSAttributedString.Key:Any],
         convertibles: [NSAttributedStringConvertible?]) {
        super.init()
        self.attributes = attributes
        self.convertibles = convertibles
    }
    
    convenience init(_ convertibles: NSAttributedStringConvertible?...){
        self.init(attributes:[:],convertibles:convertibles)
    }
    
}

extension NSAttributedStringConvertibleContainer{
    func font(_ font: UIFont) -> NSAttributedStringConvertibleContainer{
        attributes[.font] = font
        return self
    }
    
    // 文字颜色
    func foregroundColor(_ color: UIColor) -> NSAttributedStringConvertibleContainer{
        attributes[.foregroundColor] = color
        return self
    }
    
    // 文字背景颜色
    func backgroundColor(_ color: UIColor) -> NSAttributedStringConvertibleContainer{
        attributes[.backgroundColor] = color
        return self
    }
    
    // 段落格式
    func paraghStyle(_ style: NSParagraphStyle) -> NSAttributedStringConvertibleContainer{
        attributes[.paragraphStyle] = style
        return self
    }
    
    // 字符间距
    func kern(_ kern: CGFloat) -> NSAttributedStringConvertibleContainer{
        attributes[.kern] = kern
        return self
    }
    
    @available(iOS 14.0, *)
    // 字符间距？
    func tracking(_ tracking: CGFloat) -> NSAttributedStringConvertibleContainer{
        attributes[.tracking] = tracking
        return self
    }
    
    // 删除线
    func strikethroughStyle(_ style: NSUnderlineStyle) -> NSAttributedStringConvertibleContainer{
        attributes[.strikethroughStyle] = style
        return self
    }
    
    // 删除线颜色
    func strikethroughColor(_ color: UIColor) -> NSAttributedStringConvertibleContainer{
        attributes[.strikethroughColor] = color
        return self
    }
    
    // 下划线颜色
    func underlineColor(_ color: UIColor) -> NSAttributedStringConvertibleContainer{
        attributes[.underlineColor] = color
        return self
    }
    
    // 下划线
    func underlineStyle(_ style: NSUnderlineStyle) -> NSAttributedStringConvertibleContainer{
        attributes[.underlineStyle] = style
        return self
    }
    
    
    // 镂空字体颜色
    func strokeColor(_ color: UIColor) -> NSAttributedStringConvertibleContainer{
        attributes[.strokeColor] = color
        return self
    }
    
    // 镂空字体线宽度
    func strokeWidth(_ width: CGFloat) -> NSAttributedStringConvertibleContainer{
        attributes[.strokeWidth] = width
        return self
    }
    
    // 阴影
    func shadow(_ shadow: NSShadow) -> NSAttributedStringConvertibleContainer {
        attributes[.shadow] = shadow
        return self
    }
    
    // 基线偏移 建议不要用 (无法准确计算高度)
    func baselineOffset(_ offset: CGFloat) -> NSAttributedStringConvertibleContainer {
        attributes[.baselineOffset] = offset
        return self
    }
//    
//    // 文字特效 letterpressStyle 立体效果
//    func textEffect(_ textEffect: TextEffectStyle) -> NSAttributedStringConvertibleContainer {
//        attributes[.textEffect] = textEffect.
//        return self
//    }
    
    // 斜体
    func obliqueness(_ obliqueness: CGFloat) -> NSAttributedStringConvertibleContainer {
        attributes[.obliqueness] = obliqueness
        return self
    }
    
    // 字符拉宽
    func expansion(_ expansion: CGFloat) -> NSAttributedStringConvertibleContainer {
        attributes[.expansion] = expansion
        return self
    }
    
    // 连字符？
    func ligature(_ ligature: CGFloat) -> NSAttributedStringConvertibleContainer {
        attributes[.ligature] = ligature
        return self
    }
    

    func link(_ link: URL) -> NSAttributedStringConvertibleContainer {
        attributes[.link] = link
        return self
    }
    
    func writingDirection(_ direction: NSWritingDirection) -> NSAttributedStringConvertibleContainer{
        attributes[.writingDirection] = direction
        return self
    }
}

extension NSAttributedStringConvertibleContainer: NSAttributedStringConvertible {
    public func asMutableAttributedString() -> NSMutableAttributedString {
        
        let str = NSMutableAttributedString()
        let str2 = convertibles.reduce(into: str) { partialResult, convertible in
            if let convertible = convertible {
                partialResult.append(convertible.asAttributedString())
            }
        }
        
        str2.enumerateAttributes(in: NSRange(location: 0, length: str2.length), options: .reverse)
        { (attributes, range, stop) in
            
            self.attributes.forEach { (key,value) in
                if attributes[key] == nil {
                    str2.addAttribute(key, value: value, range: range)
                }
            }
        }
        
        return str2
    }
}
