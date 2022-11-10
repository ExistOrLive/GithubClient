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


//MARK: - ZMInputCollectionViewBaseSectionDataContainer
/// ZMInputCollectionViewBaseSectionDataContainer 内部包装 cellData， 请不要在外部使用
public class ZMInputCollectionViewBaseSectionDataContainer: ZMInputCollectionViewSectionDataType {
    public var id: String = ""
    public var cellDataContainers: [ZMInputCollectionViewBaseCellDataContainer] = []
    public var sectionHeaderData: ZMInputCollectionViewBaseSectionViewDataType?
    public var sectionFooterData: ZMInputCollectionViewBaseSectionViewDataType?
    
    init(id: String = "",
         cellDataContainers: [ZMInputCollectionViewBaseCellDataContainer] = [],
         sectionHeaderData: ZMInputCollectionViewBaseSectionViewDataType? = nil,
         sectionFooterData: ZMInputCollectionViewBaseSectionViewDataType? = nil) {
        self.id = id
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
    
    public var id: String {
        return realCellData.id
    }
    
    public func flushData() {
        if let cellData = realCellData as? ZMInputCollectionViewSelectCellDataType {
            cellData.cellSelected = cellSelected
        } else if let cellData = realCellData as? ZMInputCollectionViewButtonCellDataType {
            cellData.buttonValue = buttonValue
            cellData.buttonTitle = buttonTitle
        } else if let cellData = realCellData as? ZMInputCollectionViewTextFieldCellDataType {
            cellData.textValue = textValue
        }
    }
    
    public func resetData() {
        if let _ = realCellData as? ZMInputCollectionViewSelectCellDataType {
            cellSelected = false
        } else if let _ = realCellData as? ZMInputCollectionViewButtonCellDataType {
            buttonValue = nil
            buttonTitle = nil
        } else if let _ = realCellData as? ZMInputCollectionViewTextFieldCellDataType {
            textValue = nil
        }
    }
    
    public func readData() {
        if let cellData = realCellData as? ZMInputCollectionViewSelectCellDataType {
            cellSelected = cellData.cellSelected
        } else if let cellData = realCellData as? ZMInputCollectionViewButtonCellDataType {
            buttonValue = cellData.buttonValue
            buttonTitle = cellData.buttonTitle
        } else if let cellData = realCellData as? ZMInputCollectionViewTextFieldCellDataType {
            textValue = cellData.textValue
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

extension ZMInputCollectionViewBaseCellDataContainer: ZMInputCollectionViewButtonCellDataType {
    
    public var buttonTitle: String? {
        set {
            self.internalTmpData["buttonTitle"] = newValue
        }
        get {
            return self.internalTmpData["buttonTitle"] as? String
        }
    }
    
    public var buttonValue: Any? {
        set {
            self.internalTmpData["buttonValue"] = newValue
        }
        get {
            return self.internalTmpData["buttonValue"]
        }
    }
}

extension ZMInputCollectionViewBaseCellDataContainer:  ZMInputCollectionViewTextFieldCellDataType {
    
    public var textValue: String? {
        set {
            self.internalTmpData["textValue"] = newValue
        }
        get {
            return self.internalTmpData["textValue"] as? String
        }
    }
}
