//
//  ZMInputCollectionViewPolicyProtocol.swift
//  ZMInputCollectionViewPolicyProtocol
//
//  Created by zhumeng on 2022/7/31.
//

import Foundation

// MARK: ZMInputCollectionViewPolicyProtocol
/// ZMInputCollectionViewPolicyProtocol
public protocol ZMInputCollectionViewPolicyProtocol: AnyObject {
    
    /// 选择框策略
    ///  - Parameters:
    ///    - collectionView: ZMInputCollectionView
    ///    - didClickIndexPath: 点击的cell的indexPath
    ///    - cellDataForClickedCell: 点击的cell的cellData
    ///    - sectionData: sectionData
    ///    - completionHandler: 处理回调 changes:  数据是否修改  needFlush 是否需要flush cellData的缓存数据
    ///   请在主线程回调 completionHandler
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                             didSelectIndexPath indexPath: IndexPath,
                             cellDataForClickedCell cellData: ZMInputCollectionViewSelectCellDataType,
                             sectionData: ZMInputCollectionViewBaseSectionDataType,
                             completionHandler: @escaping (_ changed:Bool, _ needFlush:Bool) -> Void)
    
    /// 按钮策略
    ///  - Parameters:
    ///    - collectionView: ZMInputCollectionView
    ///    - didClickIndexPath: 点击的cell的indexPath
    ///    - cellDataForClickedCell: 点击的cell的cellData
    ///    - sectionData: sectionData
    ///    - completionHandler: 处理回调 changes:  数据是否修改  needFlush 是否需要flush cellData的缓存数据
    ///    请在主线程回调 completionHandler
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                             didClickIndexPath indexPath: IndexPath,
                             cellDataForClickedCell cellData: ZMInputCollectionViewButtonCellDataType,
                             sectionData: ZMInputCollectionViewBaseSectionDataType,
                             completionHandler: @escaping (_ changed:Bool, _ needFlush:Bool) -> Void)
    
    
    /// header / footer view 事件策略
    ///  - Parameters:
    ///    - collectionView: ZMInputCollectionView
    ///    - eventId: 事件id
    ///    - isHeader: 是否未section Header
    ///    - params: 参数
    ///    - section: 触发事件的section
    ///    - sectionViewData: sectionView 的 data
    ///    - sectionData: 触发事件的sectionData
    ///    - completionHandler: 处理回调 changes:  数据是否修改  needFlush 是否需要flush cellData的缓存数据
    ///    请在主线程回调 completionHandler
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                             eventId: String,
                             isHeader: Bool,
                             params: [String:Any],
                             didTriggleEventAtSection section: Int,
                             sectionViewData: ZMInputCollectionViewBaseSectionViewDataType,
                             sectionData: ZMInputCollectionViewBaseSectionDataType,
                             completionHandler: @escaping (_ changed:Bool, _ needFlush:Bool) -> Void)
}


public extension ZMInputCollectionViewPolicyProtocol {
    
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                             didSelectIndexPath indexPath: IndexPath,
                             cellDataForClickedCell cellData: ZMInputCollectionViewSelectCellDataType,
                             sectionData: ZMInputCollectionViewBaseSectionDataType,
                             completionHandler: @escaping (_ changed:Bool, _ needFlush:Bool) -> Void) {}
    
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                             didClickIndexPath indexPath: IndexPath,
                             cellDataForClickedCell cellData: ZMInputCollectionViewButtonCellDataType,
                             sectionData: ZMInputCollectionViewBaseSectionDataType,
                             completionHandler: @escaping (_ changed:Bool, _ needFlush:Bool) -> Void) {}
    
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                             eventId: String,
                             isHeader: Bool,
                             params: [String:Any],
                             didTriggleEventAtSection section: Int,
                             sectionViewData: ZMInputCollectionViewBaseSectionViewDataType,
                             sectionData: ZMInputCollectionViewBaseSectionDataType,
                             completionHandler: @escaping (_ changed:Bool, _ needFlush:Bool) -> Void) {}
}





// MARK: 默认策略 仅支持选择类型和最大选择数量
/// ZMInputCollectionViewDefaultPolicy
public class ZMInputCollectionViewDefaultPolicy: ZMInputCollectionViewPolicyProtocol {
    
    // 最多可选中的数量 0 无限制 ； 默认 1 支持单选
    public var maxSelectedNum: UInt = 1
    
    public init(maxSelectedNum: UInt = 1) {
        self.maxSelectedNum = maxSelectedNum
    }
    
    public func inputCollectionView(_ collectionView: ZMInputCollectionView,
                                    didSelectIndexPath indexPath: IndexPath,
                                    cellDataForClickedCell cellData: ZMInputCollectionViewSelectCellDataType,
                                    sectionData: ZMInputCollectionViewBaseSectionDataType,
                                    completionHandler: @escaping (_ changed:Bool, _ needFlush:Bool) -> Void) {
        if maxSelectedNum == 1 {
            
            if cellData.temporaryCellSelected {
                return
            }
            sectionData.cellDatas.forEach {
                if let selectData = $0 as? ZMInputCollectionViewSelectCellDataType {
                    selectData.temporaryCellSelected = false
                }
            }
            cellData.temporaryCellSelected = true
            completionHandler(true,false)
            
        } else if maxSelectedNum > 1 {

            if cellData.temporaryCellSelected == true {
                cellData.temporaryCellSelected = false
                completionHandler(true,false)
            } else if sectionData.cellDatas.filter({
                if let tmpSelectData = $0 as? ZMInputCollectionViewSelectCellDataType, tmpSelectData.temporaryCellSelected {
                    return true
                }
                return false
            }).count >= maxSelectedNum {
                completionHandler(false,false)
            } else {
                cellData.temporaryCellSelected = true
                completionHandler(true,false)
            }
            
        } else {
            cellData.temporaryCellSelected = !cellData.temporaryCellSelected
            completionHandler(true,false)
        }
        
    }
}

