//
//  ZLAssistButtonManager.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/1/5.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

let ZLAssistButtonShowOrHiddenNotification = Notification.Name("AssistButtonShowOrHiddenNotification")

@objcMembers class ZLAssistButtonManager: NSObject {
    

    private let floatButtonView: ZLFloatView
    private let assistButton: UIButton

    private var floatCircleWindow: ZLFloatWindow?

    static let shared = ZLAssistButtonManager()

    static public func sharedInstance() -> ZLAssistButtonManager {
        return shared
    }

    override init() {
        floatButtonView = ZLFloatView.init()
        assistButton = UIButton.init(type: .custom)
        super.init()

        let config = ZLFloatViewConfig()
        config.bounces = true
        config.canPan = true
        floatButtonView.config = config
        floatButtonView.frame = CGRect(x: 0, y: ZLKeyWindowHeight / 2, width: 60, height: 60)

        assistButton.setImage(UIImage(named: "assitbutton"), for: .normal)
        assistButton.addTarget(self, action: #selector(onAssistButtonClicked), for: .touchUpInside)
        assistButton.bounds = CGRect(x: 0, y: 0, width: 55, height: 55)
        assistButton.center = CGPoint(x: 30, y: 30)
        assistButton.backgroundColor = UIColor.clear
        floatButtonView.addSubview(assistButton)
    }

    func ajustAssistButtonPosition() {
        floatButtonView.frame = floatButtonView.frame
    }

    func setHidden(_ hidden: Bool) {
        self.floatButtonView.isHidden = hidden
        self.floatButtonView.window?.isHidden = hidden
        NotificationCenter.default.post(name: ZLAssistButtonShowOrHiddenNotification, object: nil)
    }

    func dismissAssistDetailView() {
        self.floatButtonView.isHidden = false
        self.floatButtonView.window?.isHidden = false
        self.floatCircleWindow?.isHidden = true
        self.floatCircleWindow = nil
    }

    deinit {
        self.floatButtonView.isHidden = true
        self.floatButtonView.removeFromSuperview()
    }

    func onAssistButtonClicked() {

        if self.floatCircleWindow == nil {

            self.floatButtonView.isHidden = true
            self.floatButtonView.window?.isHidden = true

            self.floatCircleWindow = ZLFloatWindow()
            if #available(iOS 13.0, *) {
                self.floatCircleWindow?.overrideUserInterfaceStyle = ZLUISharedDataManager.currentUserInterfaceStyle
            }
            self.floatCircleWindow?.frame = UIApplication.shared.delegate?.window??.bounds ?? UIScreen.main.bounds
            self.floatCircleWindow?.backgroundColor = UIColor(named: "ZLVCBackColor")

            self.floatCircleWindow?.rootViewController = ZLAssistController()

            self.floatCircleWindow?.isHidden = false

        }
    }

}
