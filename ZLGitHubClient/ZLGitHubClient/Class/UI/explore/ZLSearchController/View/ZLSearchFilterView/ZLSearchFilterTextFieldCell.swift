//
//  ZLSearchFilterTextFieldCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/11/5.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import UIKit

class ZLSearchFilterNumberFieldCellData: ZMInputCollectionViewTextFieldCellDataType {
    var textValue: String?
    var placeHolder: String?
    var cellIdentifier: String = "ZLSearchFilterNumberFieldCell"
    var id: String = ""
    
    init(textValue: String?,
         placeHolder: String?,
         cellIdentifier: String = "ZLSearchFilterNumberFieldCell",
         id: String = "") {
        self.textValue = textValue
        self.placeHolder = placeHolder
        self.cellIdentifier = cellIdentifier
        self.id = id
    }
}

class ZLSearchFilterNumberFieldCell: UICollectionViewCell {
    
    weak var cellDataContainer: ZMInputCollectionViewTextFieldCellDataType?
    
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
        textField.textAlignment = .center
        textField.addTarget(self, action: #selector(onTextFieldChange), for: .editingChanged)
        return textField
    }()
}

extension ZLSearchFilterNumberFieldCell: ZMInputCollectionViewConcreteUpdatable {
   
    func updateConcreteViewData(viewData: ZLSearchFilterNumberFieldCellData) {
        self.cellDataContainer = viewData
        self.textField.text = viewData.temporaryTextValue
        self.textField.placeholder = viewData.placeHolder
    }
}


extension ZLSearchFilterNumberFieldCell: UITextFieldDelegate {
    
    @objc func onTextFieldChange() {
        if let intValue = UInt(textField.text ?? "") {
            cellDataContainer?.temporaryTextValue = "\(intValue)"
            textField.text = "\(intValue)"
        } else {
            cellDataContainer?.temporaryTextValue = nil
            textField.text = nil
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /// 能转换为整型数才允许输入
        let oldText = textField.text ?? ""
        let newText = (oldText as NSString).replacingCharacters(in: range, with: string)
        let newValue = UInt(newText)
        if newText.isEmpty || newValue != nil  {
            return true
        } else {
            return false
        }
    }
}
