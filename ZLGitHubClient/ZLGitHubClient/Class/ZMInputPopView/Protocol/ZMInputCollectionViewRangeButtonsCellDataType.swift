//
//  ZMInputCollectionViewRangeButtonsCellDataType.swift
//  ZMInputCollectionViewRangeButtonsCellDataType
//
//  Created by zhumeng on 2022/7/31.
//

import Foundation

// 范围按钮类型
// MARK: - ZMInputCollectionViewRangeButtonsCellDataType
public protocol ZMInputCollectionViewRangeButtonsCellDataType: AnyObject & ZMInputCollectionViewBaseCellDataType {
    var buttonValues: [Any?] { set get }
    var buttonTitles: [String?] { set get }
}

public extension ZMInputCollectionViewRangeButtonsCellDataType {
    var cellType: ZMInputCollectionViewBaseCellType {
        .rangeButton
    }
}


// 范围按钮类型cell协议
// MARK: - ZMInputCollectionViewRangeButtonsCellUpdatable
public protocol ZMInputCollectionViewRangeButtonsCellUpdatable: ZMInputCollectionViewUpdatable {
    
    associatedtype CellDataType
    func updateConcreteCellData(cellData: CellDataType,
                                titles: [String?],
                                values: [Any?],
                                didClickedButton: ((Int) -> Void)?)
}

public extension ZMInputCollectionViewRangeButtonsCellUpdatable {
    func updateViewData(viewData: Any) {
        if let (cellDataContainer,block) = viewData as? (ZMInputCollectionViewBaseCellDataContainer, (Int) -> Void),
           let realCellData = cellDataContainer.realCellData as? CellDataType {
            updateConcreteCellData(cellData:realCellData,
                                   titles: cellDataContainer.buttonTitles,
                                   values: cellDataContainer.buttonValues,
                                   didClickedButton: block)
        }
    }
}
