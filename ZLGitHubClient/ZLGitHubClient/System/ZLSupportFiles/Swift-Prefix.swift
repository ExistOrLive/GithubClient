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
import Toast_Swift
import JXSegmentedView
import Charts
import FWPopupView
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


//MARK: Font

let Font_PingFangSCMedium = "PingFang-SC-Medium"
let Font_PingFangSCSemiBold = "PingFang-SC-SemiBold"
let Font_PingFangSCRegular = "PingFang-SC-Regular"

//MARK: Color

func ZLRGBValue_H(colorValue: UInt) -> UIColor
{
    return UIColor(rgb: colorValue, alpha: 1.0)
}

func ZLRGBAValue_H(colorValue: UInt, alphaValue: CGFloat) -> UIColor
{
    return UIColor(rgb: colorValue, alpha: alphaValue)
}

func ZLRGBValueStr_H(colorValue: String) -> UIColor
{
    return UIColor(hexString: colorValue, alpha: 1.0)
}

func ZLRGBValueStr_H(colorValue: String, alphaValue: CGFloat) -> UIColor
{
    return UIColor(hexString: colorValue, alpha: Float(alphaValue))
}

func ZLRawColor(name: String) -> UIColor?{
    
    if let color = UIColor(named: name) {
        return UIColor(cgColor: color.cgColor)
    } else {
        return nil
    }
}

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


