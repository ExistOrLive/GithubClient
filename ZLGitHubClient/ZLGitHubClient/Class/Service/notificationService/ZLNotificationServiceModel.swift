//
//  ZLNotificationServiceModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/8.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit


/**
 Swift实现单例的方式
 
 1.  定义一个全局常量：
 
 1et sharedInstance = ZLNotificationController()
 
 swift中全局变量的初始化默认使用dispatch-once保证了初始化的原子性，是线程安全的；
 全局变量是懒加载的
 
 2.  定义static 或者 class 变量 ,
 
 
 class ZLNotificationServiceModel: ZLBaseServiceModel {
 
 static let sharedInstance : ZLNotificationServiceModel = ZLNotificationServiceModel.init()
 }
 
 
 
 
 */


class ZLNotificationServiceModel: ZLBaseServiceModel {
    
    private static let shared : ZLNotificationServiceModel = ZLNotificationServiceModel.init()
    
    override init() {
        super.init()
    }
    
    static func sharedInstance() ->ZLNotificationServiceModel{
        return shared
    }
    
    func getNoticaitions(showAll: Bool, page: UInt, per_page: UInt, serialNumber : String, completeHandle: ((ZLOperationResultModel) -> Void)?) {
        
        let githubResponse = {(result : Bool, responseObject : Any, serialNumber : String) in
            
            let resultModel : ZLOperationResultModel = ZLOperationResultModel()
            resultModel.result = result
            resultModel.data = responseObject
            resultModel.serialNumber = serialNumber
            
            if completeHandle != nil {
                DispatchQueue.main.sync {
                    completeHandle!(resultModel)
                }
            }
            
        }
        
        ZLGithubHttpClient.default().getNotification(githubResponse,showAll: showAll,page: page, per_page: per_page, serialNumber: serialNumber)
        
    }
    
    func markNotificationRead(notificationId: String, serialNumber : String, completeHandle: ((ZLOperationResultModel) -> Void)?) {
        
        let githubResponse = {(result : Bool, responseObject : Any, serialNumber : String) in
            
            let resultModel : ZLOperationResultModel = ZLOperationResultModel()
            resultModel.result = result
            resultModel.data = responseObject
            resultModel.serialNumber = serialNumber
            
            if completeHandle != nil {
                DispatchQueue.main.sync {
                    completeHandle!(resultModel)
                }
            }
            
        }
        
        ZLGithubHttpClient.default().markNotificationRead(githubResponse, notificationId: notificationId, serialNumber: serialNumber)
    }
    
    
}
