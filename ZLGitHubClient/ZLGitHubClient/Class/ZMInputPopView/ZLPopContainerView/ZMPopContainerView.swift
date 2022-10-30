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
    
    func popContainerViewShouldChangeFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> Bool
    
    func popContainerViewShouldChangeContentViewFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> Bool
    
    func popContainerViewChangeFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect
    
    func popContainerViewChangeContentViewTargetFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect
    
    func popContainerViewChangeContentViewInitFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect
}

extension ZMPopContainerViewDelegate {
    func popContainerViewWillShow(_ view:ZMPopContainerView) {}
    
    func popContainerViewWillDismiss(_ view:ZMPopContainerView) {}
    
    func popContainerViewDidShow(_ view:ZMPopContainerView) {}
    
    func popContainerViewDidDismiss(_ view:ZMPopContainerView) {}
    
    func popContainerViewShouldChangeFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> Bool {
        false
    }
    
    func popContainerViewShouldChangeContentViewFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> Bool {
        false
    }
    
    func popContainerViewChangeFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        .zero
    }
    
    func popContainerViewChangeContentViewTargetFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        .zero
    }
    
    func popContainerViewChangeContentViewInitFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        .zero
    }
}

@objc public enum ZMPopContainerViewStatus: Int {
    case dismissed           // 收起
    case poping              // 弹出中
    case poped               // 已弹出
    case dismissing          // 收起中
    case caculatingBeforePop // 弹出前计算状态
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
    
    public var isTransition: Bool {
        status == .poping || status == .dismissing || status == .caculatingBeforePop
    }
    public private(set) var status: ZMPopContainerViewStatus = .dismissed
    @objc dynamic func inlineChangeToCaculutingBeforePopStatus() {
        guard status == .dismissed else { return }
        status = .caculatingBeforePop
    }
    
    deinit {
        removeObservers()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addObservers()
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
    
    @objc dynamic func addObservers() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceOrientataionDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc dynamic func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    // MARK: show and dismiss
    @objc dynamic open func show(_ to: UIView,
                                 contentView: UIView,
                                 contentInitFrame: CGRect,
                                 contentTargetFrame: CGRect,
                                 animationDuration: TimeInterval,
                                 completion: (()-> Void)? = nil) {
        guard status == .dismissed else { return }
        self.inline_show(to,
                         contentView: contentView,
                         contentInitFrame: contentInitFrame,
                         contentTargetFrame: contentTargetFrame,
                         animationDuration: animationDuration,
                         completion: completion)
        
    }
    
    @objc dynamic func inline_show(_ to: UIView,
                                   contentView: UIView,
                                   contentInitFrame: CGRect,
                                   contentTargetFrame: CGRect,
                                   animationDuration: TimeInterval,
                                   completion: (()-> Void)? = nil) {
        guard status == .dismissed || status == .caculatingBeforePop else { return }
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
        contentView.alpha = 0.0
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 10.0,
                       animations: {
            contentView.frame = contentTargetFrame
            contentView.alpha = 1.0
            self.background.backgroundColor = ZLRGBAValue_H(colorValue: 0x000000, alphaValue: 0.5)
            
        }) {  _ in
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
            content.alpha = 1.0
            background.backgroundColor = ZLRGBAValue_H(colorValue: 0x000000, alphaValue: 0.5)
            UIView.animate(withDuration: animated ? animationDuration : 0,
                           delay:0.0,
                           options:.curveEaseOut) {
                content.frame = self.contentInitFrame
                content.alpha = 0.0
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
    
    /// 不论浮层当前状态，强制关闭浮层
    @objc dynamic open func dismissForce(animated: Bool = true) {
        guard status != .dismissed else { return }
        let realAnimated = status == .poped && animated
        self.popDelegate?.popContainerViewWillDismiss(self)
        status = .dismissing
        
        if let content = content {
            content.frame = contentTargetFrame
            content.alpha = 1.0
            background.backgroundColor = ZLRGBAValue_H(colorValue: 0x000000, alphaValue: 0.5)
            UIView.animate(withDuration: realAnimated ? animationDuration : 0,
                           delay:0.0,
                           options:.curveEaseOut) {
                content.frame = self.contentInitFrame
                content.alpha = 0.0
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
    
    // MARK: Action
    @objc dynamic func didClickBack()  {
        dismiss()
    }
    
    @objc dynamic func onDeviceOrientataionDidChange(notification: Notification)  {
        guard status == .poped else { return }
        
        if popDelegate?.popContainerViewShouldChangeFrameWhenDeviceOrientationDidChange(self) ?? false,
           let frame = popDelegate?.popContainerViewChangeFrameWhenDeviceOrientationDidChange(self) {
            self.frame = frame
        }
        
        if popDelegate?.popContainerViewShouldChangeContentViewFrameWhenDeviceOrientationDidChange(self) ?? false,
           let targetFrame = popDelegate?.popContainerViewChangeContentViewTargetFrameWhenDeviceOrientationDidChange(self),
           let initFrame = popDelegate?.popContainerViewChangeContentViewInitFrameWhenDeviceOrientationDidChange(self) {
            self.content?.frame = targetFrame
            self.contentTargetFrame = targetFrame
            self.contentInitFrame = initFrame
        }
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

// MARK:  support contentPosition
extension ZMPopContainerView {
    @objc public dynamic func show(_ to: UIView,
                                   contentView: UIView,
                                   contentSize: CGSize,
                                   contentPoition: ZMPopContainerViewPosition,
                                   animationDuration: TimeInterval,
                                   completion: (()-> Void)? = nil ) {
        guard status == .dismissed else { return }
        
        self.inline_show(to,
                         contentView: contentView,
                         contentSize: contentSize,
                         contentPoition: contentPoition,
                         animationDuration: animationDuration,
                         completion: completion)
    }
    
    @objc dynamic func inline_show(_ to: UIView,
                                   contentView: UIView,
                                   contentSize: CGSize,
                                   contentPoition: ZMPopContainerViewPosition,
                                   animationDuration: TimeInterval,
                                   completion: (()-> Void)? = nil ) {
        guard status == .dismissed || status == .caculatingBeforePop else { return }
        inlineChangeToCaculutingBeforePopStatus()
        
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
            let scale: CGFloat = 0.85
            contentInitFrame = CGRect(origin: CGPoint(x: ( frame.width - contentSize.width * scale) / 2, y: ( frame.height - contentSize.height * scale) / 2), size:CGSize(width: contentSize.width * scale, height: contentSize.height * scale))
            contentTargetFrame = CGRect(origin: CGPoint(x: (frame.width - contentSize.width) / 2, y: (frame.height - contentSize.height) / 2), size: contentSize)
        }
        
        self.inline_show(to,
                         contentView: contentView,
                         contentInitFrame: contentInitFrame,
                         contentTargetFrame: contentTargetFrame,
                         animationDuration: animationDuration,
                         completion: completion)
    }
}
