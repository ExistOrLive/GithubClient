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
    
    // 设置collectionViewLayout 必须是flowlayout 
    func resetLayout(layout: UICollectionViewFlowLayout) {
        self.collectionViewLayout = layout
        self.collectionView.collectionViewLayout = layout
        self.collectionView.reloadData()
    }
    
    var collectionViewData: ZMInputCollectionViewBaseDataType {
        _collectonViewData
    }
    
    // 设置collectionViewData
    func setCollectionViewData(viewData: ZMInputCollectionViewBaseDataType) {
        _collectonViewData = viewData
        viewData.sectionDatas.forEach { sectionData in
            sectionData.cellDatas.forEach { cellData in
                if let temporarayData = cellData as? ZMInputCollectionViewTemporaryDataProtocol {
                    temporarayData.readTemporaryDataFromRealData()
                }
            }
        }
        collectionView.reloadData()
    }
    
    // 设置cellDatas
    func setCellDatas(cellDatas: [ZMInputCollectionViewBaseCellDataType],
                      headerData: ZMInputCollectionViewBaseSectionViewDataType? = nil,
                      footerData: ZMInputCollectionViewBaseSectionViewDataType? = nil) {
        let sectionData = ZMInputCollectionSectionData(cellDatas: cellDatas,
                                                       sectionHeaderData: headerData,
                                                       sectionFooterData: footerData)
        let viewData = ZMInputCollectionViewData(sectionDatas: [sectionData])
        setCollectionViewData(viewData: viewData)
    }
    
    // 设置sectionDatas
    func setSectionDatas(sectionDatas: [ZMInputCollectionViewBaseSectionDataType]) {
        let viewData = ZMInputCollectionViewData(sectionDatas: sectionDatas)
        setCollectionViewData(viewData: viewData)
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
        _collectonViewData = ZMInputCollectionViewData()
        collectionView.reloadData()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    // 清除所有缓存数据
    func resetTemporaryData() {
        _collectonViewData.sectionDatas.forEach { sectionData in
            sectionData.cellDatas.forEach { cellData in
                if let temporarayData = cellData as? ZMInputCollectionViewTemporaryDataProtocol {
                    temporarayData.resetTemporaryData()
                }
            }
        }
        collectionView.reloadData()
        _delegate?.inputCollectionViewDataDidChange(self)
    }
    
    // 清除section中的缓存数据
    func resetTemporaryData(section: Int) {
        if section < _collectonViewData.sectionDatas.count {
            let sectionData = _collectonViewData.sectionDatas[section]
            sectionData.cellDatas.forEach { cellData in
                if let temporarayData = cellData as? ZMInputCollectionViewTemporaryDataProtocol {
                    temporarayData.resetTemporaryData()
                }
            }
            collectionView.reloadData()
            _delegate?.inputCollectionViewDataDidChange(self)
        }
    }
    
    // 从缓存中flush数据
    func flushTemporaryData() {
        _collectonViewData.sectionDatas.forEach { sectionData in
            sectionData.cellDatas.forEach { cellData in
                if let temporarayData = cellData as? ZMInputCollectionViewTemporaryDataProtocol {
                    temporarayData.flushTemporaryDataToRealData()
                }
            }
        }
        _delegate?.inputCollectionViewDataDidFlush(self)
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

