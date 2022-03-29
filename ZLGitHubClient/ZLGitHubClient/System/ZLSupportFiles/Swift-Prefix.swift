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
import MJRefresh
import JXSegmentedView
import Charts
import ZLGitRemoteService
import SYDCentralPivot

// MARK: ZLLANModule
public var LANMODULE : ZLLanguageModuleProtocol?{
    SYDCentralFactory.sharedInstance().getCommonBean("ZLLANModule") as? ZLLanguageModuleProtocol
}

public func ZLLocalizedString(string: String, comment: String) -> String{
    return LANMODULE?.localized(withKey: string) ?? comment
}

public let ZLLanguageTypeChange_Notificaiton = Notification.Name(rawValue: "ZLLanguageTypeChange_Notificaiton")


// MARK: notification
let ZLUserInterfaceStyleChange_Notification = Notification.Name("ZLUserInterfaceStyleChange_Notification")

// MARK: 界面常用参数

var ZLStatusBarHeight : CGFloat {
    UIApplication.shared.statusBarFrame.size.height
}

var ZLKeyWindowHeight : CGFloat {
    if let window = UIApplication.shared.delegate?.window {
        return window?.frame.size.height ?? 0
    }
    return 0
}

var ZLKeyWindowWidth : CGFloat {
    if let window = UIApplication.shared.delegate?.window {
        return window?.frame.size.width ?? 0
    }
    return 0
}

var ZLSCreenHeight : CGFloat {
    UIScreen.main.bounds.size.height
}
var ZLScreenWidth : CGFloat {
    UIScreen.main.bounds.size.width;
}
var ZLScreenBounds : CGRect {
    UIScreen.main.bounds
}

var ZLSafeAreaBottomHeight: CGFloat {
    if let window = UIApplication.shared.delegate?.window {
        return window?.safeAreaInsets.bottom ?? 0
    }
    return 0
}

var ZLSafeAreaTopHeight: CGFloat {
    if let window = UIApplication.shared.delegate?.window {
        return window?.safeAreaInsets.top ?? 0
    }
    return 0
}

var ZLSeperateLineHeight: CGFloat = 1.0 / UIScreen.main.scale


//MARK: Font

let Font_PingFangSCMedium = "PingFang-SC-Medium"
let Font_PingFangSCSemiBold = "PingFang-SC-SemiBold"
let Font_PingFangSCRegular = "PingFang-SC-Regular"


@available(iOS 12.0, *)
func getRealUserInterfaceStyle() -> UIUserInterfaceStyle {
    if ZLUISharedDataManager.currentUserInterfaceStyle == .unspecified {
        if  let color = UIColor(named: "TestColor") {
            if color.cgColor.components?[0] ?? 1.0 == 1.0 {
                return .light
            } else {
                return .dark
            }
        } else {
            return .light
        }
    } else {
        return ZLUISharedDataManager.currentUserInterfaceStyle
    }
    
   
}


