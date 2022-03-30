//
//  UIView+ZLExtension.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/16.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import UIKit

// MARK: Common
extension UIView {

    // 获取View的VC
    var viewController: UIViewController? {
        var currentResponder: UIResponder = self
        while let nextResponder = currentResponder.next {
            if let vc = nextResponder as? UIViewController {
                return vc
            } else {
                currentResponder = nextResponder
            }
        }
        return nil
    }
}
