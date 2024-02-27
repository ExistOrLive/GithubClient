//
//  ZMInputCollectionViewSelectCellDataType.swift
//  ZMInputCollectionViewSelectCellDataType
//
//  Created by zhumeng on 2022/7/31.
//

import Foundation

// 选择框类型
// MARK: - ZMInputCollectionViewSelectCellDataType
public protocol ZMInputCollectionViewSelectCellDataType: AnyObject & ZMInputCollectionViewBaseCellDataType & ZMInputCollectionViewTemporaryDataProtocol {
    var cellSelected: Bool { get set }            /// 是否选中
    var temporaryCellSelected: Bool { get set }   /// 暂存是否选中
}

public extension ZMInputCollectionViewSelectCellDataType {
    var cellType: ZMInputCollectionViewBaseCellType {
        .select
    }
    
    var temporaryCellSelected: Bool {
        get {
           temporaryDataFor(key: "temporaryCellSelected") as? Bool ?? false
        }
        set {
            setTemporaryData(newValue, for: "temporaryCellSelected")
        }
    }
    
    func flushTemporaryDataToRealData() {
        cellSelected = temporaryCellSelected
    }

    func readTemporaryDataFromRealData() {
        temporaryCellSelected = cellSelected
    }
}
