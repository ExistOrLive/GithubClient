//
//  ZMInputCollectionViewProtocol.swift
//  ZMInputCollectionViewProtocol
//
//  Created by zhumeng on 2022/6/23.
//

import Foundation

// MARK: - ZMInputCollectionViewBaseCellType
public enum ZMInputCollectionViewBaseCellType {
    case base               // 基本类型
    case select             // 选择框类型
    case button             // 按钮类型
    case textField          // 输入框类型
}

// MARK: - ZMInputCollectionViewBaseCellDataType
public protocol ZMInputCollectionViewBaseCellDataType {
    var cellIdentifier: String { get }
    var cellType: ZMInputCollectionViewBaseCellType { get }
    var id: String { get }
}

public extension ZMInputCollectionViewBaseCellDataType {
    var id: String { "" }
}


// MARK: - ZMInputCollectionViewBaseSectionViewDataType
public protocol ZMInputCollectionViewBaseSectionViewDataType {
    var sectionViewIdentifier: String { get }
    var id: String { get }
}

public extension ZMInputCollectionViewBaseSectionViewDataType {
    var id: String { "" }
}

// MARK: - ZMInputCollectionViewSectionDataType
public protocol ZMInputCollectionViewSectionDataType {
    var cellDatas: [ZMInputCollectionViewBaseCellDataType] { get }
    var sectionHeaderData: ZMInputCollectionViewBaseSectionViewDataType? { get }
    var sectionFooterData: ZMInputCollectionViewBaseSectionViewDataType? { get }
    var id: String { get }
}

public extension ZMInputCollectionViewSectionDataType {
    var id: String { "" }
}








