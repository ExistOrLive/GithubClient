//
//  ZMInputCollectionViewUpdatable.swift
//  ZMInputCollectionViewUpdatable
//
//  Created by zhumeng on 2022/7/31.
//

import Foundation

/// 新增的 cell， header， footer 需要实现 ZMInputCollectionViewConcreteUpdatable

// MARK: - ZMInputCollectionViewUpdatable
public protocol ZMInputCollectionViewUpdatable {
    func updateViewData(viewData: Any)
}

// MARK: - ZMInputCollectionViewSectionViewConcreteUpdatable
public protocol ZMInputCollectionViewSectionViewConcreteUpdatable: ZMInputCollectionViewUpdatable {
    
    associatedtype CellDataType
    func updateConcreteViewData(viewData: CellDataType)
}

public extension ZMInputCollectionViewSectionViewConcreteUpdatable {
    func updateViewData(viewData: Any) {
        if  let _ = viewData as? ZMInputCollectionViewBaseSectionViewDataType,
            let sectionViewData = viewData as? CellDataType {
            updateConcreteViewData(viewData: sectionViewData)
        }
    }
}



