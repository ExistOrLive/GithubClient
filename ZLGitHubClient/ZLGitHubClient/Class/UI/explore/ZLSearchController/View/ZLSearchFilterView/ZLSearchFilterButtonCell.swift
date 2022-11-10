//
//  ZLSearchFilterButtonCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/11/1.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import UIKit

class ZLSearchFilterButtonCellData: ZMInputCollectionViewButtonCellDataType {
    var buttonValue: Any?
    var buttonTitle: String?
    var defaultButtonTitle: String?
    var defaultButtonValue: Any?
    
    var cellIdentifier: String = "ZLSearchFilterButtonCell"
    var id: String = ""
    
    init(buttonValue: Any? = nil,
         buttonTitle: String? = nil,
         defaultButtonValue: Any? = nil,
         defaultButtonTitle: String? = nil,
         cellIdentifier: String = "ZLSearchFilterButtonCell",
         id: String = "") {
        self.buttonTitle = buttonTitle
        self.buttonValue = buttonValue
        self.cellIdentifier = cellIdentifier
        self.id = id 
    }
}


class ZLSearchFilterButtonCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpUI() {
        contentView.backgroundColor = UIColor(named: "ZLPopUpTextFieldBackColor1")
        contentView.layer.cornerRadius = 3.0
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Lazy View
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zlLightFont(withSize: 14)
        label.textColor = UIColor(named: "ZLLabelColor1")
        label.textAlignment = .center
        return label
    }()
}


extension ZLSearchFilterButtonCell: ZMInputCollectionViewButtonCellUpdatable {
    
    func updateConcreteCellData(cellData: ZLSearchFilterButtonCellData,
                                title: String?,
                                value: Any?) {
        titleLabel.text = title ?? cellData.defaultButtonTitle
    }
}
