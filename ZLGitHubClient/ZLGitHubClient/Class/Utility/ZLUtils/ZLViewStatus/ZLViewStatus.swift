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

@objc protocol ZLViewStatusProtocol {
    
    var targetView: UIView { get }
    
    var viewStatus: ZLViewStatus { get set }
}

private var viewStatusContext: UInt8 = 0
private var tipViewContext: UInt8 = 0

extension ZLViewStatusProtocol where Self : UIView {

    var targetView: UIView {
        self
    }
    
    var viewStatus: ZLViewStatus {
        set{
            objc_setAssociatedObject(self, &viewStatusContext, newValue, .OBJC_ASSOCIATION_ASSIGN)
            switch newValue {
            case .normal:
                hideProgressView()
                hideTipView()
            case .empty:
                hideProgressView()
                showTipView()
            case .loading:
                showProgressHUD()
                hideTipView()
            case .error:
                hideProgressView()
                showTipView()
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
            objc_setAssociatedObject(self, &viewStatusContext, tipView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return tipView
        }
        return tipView
    }
    
    private func showTipView() {
        targetView.addSubview(tipView)
        tipView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        targetView.bringSubviewToFront(tipView)
    }
    
    private func hideTipView() {
        tipView.removeFromSuperview()
    }
    
    private func showProgressView() {
        ZLProgressHUD.show(view: targetView, animated: true)
    }
    
    private func hideProgressView() {
        ZLProgressHUD.dismiss(view: targetView, animated: true)
    }
}



@objc class ZLViewStatusTipView: UIView {
    
    @objc override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        addSubview(containerView)
        containerView.addSubview(tagLabel)
        containerView.addSubview(descLabel)
        
        tagLabel.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize.init(width: 70, height: 60))
            make.top.left.right.equalToSuperview()
        })
        
        descLabel.snp.makeConstraints({(make) in
            make.top.equalTo(tagLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.textColor = ZLRGBValue_H(colorValue: 0x999999)
        label.textAlignment = .center
        label.font = .zlIconFont(withSize: 45)
        label.text = ZLIconFont.NoData.rawValue
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel.init()
        label.text = "No Data"
        label.textColor = ZLRGBValue_H(colorValue: 0x999999)
        label.font = .zlSemiBoldFont(withSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
}
