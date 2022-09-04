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
    case rangeButton
}

// MARK: - ZMInputCollectionViewBaseCellDataType
public protocol ZMInputCollectionViewBaseCellDataType {
    var cellIdentifier: String { get }
    var cellType: ZMInputCollectionViewBaseCellType { get }
}

// MARK: - ZMInputCollectionViewBaseSectionViewDataType
public protocol ZMInputCollectionViewBaseSectionViewDataType {
    var sectionViewIdentifier: String { get }
}

// MARK: - ZMInputCollectionViewSectionDataType
public protocol ZMInputCollectionViewSectionDataType {
    var cellDatas: [ZMInputCollectionViewBaseCellDataType] { get }
    var sectionHeaderData: ZMInputCollectionViewBaseSectionViewDataType? { get }
    var sectionFooterData: ZMInputCollectionViewBaseSectionViewDataType? { get }
}








