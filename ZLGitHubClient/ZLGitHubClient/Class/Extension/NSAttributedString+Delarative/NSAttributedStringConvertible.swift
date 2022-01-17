//
//  NSAttributedStringConvertible.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/11/21.
//  Copyright © 2021 ZM. All rights reserved.
//

import Foundation
import UIKit

// MARK: NSAttributedStringConvertible
public protocol NSAttributedStringConvertible {
    func asAttributedString() -> NSAttributedString
    func asMutableAttributedString() -> NSMutableAttributedString
}

extension NSAttributedStringConvertible {
    public func asAttributedString() -> NSAttributedString {
        self.asMutableAttributedString()
    }
}

// MARK: NSAttributedString

extension NSAttributedString: NSAttributedStringConvertible {
    public func asMutableAttributedString() -> NSMutableAttributedString {
        if let arrtibutedStr = self as? NSMutableAttributedString {
            return arrtibutedStr
        } else {
            return NSMutableAttributedString(attributedString: self)
        }
    }

    public func asAttributedString() -> NSAttributedString {
        return self
    }
}

// MARK: String
extension String: NSAttributedStringConvertible {
    public func asMutableAttributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }

    public func asAttributedString() -> NSAttributedString {
        return self.asMutableAttributedString()
    }
}

// MARK: NSTextAttachment
extension NSTextAttachment: NSAttributedStringConvertible {
    public func asMutableAttributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString(attachment: self)
    }

    public func asAttributedString() -> NSAttributedString {
        return self.asMutableAttributedString()
    }
}
