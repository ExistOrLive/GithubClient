//
//  ZMSingleSelectTitlePopView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/10/15.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import ZLBaseExtension
import SnapKit
import UIKit

/// ZMSingleSelectTitlePopView
open class ZMSingleSelectTitlePopView: ZMInputPopView,ZMInputCollectionScrollViewDelegate {
    
    var titles: [String] = []
    
    var cellDatas: [ZMInputCollectionViewTitleSelectCellData] = []
    
    var filterCellDatas: [ZMInputCollectionViewTitleSelectCellData] = []
    
    var singleSelectBlock: ((Int,String) -> Void)? = nil
    
    public var titleBackViewHeight: CGFloat = 50 {
        didSet {
            if let _ =  titleBackView.superview {
                titleBackView.snp.updateConstraints { make in
                    make.height.equalTo(titleBackViewHeight)
                }
            }
        }
    }
    
    public var textFieldBackHeight: CGFloat = 60 {
        didSet {
            if let _ =  textFieldBackView.superview {
                textFieldBackView.snp.updateConstraints { make in
                    make.height.equalTo(textFieldBackHeight)
                }
                
                textField.snp.updateConstraints { make in
                    make.height.equalTo(textFieldBackHeight - 20)
                }
            }
        }
    }
        
    @objc open dynamic override func setupContentUI() {
    
        contentView.cornerRadius = 5.0
        
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleBackView)
        verticalStackView.addArrangedSubview(textFieldBackView)
        verticalStackView.addArrangedSubview(collectionView)
        titleBackView.addSubview(titleLabel)
        textFieldBackView.addSubview(seperateLine)
        textFieldBackView.addSubview(textField)
       
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleBackView.snp.makeConstraints { make in
            make.height.equalTo(titleBackViewHeight)
        }
        
        textFieldBackView.snp.makeConstraints { make in
            make.height.equalTo(textFieldBackHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        
        seperateLine.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(1.0/UIScreen.main.scale)
        }
    
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(textFieldBackHeight - 20)
        }
        
    }
    
    
    // 自适应高度： collectionView 高度会自动计算，其他部分高度需要手动指定
    @objc open dynamic override func autoContentViewSize() -> CGSize {
        return CGSize(width: collectionView.frame.width, height: min(collectionView.frame.height + (titleBackView.isHidden ? 0.0 : titleBackViewHeight) + (textFieldBackView.isHidden ? 0.0 : textFieldBackHeight),contentMaxHeight))
    }
    
    // MARK: Lazy View
    @objc public dynamic lazy var titleBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLPopUpTitleBackView")
        return view
    }()
    
    @objc public dynamic lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zlMediumFont(withSize: 15)
        label.textColor = UIColor(named: "ZLPopupTitleColor")
        return label
    }()
    
    
    @objc public dynamic lazy var textFieldBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLPopUpTitleBackView")
        return view
    }()
    
    @objc public dynamic lazy var seperateLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLSeperatorLineColor")
        return view
    }()
    
    @objc public dynamic lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.font = .zlRegularFont(withSize: 14)
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "ZLPopUpTextFieldBackColor")
        return textField
    }()
    
    @objc public dynamic lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    
    /// ZMInputCollectionDelegate
    /// 当缓存中的数据修改时，回调  处理单选逻辑
    public override func inputCollectionView(_ collectionView: ZMInputCollectionView,
                                    allSectionDatasDidChanged sectionDatas: [ZMInputCollectionViewSectionDataType]) {
        
        if let containerIndex = collectionView._sectionDatas.first?.cellDataContainers.firstIndex(where: { container in
            if container.cellType == .select, container.cellSelected == true {
                return true
            }
            return false
        }),
           let container = collectionView._sectionDatas.first?.cellDataContainers[containerIndex],
           let cellData = container.realCellData as? ZMInputCollectionViewTitleSelectCellData {
            
            self.singleSelectBlock?(containerIndex, cellData.title)
            self.dismiss()
        }
    }
    
    public func inputCollectionScrollViewWillBeginDragging(_ collectionView: ZMInputCollectionView) {
        self.endEditing(true)
    }
}

// MARK: UITextFieldDelegate
extension ZMSingleSelectTitlePopView: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }

        let textStr: NSString? = self.textField.text as NSString?
        let text: String = textStr?.replacingCharacters(in: range, with: string) ?? ""
        var array = self.cellDatas
        if !text.isEmpty {
            array = self.cellDatas.filter({ cellData in
                return cellData.title.lowercased().contains(find: text.lowercased())
            })
        }
        self.filterCellDatas = array
        self.collectionView.setCellDatas(cellDatas: filterCellDatas)

        return true
    }
}

extension ZMSingleSelectTitlePopView {
    
    class ZMInputCollectionViewTitleSelectCellData: ZMInputCollectionViewSelectTitleBoxCellData {
        var title: String = ""
        var cellSelected: Bool = false
        var cellIdentifier: String = ""
    }
    
    public typealias SelectCell = UICollectionViewCell & ZMInputCollectionViewSelectCellConcreteUpdatable
    
    /// 单选弹窗，
    public dynamic func showSingleSelectTitleBox<T: SelectCell>(_ to: UIView,
                                                                contentPoition: ZMPopContainerViewPosition,
                                                                animationDuration: TimeInterval,
                                                                titles: [String],
                                                                selectedIndex: Int,
                                                                cellType: T.Type,
                                                                singleSelectBlock: ((Int,String) -> Void)? = nil) {
        guard !titles.isEmpty && selectedIndex >= 0 && selectedIndex < titles.count else {
            return
        }
        guard status == .dismissed else { return }
        inlineChangeToCaculutingBeforePopStatus()
        
        self.textField.text = nil
        self.singleSelectBlock = singleSelectBlock
        self.collectionView.defaultPolicy.maxSelectedNum = 1
        self.collectionView.policy = collectionView.defaultPolicy
        self.collectionView.delegate = self
        self.collectionView.scrollViewDelegate = self
        self.collectionView.register(cellType: cellType, forCellWithReuseIdentifier: NSStringFromClass(cellType))
        self.cellDatas = titles.map { title -> ZMInputCollectionViewTitleSelectCellData in
            let cellData = ZMInputCollectionViewTitleSelectCellData()
            cellData.title = title
            cellData.cellIdentifier = NSStringFromClass(cellType)
            return cellData
        }
        self.filterCellDatas = cellDatas
        self.filterCellDatas[selectedIndex].cellSelected = true
        
        self.collectionView.setCellDatas(cellDatas: filterCellDatas)
        self.inline_show(to, contentPoition: contentPoition, animationDuration: animationDuration)
    }
    
    
    static public func showCenterSingleSelectTickBox(to: UIView,
                                                     title: String,
                                                     selectableTitles: [String],
                                                     selectedTitle: String,
                                                     contentWidth: CGFloat = 280,
                                                     contentHeight: CGFloat? = nil,
                                                     contentMaxHeight: CGFloat = .greatestFiniteMagnitude,
                                                     singleSelectBlock: ((Int,String) -> Void)? = nil) {
        
        let selectView = ZMSingleSelectTitlePopView()
        selectView.titleLabel.text = title 
        selectView.frame = UIScreen.main.bounds
        selectView.textFieldBackView.isHidden = true
        selectView.contentWidth = 280
        selectView.contentHeight = contentHeight
        selectView.contentMaxHeight = contentMaxHeight
        selectView.collectionView.lineSpacing = .leastNonzeroMagnitude
        selectView.collectionView.interitemSpacing = .leastNonzeroMagnitude
        selectView.collectionView.itemSize = CGSize(width: 280, height: 50)
        selectView.popDelegate = ZMPopContainerViewDelegate_Center.shared

        let selectedIndex = selectableTitles.firstIndex(of: selectedTitle) ?? 0
        selectView.showSingleSelectTitleBox(to,
                                            contentPoition: .center,
                                            animationDuration: 0.1,
                                            titles: selectableTitles,
                                            selectedIndex: selectedIndex,
                                            cellType: ZMInputCollectionViewSelectTickCell.self)
        { index, title in
            singleSelectBlock?(index,title)
        }
    }
    
}
