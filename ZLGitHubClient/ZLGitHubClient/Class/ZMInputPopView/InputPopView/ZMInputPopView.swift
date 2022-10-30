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
open class ZMInputPopView: ZMPopContainerView, ZMInputCollectionDelegate {
    
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
        guard status == .dismissed else { return }
        self.inline_show(to,
                         contentPoition: contentPoition,
                         animationDuration: animationDuration)
       
    }
    

    @objc  dynamic func inline_show(_ to: UIView,
                                    contentPoition: ZMPopContainerViewPosition,
                                    animationDuration: TimeInterval) {
        guard status == .dismissed || status == .caculatingBeforePop else { return }
        inlineChangeToCaculutingBeforePopStatus()
        
        // 高度动态适配
        // 需要设置 collectionView 的size，否则 collectionView reloadData 将不会有效
        contentView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: UIScreen.main.bounds.height)

        if let contentHeight = contentHeight {
            // 高度固定
            collectionView.sizeToFitContentView {
                self.inline_show(to,
                                 contentView: self.contentView,
                                 contentSize: CGSize(width: self.contentWidth, height: contentHeight),
                                 contentPoition: contentPoition,
                                 animationDuration: animationDuration)
                self.collectionView.reloadData()
            }

        } else {
        
            collectionView.sizeToFitContentView {
                self.inline_show(to,
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
    
    
    /// ZMInputCollectionDelegate
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

// 单选弹窗
extension ZMInputPopView {

    public dynamic func showSingleSelectBox(_ to: UIView,
                                            contentPoition: ZMPopContainerViewPosition,
                                            animationDuration: TimeInterval,
                                            cellDatas: [ZMInputCollectionViewSelectCellDataType],
                                            headerData: ZMInputCollectionViewBaseSectionViewDataType? = nil,
                                            footerData: ZMInputCollectionViewBaseSectionViewDataType? = nil,
                                            singleSelectDelegate: ZMInputPopViewSingleSelectDelegate) {
        guard status == .dismissed else { return }
        inlineChangeToCaculutingBeforePopStatus()
        
        self.singleSelectDelegate = singleSelectDelegate
        self.collectionView.defaultPolicy.maxSelectedNum = 1
        self.collectionView.policy = collectionView.defaultPolicy
        self.collectionView.delegate = self
        self.collectionView.setCellDatas(cellDatas: cellDatas, headerData: headerData, footerData: footerData)
        
        self.inline_show(to, contentPoition: contentPoition, animationDuration: animationDuration)
    }
    
    
}
