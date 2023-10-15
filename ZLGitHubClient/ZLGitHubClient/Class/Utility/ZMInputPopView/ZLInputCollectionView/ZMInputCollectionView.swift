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
    func inputCollectionViewDataDidChange(_ collectionView: ZMInputCollectionView)
    
    /// 当缓存的数据flush时，回调
    func inputCollectionViewDataDidFlush(_ collectionView: ZMInputCollectionView)
}

public extension ZMInputCollectionDelegate {
    /// 当缓存中的数据修改时，回调
    func inputCollectionViewDataDidChange(_ collectionView: ZMInputCollectionView) {}
    
    /// 当缓存的数据flush时，回调
    func inputCollectionViewDataDidFlush(_ collectionView: ZMInputCollectionView) {}

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
    
    var _collectonViewData: ZMInputCollectionViewBaseDataType = ZMInputCollectionViewData()
   
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
    
    func cellDataForIndexPath(_ indexPath: IndexPath) -> ZMInputCollectionViewBaseCellDataType? {
        guard indexPath.section < _collectonViewData.sectionDatas.count,
              indexPath.row < _collectonViewData.sectionDatas[indexPath.section].cellDatas.count,
              indexPath.section < _collectonViewData.numberOfSections,
              indexPath.row < _collectonViewData.sectionDatas[indexPath.section].numberOfCellsInSection else {
            return nil
        }
        
        let sectionData = _collectonViewData.sectionDatas[indexPath.section]
        let cellData = sectionData.cellDatas[indexPath.row]
        return cellData
    }
    
    func sectionDataForSection(_ section: Int) -> ZMInputCollectionViewBaseSectionDataType? {
        guard section < _collectonViewData.sectionDatas.count,
              section < _collectonViewData.numberOfSections else {
            return nil
        }
        
        let sectionData = _collectonViewData.sectionDatas[section]
        return sectionData
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _scrollViewDelegate?.inputCollectionScrollViewWillBeginDragging(self)
    }
    
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        _collectonViewData.numberOfSections
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sectionDataForSection(section)?.numberOfCellsInSection ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        guard let sectionData = sectionDataForSection(indexPath.section),
              let cellData = cellDataForIndexPath(indexPath) else {
            return
        }
            
        if let cellData = cellData as? ZMInputCollectionViewSelectCellDataType {
            // 选择框逻辑
            self.didSelectCellAt(indexPath: indexPath,
                                 cellData: cellData,
                                 sectionData: sectionData)
        } else if let cellData = cellData as? ZMInputCollectionViewButtonCellDataType {
            // 按钮逻辑
            self.didClickButtonCellAt(indexPath: indexPath,
                                      cellData: cellData,
                                      sectionData: sectionData)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        guard let cellData = cellDataForIndexPath(indexPath) else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:cellData.cellIdentifier ,
                                                      for: indexPath)
        if let updatable = cell as? ZMInputCollectionViewUpdatable {
            updatable.updateViewData(viewData: cellData)
        }
        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
        guard let sectionData = sectionDataForSection(indexPath.section) else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier:"ZMInputCollectionViewSectionPlaceHolderView",
                                                                   for: indexPath)
        }

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
        
        if let itemSize = cellDataForIndexPath(indexPath)?.cellItemSize {
            return itemSize
        }
        
        if let itemSize = _uiDelegate?.inputCollectionView(self, sizeForItemAt: indexPath) {
            return itemSize
        }
        
        return self.itemSize
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       
        if let sectionInset = sectionDataForSection(section)?.sectionInset {
            return sectionInset
        }
        
        if let sectionInset = _uiDelegate?.inputCollectionView(self, insetForSectionAt: section) {
            return sectionInset
        }
        
        return self.sectionInset
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if let lineSpacing = sectionDataForSection(section)?.sectionLineSpacing {
            return lineSpacing
        }
        
        if let lineSpacing = _uiDelegate?.inputCollectionView(self, lineSpacingForSectionAt: section) {
            return lineSpacing
        }
        
        return self.lineSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if let interitemSpacing = sectionDataForSection(section)?.sectionInteritemSpacing {
            return interitemSpacing
        }
        
        if let interitemSpacing = _uiDelegate?.inputCollectionView(self, interitemSpacingForSectionAt: section) {
            return interitemSpacing
        }
        
        return self.interitemSpacing
        
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
       
        if let sectionData = sectionDataForSection(section),
           !sectionData.showSectionHeader {
            return .zero
        }
        
        if let headerReferenceSize = sectionDataForSection(section)?.sectionHeaderData?.sectionViewSize {
            return headerReferenceSize
        }
        
        if let headerReferenceSize = _uiDelegate?.inputCollectionView(self, referenceSizeForHeaderInSection: section) {
            return headerReferenceSize
        }
        
        return self.headerReferenceSize
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
       
         if let sectionData = sectionDataForSection(section),
            !sectionData.showSectionFooter{
             return .zero
         }
         
         if let footerReferenceSize = sectionDataForSection(section)?.sectionFooterData?.sectionViewSize {
             return footerReferenceSize
         }
        
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
                         sectionData: ZMInputCollectionViewBaseSectionDataType) {
        
        // 调用选择策略
        _policy?.inputCollectionView(self,
                                     didSelectIndexPath: indexPath,
                                     cellDataForClickedCell: cellData,
                                     sectionData: sectionData) { [weak self] (changed,needFlush) in
            guard let self = self else { return }
            
            if changed {
                
                self._delegate?.inputCollectionViewDataDidChange(self)
                               
                if needFlush {
                    self.flushTemporaryData()
                }
                self.reloadData()
            }
        }
                                     
        
        
    }
    
    // 按钮逻辑
    func didClickButtonCellAt(indexPath: IndexPath,
                              cellData: ZMInputCollectionViewButtonCellDataType,
                              sectionData: ZMInputCollectionViewBaseSectionDataType) {
        
        // 调用按钮策略
        self._policy?.inputCollectionView(self,
                                          didClickIndexPath: indexPath,
                                          cellDataForClickedCell: cellData,
                                          sectionData: sectionData) { [weak self] (changed,needFlush) in
            guard let self = self else { return }
            
            if changed {
                self._delegate?.inputCollectionViewDataDidChange(self)
                if needFlush {
                    self.flushTemporaryData()
                }
                self.reloadData()
            }
        }
    }
}

