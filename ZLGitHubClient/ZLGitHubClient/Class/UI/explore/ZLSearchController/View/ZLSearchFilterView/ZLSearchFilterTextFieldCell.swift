//
//  ZLSearchFilterTextFieldCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/11/5.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import UIKit

class ZLSearchFilterTextFieldCellData: ZMInputCollectionViewTextFieldCellDataType {
    var textValue: String?
    var placeHolder: String?
    var cellIdentifier: String = "ZLSearchFilterTextFieldCell"
    var id: String = ""
    
    init(textValue: String?,
         placeHolder: String?,
         cellIdentifier: String = "ZLSearchFilterTextFieldCell",
         id: String = "") {
        self.textValue = textValue
        self.placeHolder = placeHolder
        self.cellIdentifier = cellIdentifier
        self.id = id
    }
}

class ZLSearchFilterTextFieldCell: UICollectionViewCell {
    
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
        contentView.layer.masksToBounds = true 
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0))
        }
    }
    
    // MARK: Lazy View
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor(named:"ZLLabelColor1")
        textField.font = UIFont.zlRegularFont(withSize: 14)
        textField.delegate = self
        textField.keyboardType = .numberPad
        return textField
    }()
}

extension ZLSearchFilterTextFieldCell: ZMInputCollectionViewTextFieldCellDataUpdatable {
    func updateConcreteCellData(cellData: ZLSearchFilterTextFieldCellData,
                                textValue: String?) {
        self.textField.text = textValue
        self.textField.placeholder = cellData.placeHolder
    }
}


extension ZLSearchFilterTextFieldCell: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
