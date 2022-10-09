//
//  ZLCommonURLManager.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/12/12.
//  Copyright © 2020 ZM. All rights reserved.
//

import Foundation
import UIKit

@objcMembers class ZLCommonURLManager: NSObject {

    static let emailRegex = #"^(mailto:)?[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$"#
    static let phoneRegex = #"^(tel:)?1(3|4|5|6|7|8|9)\d{9}$"#
    static let appleAppLinkRegex = #"^(https|http):\/\/apps\.apple\.com(\/cn)?\/app\/"#
    static let githubLinkRegex = #"^(https|http):\/\/(www\.)?github\.com"#
    static let testflightLinkRegex = #"^(https|http):\/\/testflight\.apple\.com\/join\/"#
    
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
        
    static func isTestFlightLink(str: String) -> Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: testflightLinkRegex, options: .init(rawValue: 0))
            let result = regex.matches(in: str, options: .init(rawValue: 0), range: NSRange(location: 0, length: str.count))
            return !result.isEmpty
        } catch {
            return false
        }
    }
    
    static func isItmsBetaLink(str: String) -> Bool {
        
        if let url = URL(string: str),
           let scheme = url.scheme,
           scheme == "itms-beta" {
            return true
        }
        return false
    }

    
    static func isGithubLink(str: String) -> Bool {
        
        if let url = URL(string: str),
           let scheme = url.scheme,
           scheme == "itms-beta" {
            return true
        }
        return false
    }
    
    
    static func openURL(urlStr: String, completionHandler: ((Bool) -> Void)? = nil) -> Bool {
        
        var url: URL? = nil
        
        if ZLCommonURLManager.isEmail(str: urlStr) {
            if urlStr.starts(with: "mailto:") {
                url = URL(string: urlStr)
            } else {
                url = URL(string: "mailto:\(urlStr)")
            }
        } else if ZLCommonURLManager.isPhone(str: urlStr) {
            if urlStr.starts(with: "tel:")  {
                url = URL(string: urlStr)
            } else {
                url = URL(string: "tel:\(urlStr)")
            }
        } else if ZLCommonURLManager.isAppleAppLink(str: urlStr) {
            url = URL(string: urlStr)
        } else if ZLCommonURLManager.isItmsBetaLink(str: urlStr) {
            url = URL(string: urlStr)
        } else if ZLCommonURLManager.isTestFlightLink(str: urlStr) {
            url = URL(string: urlStr)
        }

        if let url = url,
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: completionHandler)
            return true
        }
        return false
    }

 }
