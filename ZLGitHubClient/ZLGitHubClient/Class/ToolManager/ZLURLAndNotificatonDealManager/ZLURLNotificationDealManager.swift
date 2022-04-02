//
//  ZLURLNotificationDealManager.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/1/4.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import Foundation

@objc protocol ZLURLNotificationModuleProtocol: NSObjectProtocol {
     func addURLFromOtherAppOrWidget(url: URL)
}

@objcMembers class ZLURLNotificationDealManager: NSObject, ZLURLNotificationModuleProtocol {

    private static let shared = ZLURLNotificationDealManager()

    static func sharedInstance() -> ZLURLNotificationDealManager {
        ZLURLNotificationDealManager.shared
    }

    var urlForDeal: URL?

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(onApplicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func onApplicationDidBecomeActive() {
        if ZLServiceManager.sharedInstance.loginServiceModel?.accessToken?.count ?? 0 > 0, let url = self.urlForDeal {
            ZLUIRouter.openURL(url: url)
            self.urlForDeal = nil
        }
    }

}

extension ZLURLNotificationDealManager {

    func addURLFromOtherAppOrWidget(url: URL) {
        self.urlForDeal = url
    }
}
