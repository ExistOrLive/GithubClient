//
//  ZMInputCollectionViewBaseDataContainer.swift
//  ZMInputCollectionViewBaseDataContainer
//
//  Created by zhumeng on 2022/7/31.
//

import Foundation

//MARK: - ZMInputCollectionSectionData
/// ZMInputCollectionSectionData
public class ZMInputCollectionSectionData: ZMInputCollectionViewSectionDataType {
    public var cellDatas: [ZMInputCollectionViewBaseCellDataType] = []
    public var sectionHeaderData: ZMInputCollectionViewBaseSectionViewDataType?
    public var sectionFooterData: ZMInputCollectionViewBaseSectionViewDataType?
    
    public init() {}
    
    public init(cellDatas: [ZMInputCollectionViewBaseCellDataType],
                sectionHeaderData: ZMInputCollectionViewBaseSectionViewDataType? = nil,
                sectionFooterData: ZMInputCollectionViewBaseSectionViewDataType? = nil) {
        self.cellDatas = cellDatas
        self.sectionFooterData = sectionFooterData
        self.sectionHeaderData = sectionHeaderData
    }
    
}


//MARK: - ZMInputCollectionViewBaseSectionDataContainer
/// ZMInputCollectionViewBaseSectionDataContainer 内部包装 cellData， 请不要在外部使用
public class ZMInputCollectionViewBaseSectionDataContainer: ZMInputCollectionViewSectionDataType {
    public var cellDataContainers: [ZMInputCollectionViewBaseCellDataContainer] = []

    public var sectionHeaderData: ZMInputCollectionViewBaseSectionViewDataType?
    public var sectionFooterData: ZMInputCollectionViewBaseSectionViewDataType?
    
    init(cellDataContainers: [ZMInputCollectionViewBaseCellDataContainer],
         sectionHeaderData: ZMInputCollectionViewBaseSectionViewDataType? = nil,
         sectionFooterData: ZMInputCollectionViewBaseSectionViewDataType? = nil) {
        self.cellDataContainers = cellDataContainers
        self.sectionFooterData = sectionFooterData
        self.sectionHeaderData = sectionHeaderData
    }
    
    public var cellDatas: [ZMInputCollectionViewBaseCellDataType] {
        cellDataContainers
    }
}


//MARK: - ZMInputCollectionViewBaseCellDataContainer
/// ZMInputCollectionViewBaseCellDataContainer 内部包装 cellData， 请不要在外部使用
public class ZMInputCollectionViewBaseCellDataContainer: ZMInputCollectionViewBaseCellDataType {

    ///
    public let realCellData: ZMInputCollectionViewBaseCellDataType
    /// 内部临时保存的数据
    public var internalTmpData: [String : Any]
    
    init(realCellData: ZMInputCollectionViewBaseCellDataType) {
        self.realCellData = realCellData
        self.internalTmpData = [:]
        readData()
    }
        
    public var cellIdentifier: String {
        return realCellData.cellIdentifier
    }
    
    public var cellType: ZMInputCollectionViewBaseCellType {
        return realCellData.cellType
    }
    
    public func flushData() {
        if let cellData = realCellData as? ZMInputCollectionViewSelectCellDataType {
            cellData.cellSelected = cellSelected
        } else if let cellData = realCellData as? ZMInputCollectionViewRangeButtonsCellDataType {
            cellData.buttonValues = buttonValues
            cellData.buttonTitles = buttonTitles
        }
    }
    
    public func resetData() {
        if let _ = realCellData as? ZMInputCollectionViewSelectCellDataType {
            cellSelected = false
        } else if let _ = realCellData as? ZMInputCollectionViewRangeButtonsCellDataType {
            buttonValues = Array<Any?>(repeating: nil, count: buttonValues.count)
            buttonTitles = Array<String?>(repeating: nil, count: buttonValues.count)
        }
    }
    
    public func readData() {
        if let cellData = realCellData as? ZMInputCollectionViewSelectCellDataType {
            cellSelected = cellData.cellSelected
        } else if let cellData = realCellData as? ZMInputCollectionViewRangeButtonsCellDataType {
            buttonValues = cellData.buttonValues
            buttonTitles = cellData.buttonTitles
        }
    }
    
}


extension ZMInputCollectionViewBaseCellDataContainer: ZMInputCollectionViewSelectCellDataType {
    public var cellSelected: Bool {
        set {
            self.internalTmpData["cellSelected"] = newValue
        }
        get {
            return self.internalTmpData["cellSelected"] as? Bool ?? false
        }
    }
    
   
}

extension ZMInputCollectionViewBaseCellDataContainer: ZMInputCollectionViewRangeButtonsCellDataType {
    
    public var buttonTitles: [String?] {
        set {
            self.internalTmpData["buttonTitles"] = newValue
        }
        get {
            return self.internalTmpData["buttonTitles"] as? [String?] ?? []
        }
    }
    
    public var buttonValues: [Any?] {
        set {
            self.internalTmpData["buttonValues"] = newValue
        }
        get {
            return self.internalTmpData["buttonValues"] as? [Any?] ?? []
        }
    }
}
