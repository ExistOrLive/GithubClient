//
//  ZMInputCollectionViewSelectTickCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/10/15.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLBaseExtension
import SnapKit

/// 带✅的选择框 Cell
public class ZMInputCollectionViewSelectTickCell: UICollectionViewCell, ZMInputCollectionViewSelectCellConcreteUpdatable {
 
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc dynamic func setUpUI() {
        
        contentView.backgroundColor = UIColor(named: "ZLPopUpCellBack")
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(tickLabel)
        contentView.addSubview(separateLine)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        tickLabel.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
        }
        
        separateLine.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.bottom.right.equalToSuperview()
            make.height.equalTo(1.0/UIScreen.main.scale)
        }
    }

    public func updateConcreteCellData(cellData: ZMInputCollectionViewSelectTitleBoxCellData, selected: Bool) {
        titleLabel.text = cellData.title
        titleLabel.font = selected ? .zlMediumFont(withSize:16) : .zlLightFont(withSize:15)
        tickLabel.isHidden = !selected
    }
    
    // Lazy View
    @objc lazy dynamic var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .zlLightFont(withSize: 15)
        label.textColor = UIColor(named: "ZLLabelColor1")
        return label
    }()
    
    @objc lazy dynamic var tickLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .iconFont(size: 17)
        label.text = "\u{e689}"
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()
    
    @objc lazy dynamic var separateLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLSeperatorLineColor")
        return view
    }()
    
}


