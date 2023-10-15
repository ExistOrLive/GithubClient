//
//  ZMInputCollectionViewSelectBorderBoxCell.swift
//  ZMInputCollectionViewSelectBorderBoxCell
//
//  Created by zhumeng on 2022/7/31.
//

import UIKit
import ZLBaseExtension
import SnapKit

public protocol ZMInputCollectionViewSelectTitleBoxCellData: ZMInputCollectionViewSelectCellDataType {
    var title: String { get }
}

/// 带边框的选择框 Cell
public class ZMInputCollectionViewSelectBorderBoxCell: UICollectionViewCell, ZMInputCollectionViewConcreteUpdatable {
 
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc dynamic func setUpUI() {
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 1.0
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 1.0
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    public func updateConcreteViewData(viewData: ZMInputCollectionViewSelectTitleBoxCellData) {
        titleLabel.text = viewData.title
        titleLabel.font = viewData.temporaryCellSelected ? .zlMediumFont(withSize:12) : .zlLightFont(withSize:12)
        contentView.layer.borderColor = viewData.temporaryCellSelected ? UIColor.black.cgColor : UIColor.gray.cgColor
        contentView.layer.borderWidth = viewData.temporaryCellSelected ? 1.5 : 1.0
    }
    
    // Lazy View
    @objc lazy dynamic var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .zlLightFont(withSize: 12)
        label.textColor = UIColor.black
        return label
    }()
    
}

