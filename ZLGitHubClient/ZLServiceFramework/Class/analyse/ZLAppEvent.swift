//
//  ZLAppEvent.swift
//  ZLServiceFramework
//
//  Created by 朱猛 on 2021/4/2.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import Firebase
import Umbrella

public let analytics : Umbrella.Analytics<ZLAppEvent> = {
    let tmpAnalytics =  Umbrella.Analytics<ZLAppEvent>()
    tmpAnalytics.register(provider:SegmentProvider())
    tmpAnalytics.register(provider:ZLFirebaseProvider())
    return tmpAnalytics
}()


final class BuglyProvider: ProviderType {
  func log(_ eventName: String, parameters: [String: Any]?) {
    ZLBuglyManager.shared().log(eventName, parameters: parameters)
  }
}

final class ZLFirebaseProvider : ProviderType {
    func log(_ eventName: String, parameters: [String : Any]?) {
        Firebase.Analytics.logEvent(eventName, parameters: parameters)
    }
}


@objcMembers public class ZLAppEventForOC : NSObject {
    
    // result 0 成功 1 失败 2 手动停止
    // step 失败时的进度
    // way 0 auth 登陆  1 token登陆
    
    static func loginEvent(result:Int, step:Int,way:Int){
        analytics.log(.login(result: result,step:step, way: way))
    }
    
    static func urlUser(url : String){
        analytics.log(.URLUse(url: url))
    }
}


public enum ZLAppEvent {
    case login(result:Int,step:Int,way:Int)
    case viewItem(name:String)
    case URLUse(url:String)
    case ScreenView(screenName:String,screenClass:String)
    case SearchItem(key:String)
}

extension ZLAppEvent : EventType {
    public func name(for provider: ProviderType) -> String? {
        switch self {
        case .login:
            return  AnalyticsEventLogin
        case .viewItem:
            return AnalyticsEventViewItem
        case .URLUse:
            return "URLUse"
        case .ScreenView:
            return AnalyticsEventScreenView
        case .SearchItem:
            return AnalyticsEventSearch
        }
        

    }
    public func parameters(for provider: ProviderType) -> [String: Any]? {
        switch self {
        case .login(let result,let step,let way):
            return ["result":result,"step":step,"way":way];
        case .viewItem(let name):
            return ["itemName":name]
        case .URLUse(let url):
            return ["url":url]
        case .ScreenView(let screenName, let screenClass):
            return [AnalyticsParameterScreenName:screenName,AnalyticsParameterScreenClass:screenClass]
        case .SearchItem(let key):
            return ["key":key]
        }
    }
}
