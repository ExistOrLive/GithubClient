//
//  ZMInputCollectionViewBaseDataContainer.swift
//  ZMInputCollectionViewBaseDataContainer
//
//  Created by zhumeng on 2022/7/31.
//

import Foundation

//MARK: - ZMInputCollectionViewData
/// ZMInputCollectionViewData
public class ZMInputCollectionViewData: ZMInputCollectionViewBaseDataType {
    public var sectionDatas: [ZMInputCollectionViewBaseSectionDataType] = []
 
    public init() {}
    
    public init(sectionDatas: [ZMInputCollectionViewBaseSectionDataType] = []) {
        self.sectionDatas = sectionDatas
    }
}


//MARK: - ZMInputCollectionSectionData
/// ZMInputCollectionSectionData
public class ZMInputCollectionSectionData: ZMInputCollectionViewBaseSectionDataType {
    public var cellDatas: [ZMInputCollectionViewBaseCellDataType] = []
    public var sectionHeaderData: ZMInputCollectionViewBaseSectionViewDataType?
    public var sectionFooterData: ZMInputCollectionViewBaseSectionViewDataType?
    public var id: String = ""
    
    public init() {}
    
    public init(id: String = "",
                cellDatas: [ZMInputCollectionViewBaseCellDataType] = [],
                sectionHeaderData: ZMInputCollectionViewBaseSectionViewDataType? = nil,
                sectionFooterData: ZMInputCollectionViewBaseSectionViewDataType? = nil) {
        self.id = id
        self.cellDatas = cellDatas
        self.sectionFooterData = sectionFooterData
        self.sectionHeaderData = sectionHeaderData
    }
}
