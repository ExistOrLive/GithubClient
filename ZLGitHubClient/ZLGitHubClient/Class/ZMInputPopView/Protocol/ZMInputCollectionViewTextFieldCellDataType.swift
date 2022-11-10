//
//  ZMInputCollectionViewTextFieldCellDataType.swift
//  ZMInputCollectionViewTextFieldCellDataType
//
//  Created by zhumeng on 2022/7/31.
//

import Foundation

// 输入框类型
// MARK: - ZMInputCollectionViewTextFieldCellDataType
public protocol ZMInputCollectionViewTextFieldCellDataType: AnyObject & ZMInputCollectionViewBaseCellDataType {
    var textValue: String? { set get }
}

public extension ZMInputCollectionViewTextFieldCellDataType {
    var cellType: ZMInputCollectionViewBaseCellType {
        .textField
    }
}


// 输入框类型cell协议
// MARK: - ZMInputCollectionViewButtonCellUpdatable
public protocol ZMInputCollectionViewTextFieldCellDataUpdatable: ZMInputCollectionViewUpdatable {
    
    associatedtype CellDataType
    func updateConcreteCellData(cellData: CellDataType,
                                textValue: String?)
}

public extension ZMInputCollectionViewTextFieldCellDataUpdatable {
    func updateViewData(viewData: Any) {
        if let cellDataContainer = viewData as? ZMInputCollectionViewBaseCellDataContainer,
           let realCellData = cellDataContainer.realCellData as? CellDataType {
            updateConcreteCellData(cellData:realCellData,
                                   textValue: cellDataContainer.textValue)
        }
    }
}


