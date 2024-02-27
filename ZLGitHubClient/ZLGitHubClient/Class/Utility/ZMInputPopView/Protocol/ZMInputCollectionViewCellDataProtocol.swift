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
    var cellItemSize: CGSize? { get }
    var id: String { get }
}

public extension ZMInputCollectionViewBaseCellDataType {
    var id: String { "" }
    var cellItemSize: CGSize? { nil }
}


// MARK: - ZMInputCollectionViewBaseSectionViewDataType
public protocol ZMInputCollectionViewBaseSectionViewDataType {
    var sectionViewIdentifier: String { get }
    var sectionViewSize: CGSize? { get }
    var id: String { get }
}

public extension ZMInputCollectionViewBaseSectionViewDataType {
    var id: String { "" }
    var sectionViewSize: CGSize? { nil }
}

// MARK: - ZMInputCollectionViewSectionDataType
public protocol ZMInputCollectionViewBaseSectionDataType {
    var cellDatas: [ZMInputCollectionViewBaseCellDataType] { get }
    var sectionHeaderData: ZMInputCollectionViewBaseSectionViewDataType? { get }
    var sectionFooterData: ZMInputCollectionViewBaseSectionViewDataType? { get }
    
    var sectionInset: UIEdgeInsets? { get }
    var sectionLineSpacing: CGFloat? { get }
    var sectionInteritemSpacing: CGFloat? { get }
    var numberOfCellsInSection: Int { get }
    var showSectionHeader: Bool { get }
    var showSectionFooter: Bool { get }
    
    var id: String { get }
}

public extension ZMInputCollectionViewBaseSectionDataType {
    var id: String { "" }
    var sectionInset: UIEdgeInsets? { nil }
    var sectionLineSpacing: CGFloat? { nil }
    var sectionInteritemSpacing: CGFloat? { nil }
    var numberOfCellsInSection: Int { cellDatas.count }
    var showSectionHeader: Bool { sectionHeaderData != nil }
    var showSectionFooter: Bool { sectionFooterData != nil }
}

// MARK: - ZMInputCollectionViewDataType
public protocol ZMInputCollectionViewBaseDataType {
    var sectionDatas: [ZMInputCollectionViewBaseSectionDataType] { get }
    var numberOfSections: Int { get }
}

public extension ZMInputCollectionViewBaseDataType {
    var numberOfSections: Int { sectionDatas.count }
}







