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
    ///    - sectionCellDatas: 点击的cell的section的celldata数组
    ///    - sectionDatas: 所有的sectionData
    ///    - completionHandler: 处理回调 changes:  数据是否修改  needFlush 是否需要flush cellData的缓存数据
    ///   请在主线程回调 completionHandler
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                             didSelectIndexPath indexPath: IndexPath,
                             cellDataForClickedCell cellData: ZMInputCollectionViewSelectCellDataType,
                             sectionCellDatas: [ZMInputCollectionViewBaseCellDataType],
                             sectionDatas: [ZMInputCollectionViewSectionDataType],
                             completionHandler: @escaping (_ changed:Bool, _ needFlush:Bool) -> Void)
    
    /// 按钮策略
    ///  - Parameters:
    ///    - collectionView: ZMInputCollectionView
    ///    - didClickIndexPath: 点击的cell的indexPath
    ///    - cellDataForClickedCell: 点击的cell的cellData
    ///    - sectionCellDatas: 点击的cell的section的celldata数组
    ///    - sectionDatas: 所有的sectionData
    ///    - completionHandler: 处理回调 changes:  数据是否修改  needFlush 是否需要flush cellData的缓存数据
    ///    请在主线程回调 completionHandler
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                             didClickIndexPath indexPath: IndexPath,
                             cellDataForClickedCell cellData: ZMInputCollectionViewButtonCellDataType,
                             sectionCellDatas: [ZMInputCollectionViewBaseCellDataType],
                             sectionDatas: [ZMInputCollectionViewSectionDataType],
                             completionHandler: @escaping (_ changed:Bool, _ needFlush:Bool) -> Void)
}


public extension ZMInputCollectionViewPolicyProtocol {
    
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                             didSelectIndexPath indexPath: IndexPath,
                             cellDataForClickedCell cellData: ZMInputCollectionViewSelectCellDataType,
                             sectionCellDatas: [ZMInputCollectionViewBaseCellDataType],
                             sectionDatas: [ZMInputCollectionViewSectionDataType],
                             completionHandler: @escaping (_ changed:Bool, _ needFlush:Bool) -> Void) {}
    
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                             didClickIndexPath indexPath: IndexPath,
                             cellDataForClickedCell cellData: ZMInputCollectionViewButtonCellDataType,
                             sectionCellDatas: [ZMInputCollectionViewBaseCellDataType],
                             sectionDatas: [ZMInputCollectionViewSectionDataType],
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
                                    sectionCellDatas: [ZMInputCollectionViewBaseCellDataType],
                                    sectionDatas: [ZMInputCollectionViewSectionDataType],
                                    completionHandler: @escaping (_ changed:Bool, _ needFlush:Bool) -> Void) {
        if maxSelectedNum == 1 {
            if cellData.cellSelected {
                return
            }
            sectionCellDatas.forEach {
                if let tmpSelectData = $0 as? ZMInputCollectionViewSelectCellDataType {
                    tmpSelectData.cellSelected = false
                }
            }
            cellData.cellSelected = true
            completionHandler(true,false)
        } else if maxSelectedNum > 1 {
            if cellData.cellSelected == true {
                cellData.cellSelected = false
                completionHandler(true,false)
            } else if sectionCellDatas.filter({
                if let tmpSelectData = $0 as? ZMInputCollectionViewSelectCellDataType, tmpSelectData.cellSelected {
                    return true
                }
                return false
            }).count >= maxSelectedNum {
                completionHandler(false,false)
            } else {
                cellData.cellSelected = true
                completionHandler(true,false)
            }
        } else {
            cellData.cellSelected = !cellData.cellSelected
            completionHandler(true,false)
        }
        
    }
}

