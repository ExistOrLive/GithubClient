//
//  ZMInputCollectionView.swift
//  ZMInputCollectionView
//
//  Created by zhumeng on 2022/6/23.
//

import UIKit
import ZLBaseExtension
import SnapKit

// MARK: - ZMInputCollectionScrollViewDelegate
public protocol ZMInputCollectionScrollViewDelegate: AnyObject {
    
    func inputCollectionScrollViewWillBeginDragging(_ collectionView: ZMInputCollectionView)
}

public extension ZMInputCollectionDelegate {

    func ZMInputCollectionScrollViewDelegate(_ collectionView: ZMInputCollectionView) {}
}


// MARK: - ZMInputCollectionDelegate
public protocol ZMInputCollectionDelegate: AnyObject {
    
    /// 当缓存中的数据修改时，回调
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                                     allSectionDatasDidChanged sectionDatas: [ZMInputCollectionViewSectionDataType])
    
    /// 当缓存的数据flush时，回调
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                                     didFlushData cellDatas: [[ZMInputCollectionViewBaseCellDataType]])
}

public extension ZMInputCollectionDelegate {
    /// 当缓存中的数据修改时，回调
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                                     allSectionDatasDidChanged sectionDatas: [ZMInputCollectionViewSectionDataType]) {}
    
    /// 当缓存的数据flush时，回调
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                                     didFlushData cellDatas: [[ZMInputCollectionViewBaseCellDataType]]) {}

}


// MARK: - ZMInputCollectionViewUIDelegate
public protocol ZMInputCollectionViewUIDelegate: AnyObject {
    
    func inputCollectionView(_ collectionView: ZMInputCollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize

    func inputCollectionView(_ collectionView: ZMInputCollectionView, insetForSectionAt section: Int) -> UIEdgeInsets

    func inputCollectionView(_ collectionView: ZMInputCollectionView, lineSpacingForSectionAt section: Int) -> CGFloat

    func inputCollectionView(_ collectionView: ZMInputCollectionView, interitemSpacingForSectionAt section: Int) -> CGFloat

    func inputCollectionView(_ collectionView: ZMInputCollectionView, referenceSizeForHeaderInSection section: Int) -> CGSize

    func inputCollectionView(_ collectionView: ZMInputCollectionView, referenceSizeForFooterInSection section: Int) -> CGSize
}

public extension ZMInputCollectionViewUIDelegate {
    
    func inputCollectionView(_ collectionView: ZMInputCollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.itemSize
    }

    func inputCollectionView(_ collectionView: ZMInputCollectionView, insetForSectionAt section: Int) -> UIEdgeInsets {
        collectionView.sectionInset
    }

    func foldedFilterBoxCollectionView(_ collectionView: ZMInputCollectionView, lineSpacingForSectionAt section: Int) -> CGFloat {
        collectionView.lineSpacing
    }

    func inputCollectionView(_ collectionView: ZMInputCollectionView, interitemSpacingForSectionAt section: Int) -> CGFloat {
        collectionView.interitemSpacing
    }

    func inputCollectionView(_ collectionView: ZMInputCollectionView, referenceSizeForHeaderInSection section: Int) -> CGSize {
        collectionView.headerReferenceSize
    }

    func inputCollectionView(_ collectionView: ZMInputCollectionView, referenceSizeForFooterInSection section: Int) -> CGSize {
        collectionView.footerReferenceSize
    }
}


// MARK: - ZMInputCollectionView
public class ZMInputCollectionView: UIView {
    
    public let defaultPolicy = ZMInputCollectionViewDefaultPolicy()
    
    var _sectionDatas: [ZMInputCollectionViewBaseSectionDataContainer] = []
    
    weak var _policy: ZMInputCollectionViewPolicyProtocol?
    
    weak var _delegate: ZMInputCollectionDelegate?
    
    weak var _uiDelegate: ZMInputCollectionViewUIDelegate?
    
    weak var _scrollViewDelegate: ZMInputCollectionScrollViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _policy = defaultPolicy
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc dynamic func setupUI() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
            get {
                return collectionView.contentSize
            }
        }
        
    public override func sizeThatFits(_ size: CGSize) -> CGSize  {
        return collectionView.contentSize
    }

    // MARK: Lazy View
    
    @objc lazy dynamic var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        collectionView.register(ZMInputCollectionViewSectionPlaceHolderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "ZMInputCollectionViewSectionPlaceHolderView")
        collectionView.register(ZMInputCollectionViewSectionPlaceHolderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "ZMInputCollectionViewSectionPlaceHolderView")
        return collectionView
    }()
    
    @objc lazy dynamic var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()
}

// MARK: UICollectionViewDelegate UICollectionViewDataSource
extension ZMInputCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _scrollViewDelegate?.inputCollectionScrollViewWillBeginDragging(self)
    }
    
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        _sectionDatas.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _sectionDatas[section].cellDatas.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        let sectionDataContainer = _sectionDatas[indexPath.section]
        let cellDataContainer = sectionDataContainer.cellDataContainers[indexPath.row]
        if let cellData = cellDataContainer.realCellData as? ZMInputCollectionViewSelectCellDataType {
            // 选择框逻辑
            self.didSelectCellAt(indexPath: indexPath,
                                 cellData: cellData,
                                 cellDataContainer: cellDataContainer,
                                 sectionDataContainer: sectionDataContainer)
        }
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let sectionDataContainer = _sectionDatas[indexPath.section]
        let cellDataContainer = sectionDataContainer.cellDataContainers[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:cellDataContainer.cellIdentifier , for: indexPath)
        if let updatable = cell as? ZMInputCollectionViewUpdatable {
            updatable.updateViewData(viewData: cellDataContainer)
        }
        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       
        let sectionData = _sectionDatas[indexPath.section]
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: sectionData.sectionHeaderData?.sectionViewIdentifier ?? "ZMInputCollectionViewSectionPlaceHolderView",
                                                                         for: indexPath)
            if let updatable = header as? ZMInputCollectionViewUpdatable,
               let headerData = sectionData.sectionHeaderData {
                updatable.updateViewData(viewData: headerData)
            }
            return header
            
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footer =  collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                          withReuseIdentifier: sectionData.sectionFooterData?.sectionViewIdentifier ?? "ZMInputCollectionViewSectionPlaceHolderView",
                                                                          for: indexPath)
            if let updatable = footer as? ZMInputCollectionViewUpdatable,
               let footerData = sectionData.sectionFooterData{
                updatable.updateViewData(viewData: footerData)
            }
            return footer
        }
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                               withReuseIdentifier:"ZMInputCollectionViewSectionPlaceHolderView",
                                                               for: indexPath)
    }
    

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let itemSize = _uiDelegate?.inputCollectionView(self, sizeForItemAt: indexPath) {
            return itemSize
        }
        return self.itemSize
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let sectionInset = _uiDelegate?.inputCollectionView(self, insetForSectionAt: section) {
            return sectionInset
        }
        return self.sectionInset
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let lineSpacing = _uiDelegate?.inputCollectionView(self, lineSpacingForSectionAt: section) {
            return lineSpacing
        }
        return self.lineSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let interitemSpacing = _uiDelegate?.inputCollectionView(self, interitemSpacingForSectionAt: section) {
            return interitemSpacing
        }
        return self.interitemSpacing
        
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let headerReferenceSize = _uiDelegate?.inputCollectionView(self, referenceSizeForHeaderInSection: section) {
            return headerReferenceSize
        }
        return self.headerReferenceSize
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let footerReferenceSize = _uiDelegate?.inputCollectionView(self, referenceSizeForFooterInSection: section) {
            return footerReferenceSize
        }
        return self.footerReferenceSize
    }
}




// MARK: 选择框逻辑 / 多按钮逻辑
extension ZMInputCollectionView {
    
    // 选择框逻辑
    func didSelectCellAt(indexPath: IndexPath,
                         cellData: ZMInputCollectionViewSelectCellDataType,
                         cellDataContainer: ZMInputCollectionViewBaseCellDataContainer,
                         sectionDataContainer: ZMInputCollectionViewBaseSectionDataContainer) {
        
        // 调用选择策略
        _policy?.inputCollectionView(self,
                                            didClickIndexPath: indexPath,
                                            cellDataForClickedCell: cellDataContainer,
                                            sectionCellDatas: sectionDataContainer.cellDatas,
                                            sectionDatas: _sectionDatas) { [weak self] (changed,needFlush) in
            guard let self = self else { return }
            
            if changed {
                
                self._delegate?.inputCollectionView(self, allSectionDatasDidChanged: self._sectionDatas)
                               
                if needFlush {
                    self.flushData()
                }
                self.reloadData()
            }
        }
                                     
        
        
    }
    
    // 多按钮逻辑
    func didClickButtonInCellAt(buttonIndex: Int,
                                indexPath: IndexPath,
                                cellData: ZMInputCollectionViewRangeButtonsCellDataType,
                                cellDataContainer: ZMInputCollectionViewBaseCellDataContainer,
                                sectionDataContainer: ZMInputCollectionViewBaseSectionDataContainer) {
        
        // 调用范围按钮策略
        self._policy?.inputCollectionView(self,
                                                 buttonIndex: buttonIndex,
                                                 didClickIndexPath: indexPath,
                                                 cellDataForClickedCell: cellDataContainer,
                                                 sectionCellDatas: sectionDataContainer.cellDatas,
                                                 sectionDatas: self._sectionDatas) { [weak self] (changed,needFlush) in
            guard let self = self else { return }
            
            if changed {
                self._delegate?.inputCollectionView(self, allSectionDatasDidChanged:self._sectionDatas)
                if needFlush {
                    self.flushData()
                }
                self.reloadData()
            }
        }
    }
}

