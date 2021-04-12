//
//  ZLUISharedDataManager.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/4/12.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

fileprivate let ZLCurrentUserInterfaceStyleKey = "ZLCurrentUserInterfaceStyleKey"
fileprivate let ZLAssistButtonKey = "ZLAssistButtonKey"
fileprivate let ZLSearchRecordKey = "ZLSearchRecordKey"
fileprivate let ZLShowAllNotificationsKey = "ZLShowAllNotificationsKey"
fileprivate let ZLTrendingOptions = "trendingOptions"


@objcMembers class ZLUISharedDataManager: NSObject {
    
    @available(iOS 12.0, *)
    static var currentUserInterfaceStyle: UIUserInterfaceStyle {
        get{
            let result = UserDefaults.standard.integer(forKey: ZLCurrentUserInterfaceStyleKey)
            return UIUserInterfaceStyle(rawValue: result) ?? .unspecified
        }
        set{
            UserDefaults.standard.set(newValue.rawValue, forKey: ZLCurrentUserInterfaceStyleKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isAssistButtonHidden: Bool {
        get{
             UserDefaults.standard.bool(forKey: ZLAssistButtonKey)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: ZLAssistButtonKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var searchRecordArray: [String]? {
        get{
            UserDefaults.standard.object(forKey:ZLSearchRecordKey) as? [String]
        }
        set{
            UserDefaults.standard.set(newValue, forKey: ZLSearchRecordKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var showAllNotifications: Bool {
        get{
             UserDefaults.standard.bool(forKey: ZLShowAllNotificationsKey)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: ZLShowAllNotificationsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    private static var trendingOptions: [String:ZLTrendingFilterInfoModel]? {
        get{
            if let data = UserDefaults.standard.object(forKey:ZLTrendingOptions) as? Data {
                if let result = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:ZLTrendingFilterInfoModel] {
                    return result
                }
            }
            
            var tmptrendingOptions = [String:ZLTrendingFilterInfoModel]()
            tmptrendingOptions["repo"] = ZLTrendingFilterInfoModel()
            tmptrendingOptions["user"] = ZLTrendingFilterInfoModel()
//            let data = NSKeyedArchiver.archivedData(withRootObject: tmptrendingOptions)
//            UserDefaults.standard.set(data, forKey: ZLTrendingOptions)
//            UserDefaults.standard.synchronize()
            return tmptrendingOptions
        }

        set{
            if newValue != nil {
                let data = NSKeyedArchiver.archivedData(withRootObject: newValue!)
                UserDefaults.standard.set(data, forKey: ZLTrendingOptions)
            } else {
                UserDefaults.standard.removeObject(forKey:ZLTrendingOptions)
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    
    static var languageForTrendingRepo: String? {
        get{
            if let trendModel = self.trendingOptions?["repo"] {
                return trendModel.language
            }
            return nil
        }
        set{
            let tmpTrendingOptions = self.trendingOptions!
            tmpTrendingOptions["repo"]?.language = newValue
            self.trendingOptions = tmpTrendingOptions
        }
    }
    
    static var languageForTrendingUser: String? {
        get{
            if let trendModel = self.trendingOptions?["user"] {
                return trendModel.language
            }
            return nil
        }
        set{
            let tmpTrendingOptions = self.trendingOptions!
            tmpTrendingOptions["user"]?.language = newValue
            self.trendingOptions = tmpTrendingOptions
        }
    }
    
    static var dateRangeForTrendingRepo: ZLDateRange {
        get{
            if let trendModel = self.trendingOptions?["repo"] {
                return trendModel.dateRange
            }
            return ZLDateRangeDaily
        }
        set{
            let tmpTrendingOptions = self.trendingOptions!
            tmpTrendingOptions["repo"]?.dateRange = newValue
            self.trendingOptions = tmpTrendingOptions
        }
    }
    
    
    static var dateRangeForTrendingUser: ZLDateRange {
        get{
            if let trendModel = self.trendingOptions?["user"] {
                return trendModel.dateRange
            }
            return ZLDateRangeDaily
        }
        set{
            let tmpTrendingOptions = self.trendingOptions!
            tmpTrendingOptions["user"]?.dateRange = newValue
            self.trendingOptions = tmpTrendingOptions
        }
    }
    
        
    

}

