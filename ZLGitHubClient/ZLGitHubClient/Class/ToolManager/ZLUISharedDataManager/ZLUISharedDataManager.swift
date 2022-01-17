//
//  ZLUISharedDataManager.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/4/12.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import FirebaseRemoteConfig

private let ZLCurrentUserInterfaceStyleKey = "ZLCurrentUserInterfaceStyleKey"
private let ZLAssistButtonKey = "ZLAssistButtonKey"
private let ZLSearchRecordKey = "ZLSearchRecordKey"
private let ZLShowAllNotificationsKey = "ZLShowAllNotificationsKey"
private let ZLTrendingOptions = "trendingOptions"

@objcMembers class ZLUISharedDataManager: NSObject {

    // MARK: Config Property

    @available(iOS 12.0, *)
    static var currentUserInterfaceStyle: UIUserInterfaceStyle {
        get {
            let result = UserDefaults.standard.integer(forKey: ZLCurrentUserInterfaceStyleKey)
            return UIUserInterfaceStyle(rawValue: result) ?? .unspecified
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: ZLCurrentUserInterfaceStyleKey)
            UserDefaults.standard.synchronize()
        }
    }

    static var isAssistButtonHidden: Bool {
        get {
             UserDefaults.standard.bool(forKey: ZLAssistButtonKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ZLAssistButtonKey)
            UserDefaults.standard.synchronize()
        }
    }

    static var searchRecordArray: [String]? {
        get {
            UserDefaults.standard.object(forKey: ZLSearchRecordKey) as? [String]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ZLSearchRecordKey)
            UserDefaults.standard.synchronize()
        }
    }

    static var showAllNotifications: Bool {
        get {
             UserDefaults.standard.bool(forKey: ZLShowAllNotificationsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ZLShowAllNotificationsKey)
            UserDefaults.standard.synchronize()
        }
    }

    private static var trendingOptions: [String: ZLTrendingFilterInfoModel]? {
        get {
            if let data = UserDefaults.standard.object(forKey: ZLTrendingOptions) as? Data {
                if let result = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: ZLTrendingFilterInfoModel] {
                    return result
                }
            }

            var tmptrendingOptions = [String: ZLTrendingFilterInfoModel]()
            tmptrendingOptions["repo"] = ZLTrendingFilterInfoModel()
            tmptrendingOptions["user"] = ZLTrendingFilterInfoModel()
            return tmptrendingOptions
        }

        set {
            if let value = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: value)
                UserDefaults.standard.set(data, forKey: ZLTrendingOptions)
            } else {
                UserDefaults.standard.removeObject(forKey: ZLTrendingOptions)
            }
            UserDefaults.standard.synchronize()
        }
    }

    static var languageForTrendingRepo: String? {
        get {
            if let trendModel = self.trendingOptions?["repo"] {
                return trendModel.language
            }
            return nil
        }
        set {
            let tmpTrendingOptions = self.trendingOptions ?? [:]
            tmpTrendingOptions["repo"]?.language = newValue
            self.trendingOptions = tmpTrendingOptions
        }
    }

    static var languageForTrendingUser: String? {
        get {
            if let trendModel = self.trendingOptions?["user"] {
                return trendModel.language
            }
            return nil
        }
        set {
            let tmpTrendingOptions = self.trendingOptions ?? [:]
            tmpTrendingOptions["user"]?.language = newValue
            self.trendingOptions = tmpTrendingOptions
        }
    }

    static var dateRangeForTrendingRepo: ZLDateRange {
        get {
            if let trendModel = self.trendingOptions?["repo"] {
                return trendModel.dateRange
            }
            return ZLDateRangeDaily
        }
        set {
            let tmpTrendingOptions = self.trendingOptions ?? [:]
            tmpTrendingOptions["repo"]?.dateRange = newValue
            self.trendingOptions = tmpTrendingOptions
        }
    }

    static var dateRangeForTrendingUser: ZLDateRange {
        get {
            if let trendModel = self.trendingOptions?["user"] {
                return trendModel.dateRange
            }
            return ZLDateRangeDaily
        }
        set {
            let tmpTrendingOptions = self.trendingOptions ?? [:]
            tmpTrendingOptions["user"]?.dateRange = newValue
            self.trendingOptions = tmpTrendingOptions
        }
    }

    static var enabledBlockFunction: Bool {
        get {
            RemoteConfig.remoteConfig().configValue(forKey: "Block_Function_Enabled").boolValue
        }
    }

    static var enbaledReportFunction: Bool {
        get {
            RemoteConfig.remoteConfig().configValue(forKey: "Report_Function_Enabled").boolValue
        }
    }

}

extension ZLUISharedDataManager {

    @objc static func initRemoteConfig() {
        // 初始化google remote config
        let remoteConfig = RemoteConfig.remoteConfig()
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        remoteConfig.configSettings = setting
        // 设置默认值
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefault")
        // 获取远程配置
        remoteConfig.fetchAndActivate { status, error in
            switch status {
            case .successFetchedFromRemote, .successUsingPreFetchedData:
                print("fetch success")
            case .error:
                print(error?.localizedDescription ?? "")
            @unknown default:
                print("unknow error")
            }
        }
    }
}
