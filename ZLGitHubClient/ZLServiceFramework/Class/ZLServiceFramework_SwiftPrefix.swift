//
//  ZLServiceFramework_SwiftPrefix.swift
//  ZLServiceFramework
//
//  Created by 朱猛 on 2020/12/30.
//  Copyright © 2020 ZM. All rights reserved.
//

import Foundation
import CocoaLumberjack

// MARK: NotificationName

public let ZLLoginResult_Notification = Notification.Name(rawValue: "ZLLoginResult_Notification")
public let ZLLogoutResult_Notification = Notification.Name(rawValue:"ZLLogoutResult_Notification")
public let ZLGetCurrentUserInfoResult_Notification = Notification.Name(rawValue: "ZLGetCurrentUserInfoResult_Notification")
public let ZLGetReposResult_Notification = Notification.Name(rawValue: "ZLGetReposResult_Notification")
public let ZLGetFollowersResult_Notification = Notification.Name(rawValue: "ZLGetFollowersResult_Notification")
public let ZLGetFollowingResult_Notification = Notification.Name(rawValue: "ZLGetFollowingResult_Notification")
public let ZLGetGistsResult_Notification = Notification.Name(rawValue: "ZLGetGistsResult_Notification")
public let ZLSearchResult_Notification = Notification.Name(rawValue: "ZLSearchResult_Notification")
public let ZLGetSpecifiedUserInfoResult_Notification = Notification.Name(rawValue: "ZLGetSpecifiedUserInfoResult_Notification")
public let ZLGetSpecifiedRepoInfoResult_Notification  = Notification.Name(rawValue: "ZLGetSpecifiedRepoInfoResult_Notification")
public let ZLUpdateUserPublicProfileInfoResult_Notification = Notification.Name(rawValue: "ZLUpdateUserPublicProfileInfoResult_Notification")
public let ZLGetUserReceivedEventResult_Notification = Notification.Name(rawValue: "ZLGetUserReceivedEventResult_Notification")
public let ZLGetMyEventResult_Notification = Notification.Name(rawValue: "ZLGetMyEventResult_Notification")

public let ZLLanguageTypeChange_Notificaiton = Notification.Name(rawValue: "ZLLanguageTypeChange_Notificaiton")

public let ZLGithubConfigUpdate_Notification = Notification.Name(rawValue: "ZLGithubConfigUpdate_Notification")


public extension Notification
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
public let ZLLogLevel = DDLogLevel.debug
#else
public let ZLLogLevel = DDLogLevel.info
#endif

public func ZLLog_Debug(_ message: @autoclosure () -> String, level: DDLogLevel = ZLLogLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil, asynchronous async: Bool = true, ddlog: DDLog = DDLog.sharedInstance) {
    _DDLogMessage(message(), level: level, flag: .debug, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: ddlog)
}

public func ZLLog_Info(_ message: @autoclosure () -> String, level: DDLogLevel = ZLLogLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil, asynchronous async: Bool = true, ddlog: DDLog = DDLog.sharedInstance) {
    _DDLogMessage(message(), level: level, flag: .info, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: ddlog)
}

public func ZLLog_Warn(_ message: @autoclosure () -> String, level: DDLogLevel = ZLLogLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil, asynchronous async: Bool = true, ddlog: DDLog = DDLog.sharedInstance) {
    _DDLogMessage(message(), level: level, flag: .warning, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: ddlog)
}

public func ZLLog_Verbose(_ message: @autoclosure () -> String, level: DDLogLevel = ZLLogLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil, asynchronous async: Bool = true, ddlog: DDLog = DDLog.sharedInstance) {
    _DDLogMessage(message(), level: level, flag: .verbose, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: ddlog)
}

public func ZLLog_Error(_ message: @autoclosure () -> String, level: DDLogLevel = ZLLogLevel, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, tag: Any? = nil, asynchronous async: Bool = false, ddlog: DDLog = DDLog.sharedInstance) {
    _DDLogMessage(message(), level: level, flag: .error, context: context, file: file, function: function, line: line, tag: tag, asynchronous: async, ddlog: ddlog)
}

// MARK: ZLLANModule

public let ZLLANMODULE = ZLToolManager.sharedInstance()?.zlLANModule
public func ZLLocalizedString(string: String, comment: String) -> String
{
    return ZLToolManager.sharedInstance()?.zlLANModule.localized(withKey: string) ?? string;
}

// MARK: Dispatch

public func ZLMainThreadDispatch(_ block : @escaping ()->Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}




