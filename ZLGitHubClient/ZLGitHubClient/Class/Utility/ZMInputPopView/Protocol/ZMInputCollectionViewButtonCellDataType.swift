//
//  ZMInputCollectionViewRangeButtonsCellDataType.swift
//  ZMInputCollectionViewRangeButtonsCellDataType
//
//  Created by zhumeng on 2022/7/31.
//

import Foundation

// 按钮类型
// MARK: - ZMInputCollectionViewButtonCellDataType
public protocol ZMInputCollectionViewButtonCellDataType: AnyObject & ZMInputCollectionViewBaseCellDataType & ZMInputCollectionViewTemporaryDataProtocol {
    var buttonValue: Any? { set get }
    var buttonTitle: String? { set get }
    var temporaryButtonValue: Any? { set get }
    var temporaryButtonTitle: String? { set get }
}

public extension ZMInputCollectionViewButtonCellDataType {
    
    var cellType: ZMInputCollectionViewBaseCellType {
        .button
    }
    
    var temporaryButtonValue: Any? {
        set {
            setTemporaryData(newValue, for: "temporaryButtonValue")
        }
        get {
            temporaryDataFor(key: "temporaryButtonValue")
        }
    }
    
    var temporaryButtonTitle: String? {
        set {
            setTemporaryData(newValue, for: "temporaryButtonTitle")
        }
        get {
            temporaryDataFor(key: "temporaryButtonTitle") as? String
        }
    }
    
    func flushTemporaryDataToRealData() {
        buttonValue = temporaryButtonValue
        buttonTitle = temporaryButtonTitle
    }

    func readTemporaryDataFromRealData() {
        temporaryButtonValue = buttonValue
        temporaryButtonTitle = buttonTitle
    }
}
