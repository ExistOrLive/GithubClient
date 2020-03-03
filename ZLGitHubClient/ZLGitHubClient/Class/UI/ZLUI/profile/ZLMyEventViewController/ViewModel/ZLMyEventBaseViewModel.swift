
//
//  ZLMyEventBaseViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/8.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLMyEventBaseViewModel: ZLBaseViewModel {

    private var serialNumberDic:[String:String] = [:]
    
    // view
    private weak var baseView : ZLMyEventBaseView?
    
    // model
    private var data : [ZLGithubEventModel] = []
    
    var pageNum = 1
    
    
    deinit {
        self.removeObservers()
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let baseView : ZLMyEventBaseView = targetView as? ZLMyEventBaseView else
        {
            return;
        }
        
        self.baseView = baseView
        self.baseView?.eventListView.delegate = self;
        
        self.addObservers()
    }
    
    override func vcLifeCycle_viewWillAppear()
    {
        super.vcLifeCycle_viewWillAppear()
        
        self.baseView?.eventListView.beginRefresh()
    }
}

// MARK: ZLEventListViewDelegate
extension ZLMyEventBaseViewModel : ZLEventListViewDelegate
{
    func eventListViewRefreshDragUp(eventListView: ZLEventListView) -> Void
    {
        self.queryMoreMyEventRequest(pageNum: self.pageNum, pageSize: 10)
    }
    
    func eventListViewRefreshDragDown(eventListView: ZLEventListView) -> Void
    {
        self.queryNewMyEventRequest(pageNum: 1, pageSize: 10)
    }
}

// MARK: request
extension ZLMyEventBaseViewModel
{
    static let ZLQueryMoreMyEventRequestKey = "ZLQueryMoreMyEventRequestKey"
    static let ZLQueryNewMyEventRequestKey = "ZLQueryNewMyEventRequestKey"
    
    func queryMoreMyEventRequest(pageNum: Int, pageSize: Int)
    {
        let serialNumber = NSString.generateSerialNumber()
        self.serialNumberDic.updateValue(serialNumber, forKey: ZLMyEventBaseViewModel.ZLQueryMoreMyEventRequestKey)
        
        ZLEventServiceModel.shareInstance()?.getMyEventsWithpage(UInt(pageNum), per_page: UInt(pageSize), serialNumber: serialNumber)
    }
    
    
    func queryNewMyEventRequest(pageNum: Int, pageSize: Int)
      {
          let serialNumber = NSString.generateSerialNumber()
          self.serialNumberDic.updateValue(serialNumber, forKey: ZLMyEventBaseViewModel.ZLQueryNewMyEventRequestKey)
          
          ZLEventServiceModel.shareInstance()?.getMyEventsWithpage(UInt(pageNum), per_page: UInt(pageSize), serialNumber: serialNumber)
      }
}

// MARK: Notification

extension ZLMyEventBaseViewModel
{
    func addObservers()
    {
        ZLEventServiceModel.shareInstance()?.registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLGetMyEventResult_Notification)
    }
    
    func removeObservers()
    {
        ZLEventServiceModel.shareInstance()?.unRegisterObserver(self, name: ZLGetMyEventResult_Notification)
    }
    
    @objc func onNotificationArrived(notification: Notification)
    {
        switch(notification.name)
        {
        case ZLGetMyEventResult_Notification:do{
            guard let responseObject: ZLOperationResultModel = notification.params as? ZLOperationResultModel else
            {
                return
            }
            
            if !self.serialNumberDic.values.contains(responseObject.serialNumber)
            {
                return
            }
            
            if !responseObject.result
            {
                self.baseView?.eventListView.endRefreshWithError()
                guard let errorModel : ZLGithubRequestErrorModel = responseObject.data as? ZLGithubRequestErrorModel else
                {
                    return;
                }
                
                ZLLog_Warn("get received event failed statusCode[\(errorModel.statusCode)] message[\(errorModel.message)]")
                
                return
            }
            
            var cellDataArray : [ZLEventTableViewCellData] = [];
            for eventModel in responseObject.data as! [ZLGithubEventModel]
            {
               let cellData = ZLEventTableViewCellData.getCellDataWithEventModel(eventModel: eventModel)
                self.addSubViewModel(cellData)
                cellDataArray.append(cellData)
            }
                            
            if responseObject.serialNumber == self.serialNumberDic[ZLMyEventBaseViewModel.ZLQueryMoreMyEventRequestKey]
            {
                self.serialNumberDic.removeValue(forKey: ZLMyEventBaseViewModel.ZLQueryMoreMyEventRequestKey)
                self.baseView?.eventListView.apppendCellDatas(cellDatas: cellDataArray)
                self.pageNum = self.pageNum + 1
            }
            else if responseObject.serialNumber == self.serialNumberDic[ZLMyEventBaseViewModel.ZLQueryNewMyEventRequestKey]
            {
                self.serialNumberDic.removeValue(forKey: ZLMyEventBaseViewModel.ZLQueryNewMyEventRequestKey)
                self.baseView?.eventListView.resetCellDatas(cellDatas: cellDataArray)
                self.pageNum = 2
            }
            
            
            }
        default:
            break
        }
    }
    
}
