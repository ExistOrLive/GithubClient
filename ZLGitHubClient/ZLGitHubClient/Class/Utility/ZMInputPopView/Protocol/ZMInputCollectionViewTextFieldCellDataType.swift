//
//  ZMInputCollectionViewTextFieldCellDataType.swift
//  ZMInputCollectionViewTextFieldCellDataType
//
//  Created by zhumeng on 2022/7/31.
//

import Foundation

// 输入框类型
// MARK: - ZMInputCollectionViewTextFieldCellDataType
public protocol ZMInputCollectionViewTextFieldCellDataType: AnyObject & ZMInputCollectionViewBaseCellDataType & ZMInputCollectionViewTemporaryDataProtocol {
    var textValue: String? { set get }
    var temporaryTextValue: String? { set get }
}

public extension ZMInputCollectionViewTextFieldCellDataType {
    var cellType: ZMInputCollectionViewBaseCellType {
        .textField
    }
    var temporaryTextValue: String? {
        get {
            temporaryDataFor(key: "temporaryTextValue") as? String
        }
        set {
            setTemporaryData(newValue, for: "temporaryTextValue")
        }
    }
    func flushTemporaryDataToRealData() {
        textValue = temporaryTextValue
    }
    func readTemporaryDataFromRealData() {
        temporaryTextValue = textValue
    }
}




