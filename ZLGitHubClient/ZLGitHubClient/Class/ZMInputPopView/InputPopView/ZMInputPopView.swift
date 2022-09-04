//
//  ZMInputPopView.swift
//  ZMInputPopView
//
//  Created by zhumeng on 2022/6/22.
//

import UIKit
import ZLBaseExtension
import SnapKit

/// 仅用于单选逻辑
public protocol ZMInputPopViewSingleSelectDelegate: AnyObject {
    func inputPopView(_ box: ZMInputPopView,
                            didSelectedCell selectedData: ZMInputCollectionViewSelectCellDataType)
}

/// ZMInputPopView
open class ZMInputPopView: ZMPopContainerView {
    
    @objc public var contentWidth: CGFloat = CGFloat.greatestFiniteMagnitude
    
    @objc public var contentMaxHeight: CGFloat = CGFloat.greatestFiniteMagnitude
    
    public var contentHeight: CGFloat?
    
    // 单选delegate
    private weak var singleSelectDelegate: ZMInputPopViewSingleSelectDelegate?
    // 单选 block
    private var singleSelectBlock: ((Int) -> Void)?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupContentUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc open dynamic func setupContentUI() {
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    @objc open dynamic func autoContentViewSize() -> CGSize {
        return CGSize(width: collectionView.frame.width, height: min(collectionView.frame.height,contentMaxHeight))
    }
    

    @objc open dynamic func show(_ to: UIView,
                                 contentPoition: ZMPopContainerViewPosition,
                                 animationDuration: TimeInterval) {
        
        // 高度动态适配
        // 需要设置 collectionView 的size，否则 collectionView reloadData 讲不会有效
        contentView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: UIScreen.main.bounds.height)
//        collectionView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: UIScreen.mainSize.height)
    
        
        if let contentHeight = contentHeight {
            // 高度固定
            collectionView.sizeToFitContentView {
                self.show(to,
                          contentView: self.contentView,
                          contentSize: CGSize(width: self.contentWidth, height: contentHeight),
                          contentPoition: contentPoition,
                          animationDuration: animationDuration)
                self.collectionView.reloadData()
            }

        } else {
        
            collectionView.sizeToFitContentView {
                self.show(to,
                          contentView: self.contentView,
                          contentSize: self.autoContentViewSize(),
                          contentPoition: contentPoition,
                          animationDuration: animationDuration)
                self.collectionView.reloadData()
            }
        }
    }
    
    
    // MARK: Lazy View
    @objc public dynamic lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        return view
    }()

    @objc public dynamic lazy var collectionView: ZMInputCollectionView = {
        let view = ZMInputCollectionView()
        return view
    }() 
}

// 单选弹窗
extension ZMInputPopView: ZMInputCollectionDelegate {

    public dynamic func showSingleSelectBox(_ to: UIView,
                                            contentPoition: ZMPopContainerViewPosition,
                                            animationDuration: TimeInterval,
                                            cellDatas: [ZMInputCollectionViewSelectCellDataType],
                                            headerData: ZMInputCollectionViewBaseSectionViewDataType? = nil,
                                            footerData: ZMInputCollectionViewBaseSectionViewDataType? = nil,
                                            singleSelectDelegate: ZMInputPopViewSingleSelectDelegate) {
        self.singleSelectDelegate = singleSelectDelegate
        self.collectionView.defaultPolicy.maxSelectedNum = 1
        self.collectionView.policy = collectionView.defaultPolicy
        self.collectionView.delegate = self
        self.collectionView.setCellDatas(cellDatas: cellDatas, headerData: headerData, footerData: footerData)
        
        self.show(to, contentPoition: contentPoition, animationDuration: animationDuration)
    }
    
    /// 当缓存中的数据修改时，回调  处理单选逻辑
    public func inputCollectionView(_ collectionView: ZMInputCollectionView,
                                    allSectionDatasDidChanged sectionDatas: [ZMInputCollectionViewSectionDataType]) {
        
        if let container = collectionView._sectionDatas.first?.cellDataContainers.first(where: { container in
            if container.cellType == .select, container.cellSelected == true {
                return true
            }
            return false
        }),
           let cellData = container.realCellData as? ZMInputCollectionViewSelectCellDataType {
            self.singleSelectDelegate?.inputPopView(self, didSelectedCell: cellData)
            self.dismiss()
        }
    }
}
