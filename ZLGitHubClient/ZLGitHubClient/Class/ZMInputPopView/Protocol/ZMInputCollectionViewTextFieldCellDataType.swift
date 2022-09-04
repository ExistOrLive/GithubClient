//
//  ZMInputCollectionViewTextFieldCellDataType.swift
//  ZMInputCollectionViewTextFieldCellDataType
//
//  Created by zhumeng on 2022/7/31.
//

import Foundation

// 范围输入框类型
// MARK: - ZMInputCollectionViewTextFieldCellDataType
public protocol ZMInputCollectionViewTextFieldCellDataType: AnyObject & ZMInputCollectionViewBaseCellDataType {
    var textValues: [String?] { set get }
}

