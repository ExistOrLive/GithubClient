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
import SnapKit


// MARK: 界面常用参数

let ZLStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
let ZLSCreenHeight = UIScreen.main.bounds.size.height;
let ZLScreenWidth  = UIScreen.main.bounds.size.width;
let ZLScreenBounds = UIScreen.main.bounds;
let ZLTabBarHeight: CGFloat = 49.0

// 竖屏(安全区域)
let AreaInsetHeightTop: CGFloat = (UIScreen.main.bounds.height == 812 || UIScreen.main.bounds.height == 896) ? 44.0 : 0
let AreaInsetHeightBottom: CGFloat = (UIScreen.main.bounds.height == 812 || UIScreen.main.bounds.height == 896) ? 34.0 : 0
// 横屏(安全区域)
let AreaInsetWidthLeft: CGFloat = (UIScreen.main.bounds.width == 812 || UIScreen.main.bounds.width == 896) ? 44.0 : 0
let AreaInsetWidthRight: CGFloat = (UIScreen.main.bounds.width == 812 || UIScreen.main.bounds.width == 896) ? 34.0 : 0


//MARK: Font

let Font_PingFangSCMedium = "PingFang-SC-Medium"
let Font_PingFangSCSemiBold = "PingFang-SC-SemiBold"
let Font_PingFangSCRegular = "PingFang-SC-Regular"

// MARK: NotificationName

let ZLLoginResult_Notification = Notification.Name(rawValue: "ZLLoginResult_Notification")
let ZLLogoutResult_Notification = Notification.Name(rawValue:"ZLLogoutResult_Notification")
let ZLGetCurrentUserInfoResult_Notification = Notification.Name(rawValue: "ZLGetCurrentUserInfoResult_Notification")
let ZLGetReposResult_Notification = Notification.Name(rawValue: "ZLGetReposResult_Notification")
let ZLGetFollowersResult_Notification = Notification.Name(rawValue: "ZLGetFollowersResult_Notification")
let ZLGetFollowingResult_Notification = Notification.Name(rawValue: "ZLGetFollowingResult_Notification")
let ZLGetGistsResult_Notification = Notification.Name(rawValue: "ZLGetGistsResult_Notification")
let ZLSearchResult_Notification = Notification.Name(rawValue: "ZLSearchResult_Notification")
let ZLGetSpecifiedUserInfoResult_Notification = Notification.Name(rawValue: "ZLGetSpecifiedUserInfoResult_Notification")
let ZLGetSpecifiedRepoInfoResult_Notification  = Notification.Name(rawValue: "ZLGetSpecifiedRepoInfoResult_Notification")
let ZLUpdateUserPublicProfileInfoResult_Notification = Notification.Name(rawValue: "ZLUpdateUserPublicProfileInfoResult_Notification")
let ZLGetUserReceivedEventResult_Notification = Notification.Name(rawValue: "ZLGetUserReceivedEventResult_Notification")

let ZLLanguageTypeChange_Notificaiton = Notification.Name(rawValue: "ZLLanguageTypeChange_Notificaiton")


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

let ZLLANMODULE = ZLToolManager.sharedInstance()?.zlLANModule
func ZLLocalizedString(string: String, comment: String) -> String
{
    return ZLToolManager.sharedInstance()?.zlLANModule.localized(withKey: string) ?? string;
}






