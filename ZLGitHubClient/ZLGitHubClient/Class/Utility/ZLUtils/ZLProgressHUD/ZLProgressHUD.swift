//
//  ZLProgressHUD.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/27.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import MBProgressHUD

@objcMembers class ZLProgressHUD: NSObject {
    
    class func show() {
        self.show(view: nil, animated: true)
    }
    
    class func dismiss() {
        self.dismiss(view: nil, animated: true)
    }
    
    class func show(view: UIView?, animated: Bool) {
        if let view = view {
            MBProgressHUD.showAdded(to: view, animated: animated)
        } else {
            if let window = UIApplication.shared.keyWindow {
                MBProgressHUD.showAdded(to: window, animated: animated)
            }
        }
    }
    
    class func dismiss(view: UIView?, animated: Bool) {
        if let view = view {
            MBProgressHUD.hide(for: view, animated: animated)
        } else {
            if let window = UIApplication.shared.keyWindow {
                MBProgressHUD.hide(for: window, animated: animated)
            }
        }
    }

}

// MARK: ProgressHUD

extension UIView {
    
    func showProgressHUD() {
        ZLProgressHUD.show(view: self, animated: true)
    }
    
    func dismissProgressHUD() {
        ZLProgressHUD.dismiss(view: self, animated: true)
    }
}
