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
    
    static func loginEvent(result:Int,step:Int,way:Int,error: String?){
        analytics.log(.login(result: result,step:step, way: way,error: error))
    }
    
    static func urlUse(url : String){
        analytics.log(.URLUse(url: url))
    }
    
    static func urlFailed(url : String, error: String?){
        analytics.log(.URLFailed(url: url , error: error ?? ""))
    }
    
    static func dbActionFailed(sql:String,error:String?){
        analytics.log(.DBActionFailed(sql: sql, error: error ?? ""))
    }
}




public enum ZLAppEvent {
    case login(result:Int,step:Int,way:Int,error:String?)
    case viewItem(name:String)
    case URLUse(url:String)
    case URLFailed(url:String,error:String)
    case ScreenView(screenName:String,screenClass:String)
    case SearchItem(key:String)
    case DBActionFailed(sql:String,error:String)
    case AD(success:Bool)
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
        case .URLFailed:
            return "URLFailed"
        case .ScreenView:
            return AnalyticsEventScreenView
        case .SearchItem:
            return AnalyticsEventSearch
        case .DBActionFailed:
            return "DBActionFailed"
        case .AD:
            return "Advertisement"
        }
        
        

    }
    public func parameters(for provider: ProviderType) -> [String: Any]? {
        switch self {
        case .login(let result,let step,let way,let error):
            return ["result":result,"step":step,"way":way,"error":error ?? "NULL"];
        case .viewItem(let name):
            return ["itemName":name]
        case .URLUse(let url):
            return ["url":url]
        case .URLFailed(let url, let error):
            return ["url":url,"error":error]
        case .ScreenView(let screenName, let screenClass):
            return [AnalyticsParameterScreenName:screenName,AnalyticsParameterScreenClass:screenClass]
        case .SearchItem(let key):
            return ["key":key]
        case .DBActionFailed(let sql, let error):
            return ["sql":sql,"error":error]
        case .AD(let success):
            return ["success":success]
        }
    }
}
