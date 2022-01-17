//
//  Attach.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/11/21.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import Foundation

enum NSTextAttachmentWrapperAlignment: Int {
    case baseline
    case centerline
    case top
    case bottom
}

public class NSImageTextAttachmentWrapper: NSObject {

    var image: UIImage

    // 默认font
    var font: UIFont = UIFont.systemFont(ofSize: 14)

    //
    var size: CGSize = CGSize.zero

    // 对齐方式
    var alignment: NSTextAttachmentWrapperAlignment = .baseline

    // 图片大小适应行高 true： size 将失效
    var fitLineHeight: Bool = false

    init(image: UIImage) {
        self.image = image
        super.init()
    }

    func font(_ font: UIFont) -> NSImageTextAttachmentWrapper {
        self.font = font
        return self
    }

    func size(_ size: CGSize) -> NSImageTextAttachmentWrapper {
        self.size = size
        return self
    }

    func alignment(_ alignment: NSTextAttachmentWrapperAlignment) -> NSImageTextAttachmentWrapper {
        self.alignment = alignment
        return self
    }

    func fitLineHeight(_ fitLineHeight: Bool) -> NSImageTextAttachmentWrapper {
        self.fitLineHeight = fitLineHeight
        return self
    }

}

extension NSImageTextAttachmentWrapper {

    /**
     NSTextAttachment 基于 行 的 baseLine 布局图片，因此并不是居中的
     修改 bounds 属性，以调节图片的布局和大小
     */

    func textAttachment() -> NSTextAttachment {
        let attachment = NSTextAttachment()
        attachment.image = image

        let lineHeight = font.lineHeight
        let ascender = font.ascender
        let descender = font.descender

        var size = self.size
        if size == CGSize.zero {
            size = image.size
        }
        if fitLineHeight {
            if alignment == .baseline {
                size = CGSize(width: image.size.width * ascender / image.size.height, height: image.size.width * ascender / image.size.height)
            } else {
                size = CGSize(width: image.size.width * lineHeight / image.size.height, height: image.size.width * lineHeight / image.size.height)
            }
        }

        var bounds = CGRect.zero
        switch alignment {
        case .baseline:
            bounds = CGRect(origin: CGPoint.zero, size: size)
        case .bottom:
            bounds = CGRect(origin: CGPoint(x: 0, y: descender), size: size)
        case .top:
            bounds = CGRect(origin: CGPoint(x: 0, y: ascender - size.height), size: size)
        case .centerline:
            bounds = CGRect(origin: CGPoint(x: 0, y: (ascender + descender - size.height) / 2 ), size: size)
        }
        attachment.bounds = bounds
        return attachment
    }
}

extension NSImageTextAttachmentWrapper: NSAttributedStringConvertible {

    public func asAttributedString() -> NSAttributedString {
        self.asMutableAttributedString()
    }
    public func asMutableAttributedString() -> NSMutableAttributedString {
        self.textAttachment()
            .asMutableAttributedString()
            .font(self.font)
    }
}

extension UIImage {
    func asImageTextAttachmentWrapper() -> NSImageTextAttachmentWrapper {
        NSImageTextAttachmentWrapper(image: self)
    }
}
