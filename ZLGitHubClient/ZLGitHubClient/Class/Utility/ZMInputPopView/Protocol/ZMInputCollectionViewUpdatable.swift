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
public protocol ZMInputCollectionViewConcreteUpdatable: ZMInputCollectionViewUpdatable {
    
    associatedtype ViewDataType
    func updateConcreteViewData(viewData: ViewDataType)
}

public extension ZMInputCollectionViewConcreteUpdatable {
    func updateViewData(viewData: Any) {
        if  let viewData = viewData as? ViewDataType {
            updateConcreteViewData(viewData: viewData)
        }
    }
}



