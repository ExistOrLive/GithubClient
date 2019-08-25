//
//  Swift-Prefix.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import Foundation
import UIKit
import CocoaLumberjack
import SDWebImage


// MARK: 界面常用参数

let ZLStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
let ZLSCreenHeight  = UIScreen.main.bounds.size.height;
let ZLScreenWidth   = UIScreen.main.bounds.size.width;
let ZLScreenBounds  = UIScreen.main.bounds;

// MARK: NotificationName

let ZLLoginResult_Notification = Notification.Name(rawValue: "ZLLoginResult_Notification")
let ZLGetCurrentUserInfoResult_Notification = Notification.Name(rawValue: "ZLGetCurrentUserInfoResult_Notification")
let ZLGetReposResult_Notification = Notification.Name(rawValue: "ZLGetReposResult_Notification")
let ZLGetFollowersResult_Notification = Notification.Name(rawValue: "ZLGetFollowersResult_Notification")
let ZLGetFollowingResult_Notification = Notification.Name(rawValue: "ZLGetFollowingResult_Notification")
let ZLGetGistsResult_Notification = Notification.Name(rawValue: "ZLGetGistsResult_Notification")
let ZLSearchResult_Notification = Notification.Name(rawValue: "ZLSearchResult_Notification")
let ZLGetSpecifiedUserInfoResult_Notification = Notification.Name(rawValue: "ZLGetSpecifiedUserInfoResult_Notification")
let ZLGetSpecifiedRepoInfoResult_Notification  = Notification.Name(rawValue: "ZLGetSpecifiedRepoInfoResult_Notification")

extension Notification
{
    var params: Any?
    {
        get{
            return self.userInfo?["params"]
        }
    }
}

// MARK: ZLLog

#if DEBUG
let ZLLogLevel = DDLogLevel.debug
#else
let ZLLogLevel = DDLogLevel.info
#endif

func ZLLog_Debug(_ message: @autoclosure () -> String, level: DDLogLevel = ZLLogLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil, asynchronous async: Bool = true, ddlog: DDLog = DDLog.sharedInstance) {
    _DDLogMessage(message, level: level, flag: .debug, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: ddlog)
}

func ZLLog_Info(_ message: @autoclosure () -> String, level: DDLogLevel = ZLLogLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil, asynchronous async: Bool = true, ddlog: DDLog = DDLog.sharedInstance) {
    _DDLogMessage(message, level: level, flag: .info, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: ddlog)
}

func ZLLog_Warn(_ message: @autoclosure () -> String, level: DDLogLevel = ZLLogLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil, asynchronous async: Bool = true, ddlog: DDLog = DDLog.sharedInstance) {
    _DDLogMessage(message, level: level, flag: .warning, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: ddlog)
}

func ZLLog_Verbose(_ message: @autoclosure () -> String, level: DDLogLevel = ZLLogLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil, asynchronous async: Bool = true, ddlog: DDLog = DDLog.sharedInstance) {
    _DDLogMessage(message, level: level, flag: .verbose, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: ddlog)
}

func ZLLog_Error(_ message: @autoclosure () -> String, level: DDLogLevel = ZLLogLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil, asynchronous async: Bool = false, ddlog: DDLog = DDLog.sharedInstance) {
    _DDLogMessage(message, level: level, flag: .error, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: ddlog)
}

// MARK: ZLLANModule

func ZLLocalizedString(string: String, comment: String) -> String
{
    return ZLToolManager.sharedInstance()?.zlLANModule.localized(withKey: string) ?? string;
}
