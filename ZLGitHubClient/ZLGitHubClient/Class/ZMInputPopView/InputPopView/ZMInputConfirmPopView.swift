//
//  ZMInputConfirmPopView.swift
//  ZMInputConfirmPopView
//
//  Created by zhumeng on 2022/7/31.
//

import Foundation
import ZLBaseExtension
import SnapKit
import UIKit

public protocol ZMInputConfirmPopViewDelegate: AnyObject {
    func inputConfirmPopViewWillConfirm(_ box: ZMInputConfirmPopView,
                                        sectionDatas: [ZMInputCollectionViewSectionDataType]) -> Bool
    
    func inputConfirmPopViewWillReset(_ box: ZMInputConfirmPopView,
                                      sectionDatas: [ZMInputCollectionViewSectionDataType]) -> Bool
}

public extension ZMInputConfirmPopViewDelegate {
    func inputConfirmPopViewWillConfirm(_ box: ZMInputConfirmPopView,
                                        sectionDatas: [ZMInputCollectionViewSectionDataType]) -> Bool {
        return true
    }
    
    func inputConfirmPopViewWillReset(_ box: ZMInputConfirmPopView,
                                      sectionDatas: [ZMInputCollectionViewSectionDataType]) -> Bool {
        return true
    }
}


/// ZMInputConfirmPopView
open class ZMInputConfirmPopView: ZMInputPopView {
    
    public weak var delegate: ZMInputConfirmPopViewDelegate?
    
    public var contentInset: UIEdgeInsets = .zero {
        didSet {
            if let _ =  verticalStackView.superview {
                verticalStackView.snp.remakeConstraints { make in
                    make.edges.equalTo(contentInset)
                }
            }
        }
    }

    public var bottomViewHeight: CGFloat = 77 {
        didSet {
            if let _ =  bottomView.superview {
                bottomView.snp.updateConstraints { make in
                    make.height.equalTo(bottomViewHeight)
                }
            }
        }
    }
    
    public var buttonHeight: CGFloat = 44 {
        didSet {
            if let _ =  horizontalStackView.superview {
                horizontalStackView.snp.updateConstraints { make in
                    make.height.equalTo(buttonHeight)
                }
            }
            
        }
    }
    
    @objc open dynamic override func setupContentUI() {
        
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(collectionView)
        verticalStackView.addArrangedSubview(bottomView)
        bottomView.addSubview(separateLine)
        bottomView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(resetButton)
        horizontalStackView.addArrangedSubview(confirmButton)
        
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentInset)
        }
        
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(bottomViewHeight)
        }
        
        separateLine.snp.makeConstraints { make in
            make.height.equalTo(0.3)
            make.top.left.right.equalToSuperview()
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.center.equalToSuperview()
            make.height.equalTo(buttonHeight)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.width.equalTo(resetButton.snp.width).multipliedBy(2)
        }
        
    }
    
    
    // 自适应高度： collectionView 高度会自动计算，其他部分高度需要手动指定
    @objc open dynamic override func autoContentViewSize() -> CGSize {
        return CGSize(width: collectionView.frame.width, height: min(collectionView.frame.height + bottomViewHeight + contentInset.top + contentInset.bottom ,contentMaxHeight))
    }
    
    // MARK: Action
    @objc dynamic func onResetButtonClicked() {
        if delegate?.inputConfirmPopViewWillReset(self, sectionDatas: self.collectionView.sectionDatas) ?? true {
            collectionView.resetData()
        }
        
    }
    
    @objc dynamic func onConfirmButtonClicked() {
        if delegate?.inputConfirmPopViewWillConfirm(self, sectionDatas: self.collectionView.sectionDatas) ?? true {
            collectionView.flushData()
            self.dismiss()
        }
    }
    
    
    // MARK: Lazy View
    @objc public dynamic lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    @objc public dynamic lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    @objc public dynamic lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("重置", for: .normal)
        button.setTitleColor(UIColor.label(withName: "ZLBaseButtonTitleColor"), for: .normal)
        button.titleLabel?.font = .zlMediumFont(withSize: 16)
        button.backgroundColor = UIColor.back(withName: "ZLBaseButtonBackColor")
        button.layer.cornerRadius = 2.0
        button.layer.borderColor = UIColor.back(withName: "ZLBaseButtonBorderColor").cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(onResetButtonClicked), for: .touchUpInside)
        return button
    }()
    
    @objc public dynamic lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.label(withName: "ZLBaseButtonTitleColor"), for: .normal)
        button.titleLabel?.font = .zlMediumFont(withSize: 16)
        button.backgroundColor = UIColor.back(withName: "ZLBaseButtonBackColor")
        button.layer.cornerRadius = 2.0
        button.layer.borderColor = UIColor.back(withName: "ZLBaseButtonBorderColor").cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(onConfirmButtonClicked), for: .touchUpInside)
        return button
    }()
    
    @objc public dynamic lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    @objc public dynamic lazy var separateLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.back(withName: "ZLSeperatorLineColor")
        return view
    }()
    
}



