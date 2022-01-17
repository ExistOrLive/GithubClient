//
//  ZLCommonURLManager.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/12/12.
//  Copyright © 2020 ZM. All rights reserved.
//

@objcMembers class ZLCommonURLManager: NSObject {

    static let emailRegex = #"^(mailto:)?[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$"#
    static let phoneRegex = #"^(tel:)?1(3|4|5|6|7|8|9)\d{9}$"#
    static let appleAppLinkRegex = #"^(https|http):\/\/apps\.apple\.com\/cn\/app\/"#

    static func isEmail(str: String) -> Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: emailRegex, options: .init(rawValue: 0))
            let result = regex.matches(in: str, options: .init(rawValue: 0), range: NSRange(location: 0, length: str.count))
            return !result.isEmpty
        } catch {
            return false
        }
    }

    static func isPhone(str: String) -> Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: phoneRegex, options: .init(rawValue: 0))
            let result = regex.matches(in: str, options: .init(rawValue: 0), range: NSRange(location: 0, length: str.count))
            return !result.isEmpty
        } catch {
            return false
        }
    }

    static func isAppleAppLink(str: String) -> Bool {

        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: appleAppLinkRegex, options: .init(rawValue: 0))
            let result = regex.matches(in: str, options: .init(rawValue: 0), range: NSRange(location: 0, length: str.count))
            return !result.isEmpty
        } catch {
            return false
        }
    }
}
