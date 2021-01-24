//
//  ZLNotificationServiceHeader.swift
//  ZLServiceFramework
//
//  Created by 朱猛 on 2020/12/31.
//  Copyright © 2020 ZM. All rights reserved.
//

import Foundation

@objc public protocol ZLNotificationServiceModuleProtocol : ZLBaseServiceModuleProtocol {
    
    func getNoticaitions(showAll: Bool, page: UInt, per_page: UInt, serialNumber : String, completeHandle: ((ZLOperationResultModel) -> Void)?)
    
    func markNotificationRead(notificationId: String, serialNumber : String, completeHandle: ((ZLOperationResultModel) -> Void)?)
    
}
