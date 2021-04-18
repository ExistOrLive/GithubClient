//
//  ZLToolManager+UIExtension.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/1/4.
//  Copyright © 2021 ZM. All rights reserved.
//

import Foundation
import ZLServiceFramework
import SYDCentralPivot

extension ZLToolManager{
    
    static let zlurlNotifcaitonModuleKey = "ZLUrlNotifcaitonModule"
        
    @objc var zlurlNotifcaitonModule :  ZLURLNotificationModuleProtocol?{
        SYDCentralFactory.sharedInstance().getCommonBean(ZLToolManager.zlurlNotifcaitonModuleKey) as? ZLURLNotificationModuleProtocol
    }
}
