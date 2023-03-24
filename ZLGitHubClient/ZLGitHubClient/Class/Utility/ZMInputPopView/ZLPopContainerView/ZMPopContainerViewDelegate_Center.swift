//
//  ZMPopContainerViewPopDelegate.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2023/2/22.
//  Copyright © 2023 ZM. All rights reserved.
//

import Foundation
import UIKit
import ZLGitRemoteService

class ZMPopContainerViewDelegate_Center: NSObject, ZMPopContainerViewDelegate {
    
    static let shared = ZMPopContainerViewDelegate_Center()
    
    func popContainerViewShouldChangeFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> Bool {
        ZLDeviceInfo.isIpad()
    }
    
    func popContainerViewShouldChangeContentViewFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> Bool {
        ZLDeviceInfo.isIpad()
    }
    
    func popContainerViewChangeFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        return ZLScreenBoundsAdjustWithScreenOrientation
    }
    
    func popContainerViewChangeContentViewTargetFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        guard let contentView = view.content else {
            return .zero
        }
        let origin = CGPoint(x: (view.frame.width - contentView.frame.width) / 2,
                             y: (view.frame.height - contentView.frame.height) / 2)
        return CGRect(origin: origin, size: contentView.frame.size)
    }
    
    func popContainerViewChangeContentViewInitFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        let origin = CGPoint(x: view.frame.width / 2 , y: view.frame.height / 2 )
        return CGRect(origin: origin, size: .zero)
    }
    
}
