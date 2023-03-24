//
//  ZMInputCollectionView+PublicAPI.swift
//  ZMInputCollectionView
//
//  Created by zhumeng on 2022/8/1.
//

import Foundation
import UIKit

// MARK: Public Data API
public extension ZMInputCollectionView {
    
    // readOnly
    var sectionDatas: [ZMInputCollectionViewSectionDataType] {
        _sectionDatas
    }
    
    // 设置cellDatas
    func setCellDatas(cellDatas: [ZMInputCollectionViewBaseCellDataType],
                      headerData: ZMInputCollectionViewBaseSectionViewDataType? = nil,
                      footerData: ZMInputCollectionViewBaseSectionViewDataType? = nil) {
        let cellDataContainers = cellDatas.map { cellDataType in
            ZMInputCollectionViewBaseCellDataContainer(realCellData: cellDataType)
        }
        _sectionDatas = [ZMInputCollectionViewBaseSectionDataContainer(cellDataContainers: cellDataContainers,
                                                                   sectionHeaderData: headerData,
                                                                   sectionFooterData: footerData)]
        collectionView.reloadData()
    }
    
    // 设置sectionDatas
    func setSectionDatas(sectionDatas: [ZMInputCollectionViewSectionDataType]) {
        
        _sectionDatas = sectionDatas.map({ realSectionData in
            let cellDatas = realSectionData.cellDatas.map { cellDataType in
                ZMInputCollectionViewBaseCellDataContainer(realCellData: cellDataType)
            }
            return ZMInputCollectionViewBaseSectionDataContainer(cellDataContainers: cellDatas,
                                                             sectionHeaderData: realSectionData.sectionHeaderData,
                                                             sectionFooterData: realSectionData.sectionFooterData)
        })
        collectionView.reloadData()
    }
    

    // delegate
    var delegate: ZMInputCollectionDelegate? {
        get {
            _delegate
        }
        set {
            _delegate = newValue
        }
    }
    
    // uidelegate
    var uiDelegate: ZMInputCollectionViewUIDelegate? {
        get {
            _uiDelegate
        }
        set {
            _uiDelegate = newValue
        }
    }
    
    // scrollViewdelegate
    var scrollViewDelegate: ZMInputCollectionScrollViewDelegate? {
        get {
            _scrollViewDelegate
        }
        set {
            _scrollViewDelegate = newValue
        }
    }
    
    // policy
    var policy: ZMInputCollectionViewPolicyProtocol? {
        get {
            _policy
        }
        set {
            _policy = newValue
        }
    }
    
    func clearData() {
        _sectionDatas = []
        collectionView.reloadData()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    // 清除所有缓存数据
    func resetData() {
        _sectionDatas.forEach { sectionData in
            sectionData.cellDataContainers.forEach { cellData in
                cellData.resetData()
            }
        }
        collectionView.reloadData()
        _delegate?.inputCollectionView(self,
                                       allSectionDatasDidChanged: self._sectionDatas)
    }
    
    // 清除section中的缓存数据
    func resetData(section: Int) {
        let sectionData = _sectionDatas[section]
        sectionData.cellDataContainers.forEach { cellData in
            cellData.resetData()
        }
        collectionView.reloadData()
        _delegate?.inputCollectionView(self,
                                       allSectionDatasDidChanged: self._sectionDatas)
    }
    
    // 从缓存中flush数据
    func flushData() {
        _sectionDatas.forEach { sectionData in
            sectionData.cellDataContainers.forEach { cellData in
                cellData.flushData()
            }
        }
        let result = _sectionDatas.map { sectionData in
            return sectionData.cellDataContainers.map { cellDataContainer in
                cellDataContainer.realCellData
            }
        }
        _delegate?.inputCollectionView(self, didFlushData: result)
    }
    
    
    // reload
    func sizeToFitContentView(completion: (()-> Void)? = nil) {
        self.collectionView.performBatchUpdates {
            self.collectionView.reloadData()
        } completion: { _ in
            // 修改frame
            self.sizeToFit()
            // 修改IntrinsicContentSize
            self.invalidateIntrinsicContentSize()
            completion?()
        }
    }
    
    
}


// MARK: Public UI API
public extension ZMInputCollectionView {
    
    // 注册cell
    func register(cellType: AnyClass, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellType,
                                forCellWithReuseIdentifier: identifier)
    }
    
    // 注册view
    func register(sectionHeaderType: AnyClass,
                  withReuseIdentifier identifier: String) {
        collectionView.register(sectionHeaderType,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: identifier)
    }
    
    func register(secitonFooterType: AnyClass,
                  withReuseIdentifier identifier: String) {
        collectionView.register(secitonFooterType,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: identifier)
    }
    

    // UI
    var itemSize: CGSize {
        get {
            collectionViewLayout.itemSize
        }
        set {
            collectionViewLayout.itemSize = newValue
        }
    }
    
    var lineSpacing: CGFloat {
        get {
            collectionViewLayout.minimumLineSpacing
        }
        set {
            collectionViewLayout.minimumLineSpacing = newValue
        }
    }
    
    var interitemSpacing: CGFloat {
        get {
            collectionViewLayout.minimumInteritemSpacing
        }
        set {
            collectionViewLayout.minimumInteritemSpacing = newValue
        }
    }
    
    /// 不要用contentInset，导致宽高自适应不准
//    var contentInset: UIEdgeInsets {
//        get {
//            collectionView.contentInset
//        }
//        set {
//            collectionView.contentInset = newValue
//        }
//    }
    
    var sectionInset: UIEdgeInsets {
        get {
            collectionViewLayout.sectionInset
        }
        set {
            collectionViewLayout.sectionInset = newValue
        }
    }
    
    var headerReferenceSize: CGSize {
        get {
            collectionViewLayout.headerReferenceSize
        }
        set {
            collectionViewLayout.headerReferenceSize = newValue
        }
    }
    
    var footerReferenceSize: CGSize {
        get {
            collectionViewLayout.footerReferenceSize
        }
        set {
            collectionViewLayout.footerReferenceSize = newValue
        }
    }
    
    
}

