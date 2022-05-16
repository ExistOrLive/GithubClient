//
//  ZLToastView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/27.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import Toast

@objcMembers class ZLToastView: NSObject {
    
    class func showMessage(_ message: String) {
        let window = UIApplication.shared.keyWindow
        window?.makeToast(message, duration: 3.0, position: CSToastPositionCenter)
    }
    
    class func showMessage(_ message: String, duration: TimeInterval) {
        let window = UIApplication.shared.keyWindow
        window?.makeToast(message, duration: duration, position: CSToastPositionCenter)
    }
    
    class func showMessage(_ message: String, duration: TimeInterval, sourceView: UIView) {
        sourceView.makeToast(message, duration: duration, position: CSToastPositionCenter)
    }
    
    class func showMessage(_ message: String, sourceView: UIView) {
        sourceView.makeToast(message, duration: 3.0, position: CSToastPositionCenter)
    }

}

