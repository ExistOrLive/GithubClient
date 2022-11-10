//
//  ZMInputCollectionViewRangeButtonsCellDataType.swift
//  ZMInputCollectionViewRangeButtonsCellDataType
//
//  Created by zhumeng on 2022/7/31.
//

import Foundation

// 按钮类型
// MARK: - ZMInputCollectionViewButtonCellDataType
public protocol ZMInputCollectionViewButtonCellDataType: AnyObject & ZMInputCollectionViewBaseCellDataType {
    var buttonValue: Any? { set get }
    var buttonTitle: String? { set get }
}

public extension ZMInputCollectionViewButtonCellDataType {
    var cellType: ZMInputCollectionViewBaseCellType {
        .button
    }
}


// 按钮类型cell协议
// MARK: - ZMInputCollectionViewButtonCellUpdatable
public protocol ZMInputCollectionViewButtonCellUpdatable: ZMInputCollectionViewUpdatable {
    
    associatedtype CellDataType
    func updateConcreteCellData(cellData: CellDataType,
                                title: String?,
                                value: Any?)
}

public extension ZMInputCollectionViewButtonCellUpdatable {
    func updateViewData(viewData: Any) {
        if let cellDataContainer = viewData as? ZMInputCollectionViewBaseCellDataContainer,
           let realCellData = cellDataContainer.realCellData as? CellDataType {
            updateConcreteCellData(cellData:realCellData,
                                   title: cellDataContainer.buttonTitle,
                                   value: cellDataContainer.buttonValue)
        }
    }
}
