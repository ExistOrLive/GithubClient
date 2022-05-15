//
//  ZLViewStatus.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/27.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import UIKit
import ZLBaseExtension

@objc enum ZLViewStatus: Int {
    case loading = 0
    case normal
    case error
    case empty
}

// MARK: ZLViewStatusProtocol

protocol ZLViewStatusProtocol {
    
    var targetView: UIView { get }
    var viewStatus: ZLViewStatus { get set }
}

private var viewStatusContext: UInt8 = 0
private var tipViewContext: UInt8 = 0


// MARK: ZLViewStatusProtocol + UIView
extension ZLViewStatusProtocol where Self : UIView {

    var targetView: UIView {
        self
    }
    
    var viewStatus: ZLViewStatus {
        set{
            objc_setAssociatedObject(self, &viewStatusContext, newValue, .OBJC_ASSOCIATION_ASSIGN)
            switch newValue {
            case .normal:
                hideTipView()
            case .empty:
                showTipView()
                tipView.showPlaceholderView()
            case .loading:
                showTipView()
                tipView.showProgressView()
            case .error:
                showTipView()
                tipView.showPlaceholderView()
            }
        }
        get{
            guard let value = objc_getAssociatedObject(self, &viewStatusContext) as? ZLViewStatus else {
                return .normal
            }
            return value
        }
    }
    
    private var tipView: ZLViewStatusTipView {
        guard let tipView = objc_getAssociatedObject(self, &tipViewContext) as? ZLViewStatusTipView else {
            let tipView = ZLViewStatusTipView()
            objc_setAssociatedObject(self, &tipViewContext, tipView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return tipView
        }
        return tipView
    }
    
    private func showTipView() {
        
        if tipView.superview == nil {
            targetView.addSubview(tipView)
            tipView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalToSuperview()
            }
        }
        targetView.bringSubviewToFront(tipView)
    }
    
    private func hideTipView() {
        tipView.removeFromSuperview()
    }
    
}



