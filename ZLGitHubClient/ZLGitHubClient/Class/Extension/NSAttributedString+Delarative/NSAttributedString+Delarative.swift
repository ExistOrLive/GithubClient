//
//  NSAttributedString+Delarative.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/11/21.
//  Copyright © 2021 ZM. All rights reserved.
//

import Foundation
import UIKit
import CoreText
import CoreFoundation
import YYText

// MARK: NSMutableAttributedString + Delarative
/**
  * NSMutableAttributedString 添加属性
 */
public extension NSMutableAttributedString {
        
    static func text(_ text: String) -> NSMutableAttributedString{
        NSMutableAttributedString(string: text)
    }
    
    func attribute(_ key: NSAttributedString.Key, attribute: Any)  -> NSMutableAttributedString{
        self.addAttribute(key,
                          value: attribute,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    func attributes(_ attributes: [NSAttributedString.Key:Any])  -> NSMutableAttributedString{
        self.addAttributes(attributes,
                           range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // 字体
    func font(_ font: UIFont) -> NSMutableAttributedString{
        self.addAttribute(.font,
                          value: font,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // 文字颜色
    func foregroundColor(_ color: UIColor) -> NSMutableAttributedString{
        self.addAttribute(.foregroundColor,
                          value: color,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // 文字背景颜色
    func backgroundColor(_ color: UIColor) -> NSMutableAttributedString{
        self.addAttribute(.backgroundColor,
                          value: color,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // 段落格式
    func paraghStyle(_ style: NSParagraphStyle) -> NSMutableAttributedString{
        self.addAttribute(.paragraphStyle,
                          value: style,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // 字符间距
    func kern(_ kern: CGFloat) -> NSMutableAttributedString{
        self.addAttribute(.kern,
                          value: kern,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    @available(iOS 14.0, *)
    // 字符间距？
    func tracking(_ tracking: CGFloat) -> NSMutableAttributedString{
        self.addAttribute(.tracking,
                          value: tracking,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // 删除线
    func strikethroughStyle(_ style: NSUnderlineStyle) -> NSMutableAttributedString{
        self.addAttribute(.strikethroughStyle,
                          value: style.rawValue,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // 删除线颜色
    func strikethroughColor(_ color: UIColor) -> NSMutableAttributedString{
        self.addAttribute(.strikethroughColor,
                          value: color,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // 下划线颜色
    func underlineColor(_ color: UIColor) -> NSMutableAttributedString{
        self.addAttribute(.underlineColor,
                          value: color,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // 下划线
    func underlineStyle(_ style: NSUnderlineStyle) -> NSMutableAttributedString{
        self.addAttribute(.underlineStyle,
                          value: style.rawValue,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    
    // 镂空字体颜色
    func strokeColor(_ color: UIColor) -> NSMutableAttributedString{
        self.addAttribute(.strokeColor,
                          value: color,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // 镂空字体线宽度
    func strokeWidth(_ width: CGFloat) -> NSMutableAttributedString{
        self.addAttribute(.strokeWidth,
                          value: width,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // 阴影
    func shadow(_ shadow: NSShadow) -> NSMutableAttributedString {
        self.addAttribute(.shadow,
                          value: shadow,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // 基线偏移 建议不要用 (无法准确计算高度)
    func baselineOffset(_ offset: CGFloat) -> NSMutableAttributedString {
        self.addAttribute(.baselineOffset,
                          value: offset,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // 文字特效 letterpressStyle 立体效果
    func textEffect(_ textEffect: TextEffectStyle) -> NSMutableAttributedString {
        self.addAttribute(.textEffect,
                          value: textEffect.rawValue,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // 斜体
    func obliqueness(_ obliqueness: CGFloat) -> NSMutableAttributedString {
        self.addAttribute(.obliqueness,
                          value: obliqueness,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // 字符拉宽
    func expansion(_ expansion: CGFloat) -> NSMutableAttributedString {
        self.addAttribute(.expansion,
                          value: expansion,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // 连字符？
    func ligature(_ ligature: CGFloat) -> NSMutableAttributedString {
        self.addAttribute(.ligature,
                          value: ligature,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    

    func link(_ link: URL) -> NSMutableAttributedString {
        self.addAttribute(.link,
                          value: link,
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    func writingDirection(_ direction: NSWritingDirection) -> NSMutableAttributedString{
        self.addAttribute(.writingDirection,
                          value: [direction.rawValue],
                          range: NSRange(location: 0, length: self.length))
        return self
    }
    
    // MARK: Core Text
    func runDelegate(_ delegate: CTRunDelegate) -> NSMutableAttributedString {
        CFAttributedStringSetAttribute(self as CFMutableAttributedString,
                                       CFRange(location: 0, length: self.length),
                                       kCTRunDelegateAttributeName,
                                       delegate)
        return self
    }
    
    
    func verticalForms(_ isVertial: Bool) -> NSMutableAttributedString{
        CFAttributedStringSetAttribute(self as CFMutableAttributedString,
                                       CFRange(location: 0, length: self.length),
                                       kCTVerticalFormsAttributeName,
                                       NSNumber(booleanLiteral: isVertial))
        return self
    }
}

// MARK: NSMutableAttributedString + Delarative + YYText
public extension NSMutableAttributedString{
    
    func yy_highlight(_ foregroundColor: UIColor?,
                      backgroudColor: UIColor?,
                      tapAction: YYTextAction?,
                      longPressAction: YYTextAction? = nil) -> NSMutableAttributedString{
        self.yy_setTextHighlight(NSRange(location: 0, length: self.length),
                                 color: foregroundColor,
                                 backgroundColor: backgroudColor,
                                 userInfo: nil,
                                 tapAction: tapAction,
                                 longPressAction: longPressAction)
        return self
    }
}


// MARK: NSMutableParagraphStyle + Delarative
public extension NSMutableParagraphStyle {
    
    
    func paraghStyle(_ paraghStyle: NSParagraphStyle) -> NSMutableParagraphStyle {
        self.setParagraphStyle(paraghStyle)
        return self
    }
    
    // MARK: 间距
    // 行间距
    func lineSpacing(_ lineSpacing: CGFloat) -> NSMutableParagraphStyle {
        self.lineSpacing = lineSpacing
        return self
    }
    
    // 段落间距
    func paragraphSpacing(_ paragraphSpacing: CGFloat) -> NSMutableParagraphStyle {
        self.paragraphSpacing = paragraphSpacing
        return self
    }
    
    // 段上空间
    func paragraphSpacingBefore(_ paragraphSpacingBefore: CGFloat) -> NSMutableParagraphStyle {
        self.paragraphSpacingBefore = paragraphSpacingBefore
        return self
    }
    
    
    // MARK: 方向
    
    // 对齐方式
    func alignment(_ alignment: NSTextAlignment) -> NSMutableParagraphStyle {
        self.alignment = alignment
        return self
    }
    
    // 对齐方式
    func baseWritingDirection(_ baseWritingDirection: NSWritingDirection) -> NSMutableParagraphStyle {
        self.baseWritingDirection = baseWritingDirection
        return self
    }
    
    // MARK: 缩进
    // 首行缩进
    func firstLineHeadIndent(_ firstLineHeadIndent: CGFloat) -> NSMutableParagraphStyle {
        self.firstLineHeadIndent = firstLineHeadIndent
        return self
    }
    
    // 段前缩进 段首距离左边界的距离 (不包括首行)
    func headIndent(_ headIndent: CGFloat) -> NSMutableParagraphStyle {
        self.headIndent = headIndent
        return self
    }
    
    // 段后缩进 非负 为段尾距离左边界的距离  负数 为段尾距离右边界的距离
    func tailIndent(_ tailIndent: CGFloat) -> NSMutableParagraphStyle {
        self.tailIndent = tailIndent
        return self
    }
    
   
    // MARK: 行高
    
    func minimumLineHeight(_ minimumLineHeight: CGFloat) -> NSMutableParagraphStyle {
        self.minimumLineHeight = minimumLineHeight
        return self
    }
    func maximumLineHeight(_ maximumLineHeight: CGFloat) -> NSMutableParagraphStyle {
        self.maximumLineHeight = maximumLineHeight
        return self
    }
    
    // 原始行高 * lineHeightMultiple 得到 目标行高， 目标行高 经过 minimumLineHeight maximumLineHeight 约束调整得到 最终行高
    func lineHeightMultiple(_ lineHeightMultiple:CGFloat) -> NSMutableParagraphStyle {
        self.lineHeightMultiple = lineHeightMultiple
        return self
    }
  
    
    // MARK: 换行
    func lineBreakStrategy(_ lineBreakStrategy: NSParagraphStyle.LineBreakStrategy) -> NSMutableParagraphStyle {
        self.lineBreakStrategy = lineBreakStrategy
        return self
    }
    
    func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> NSMutableParagraphStyle {
        self.lineBreakMode = lineBreakMode
        return self
    }
    
    //  连字符因素
    func hyphenationFactor(_ hyphenationFactor: Float) -> NSMutableParagraphStyle {
        self.hyphenationFactor = hyphenationFactor
        return self
    }
    
    // 是否在截断之前先收紧字符间距
    func allowsDefaultTighteningForTruncation(_ allow: Bool) -> NSMutableParagraphStyle{
        self.allowsDefaultTighteningForTruncation = allow
        return self
    }
    
    // MARK: 制表位
    
    // 默认制表符间隔
    func defaultTabInterval(_ defaultTabInterval: CGFloat) -> NSMutableParagraphStyle{
        self.defaultTabInterval = defaultTabInterval
        return self
    }
    
    // 默认值为 一组 12个 28逻辑点间隔 左对齐 的 NSTextTab
    func tabStops(_ tabStops: [NSTextTab]) -> NSMutableParagraphStyle{
        self.tabStops = tabStops
        return self
    }
    
    
    
}
