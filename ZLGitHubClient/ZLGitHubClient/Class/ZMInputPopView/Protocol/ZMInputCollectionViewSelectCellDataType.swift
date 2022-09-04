//
//  ZMInputCollectionViewSelectCellDataType.swift
//  ZMInputCollectionViewSelectCellDataType
//
//  Created by zhumeng on 2022/7/31.
//

import Foundation

// 选择框类型
// MARK: - ZMInputCollectionViewSelectCellDataType
public protocol ZMInputCollectionViewSelectCellDataType: AnyObject & ZMInputCollectionViewBaseCellDataType {
    var cellSelected: Bool { get set }
}

public extension ZMInputCollectionViewSelectCellDataType {
    var cellType: ZMInputCollectionViewBaseCellType {
        .select
    }
}


// 选择框cell协议
// MARK: - ZMInputCollectionViewSelectCellConcreteUpdatable
public protocol ZMInputCollectionViewSelectCellConcreteUpdatable: ZMInputCollectionViewUpdatable {
    
    associatedtype CellDataType
    func updateConcreteCellData(cellData: CellDataType, selected: Bool)
}

public extension ZMInputCollectionViewSelectCellConcreteUpdatable {
    func updateViewData(viewData: Any) {
        if let cellDataContainer = viewData as? ZMInputCollectionViewBaseCellDataContainer,
           let realCellData = cellDataContainer.realCellData as? CellDataType {
            updateConcreteCellData(cellData:realCellData, selected: cellDataContainer.cellSelected)
        }
    }
}
