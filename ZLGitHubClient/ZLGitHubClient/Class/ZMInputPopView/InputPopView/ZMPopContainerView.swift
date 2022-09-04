//
//  ZMPopContainerView.swift
//  ZMPopContainerView
//
//  Created by zhumeng on 2022/6/25.
//

import Foundation
import UIKit
import SnapKit
import ZLBaseExtension

@objc public enum ZMPopContainerViewPosition: Int {
    case top
    case left
    case right
    case bottom
    case center
}

public protocol ZMPopContainerViewDelegate: AnyObject {
    
    func popContainerViewWillShow(_ view:ZMPopContainerView)
    
    func popContainerViewWillDismiss(_ view:ZMPopContainerView)
    
    func popContainerViewDidShow(_ view:ZMPopContainerView)
    
    func popContainerViewDidDismiss(_ view:ZMPopContainerView)
}

extension ZMPopContainerViewDelegate {
    func popContainerViewWillShow(_ view:ZMPopContainerView) {}
     
    func popContainerViewWillDismiss(_ view:ZMPopContainerView) {}
    
    func popContainerViewDidShow(_ view:ZMPopContainerView) {}
    
    func popContainerViewDidDismiss(_ view:ZMPopContainerView) {}
}

@objc public enum ZMPopContainerViewStatus: Int {
    case dismissed           // 收起
    case poping              // 弹出中
    case poped               // 已弹出
    case dismissing          // 收起中
}

@objc open class ZMPopContainerView: UIView, UIGestureRecognizerDelegate {
    
    var content: UIView?
    
    var contentInitFrame: CGRect = .zero
    
    var contentTargetFrame: CGRect = .zero
    
    var animationDuration: TimeInterval = 0
    
    public weak var popDelegate: ZMPopContainerViewDelegate?
    
    public var hasPoped: Bool {
        status == .poped
    }
    
    public private(set) var status: ZMPopContainerViewStatus = .dismissed
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private dynamic func setupUI() {
        backgroundColor = .clear
        layer.masksToBounds = true 
        addSubview(background)
        
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc dynamic open func show(_ to: UIView,
                            contentView: UIView,
                            contentInitFrame: CGRect,
                            contentTargetFrame: CGRect,
                            animationDuration: TimeInterval,
                            completion: (()-> Void)? = nil) {
        guard status == .dismissed else { return }
        self.popDelegate?.popContainerViewWillShow(self)
        status = .poping
        
        content = contentView
        self.contentInitFrame = contentInitFrame
        self.contentTargetFrame = contentTargetFrame
        self.animationDuration = animationDuration
        
        to.addSubview(self)
        
        background.addSubview(contentView)
        background.backgroundColor = ZLRGBAValue_H(colorValue: 0x000000, alphaValue: 0)
        contentView.frame = contentInitFrame
        UIView.animate(withDuration: animationDuration,
                       animations: {
            contentView.frame = contentTargetFrame
            self.background.backgroundColor = ZLRGBAValue_H(colorValue: 0x000000, alphaValue: 0.5)
            
        }) { _ in
            self.status = .poped
            self.popDelegate?.popContainerViewDidShow(self)
            completion?()
        }
        
        
    }
    
    @objc dynamic open func dismiss(animated: Bool = true) {
        guard status == .poped else { return }
        self.popDelegate?.popContainerViewWillDismiss(self)
        status = .dismissing
        
        if let content = content {
            content.frame = contentTargetFrame
            background.backgroundColor = ZLRGBAValue_H(colorValue: 0x000000, alphaValue: 0.5)
            UIView.animate(withDuration: animated ? animationDuration : 0) {
                content.frame = self.contentInitFrame
                self.background.backgroundColor = ZLRGBAValue_H(colorValue: 0x000000, alphaValue: 0)
            } completion: {  (_) in
                for view in self.background.subviews {
                    view.removeFromSuperview()
                }
                self.content = nil
                self.removeFromSuperview()
                self.popDelegate?.popContainerViewDidDismiss(self)
                self.status = .dismissed
            }
        } else {
            for view in background.subviews {
                view.removeFromSuperview()
            }
            background.backgroundColor = ZLRGBAValue_H(colorValue: 0x000000, alphaValue: 0)
            self.content = nil
            removeFromSuperview()
            self.popDelegate?.popContainerViewDidDismiss(self)
            status = .dismissed
        }
    }
    
    @objc dynamic func didClickBack()  {
        dismiss()
    }
    
    // MARK: Lazy View
    @objc public lazy dynamic var background: UIView = {
        let view = UIView()
        view.backgroundColor = ZLRGBAValue_H(colorValue: 0x000000, alphaValue: 0)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didClickBack))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.location(in: background)
        let contentPoint = background.convert(point, to: content)
        if content?.point(inside: contentPoint, with: nil) ?? false {
            return false
        }
        return true
    }
}

/// suppoert contentPosition
public extension ZMPopContainerView {
    @objc dynamic func show(_ to: UIView,
                            contentView: UIView,
                            contentSize: CGSize,
                            contentPoition: ZMPopContainerViewPosition,
                            animationDuration: TimeInterval,
                            completion: (()-> Void)? = nil ) {
        
        var contentInitFrame = CGRect.zero
        var contentTargetFrame = CGRect.zero
        
        switch contentPoition {
        case .top:
            contentInitFrame = CGRect(origin: CGPoint(x: (frame.width - contentSize.width) / 2, y: -contentSize.height), size: contentSize)
            contentTargetFrame = CGRect(origin: CGPoint(x: (frame.width - contentSize.width) / 2, y: 0), size: contentSize)
        case .left:
            contentInitFrame = CGRect(origin: CGPoint(x: -contentSize.width, y: (frame.height - contentSize.height) / 2 ), size: contentSize)
            contentTargetFrame = CGRect(origin: CGPoint(x: 0, y: (frame.height - contentSize.height) / 2 ), size: contentSize)
        case .right:
            contentInitFrame = CGRect(origin: CGPoint(x: frame.width, y: (frame.height - contentSize.height) / 2 ), size: contentSize)
            contentTargetFrame = CGRect(origin: CGPoint(x: frame.width - contentSize.width, y: (frame.height - contentSize.height) / 2 ), size: contentSize)
        case .bottom:
            contentInitFrame = CGRect(origin: CGPoint(x: (frame.width - contentSize.width) / 2, y: frame.height), size: contentSize)
            contentTargetFrame = CGRect(origin: CGPoint(x: (frame.width - contentSize.width) / 2, y: frame.height - contentSize.height), size: contentSize)
        case .center:
            contentInitFrame = CGRect(origin: CGPoint(x: frame.width / 2, y: frame.height / 2), size:.zero)
            contentTargetFrame = CGRect(origin: CGPoint(x: (frame.width - contentSize.width) / 2, y: (frame.height - contentSize.height) / 2), size: contentSize)
        }
        
        self.show(to,
                  contentView: contentView,
                  contentInitFrame: contentInitFrame,
                  contentTargetFrame: contentTargetFrame,
                  animationDuration: animationDuration,
                  completion: completion)
    }
}
