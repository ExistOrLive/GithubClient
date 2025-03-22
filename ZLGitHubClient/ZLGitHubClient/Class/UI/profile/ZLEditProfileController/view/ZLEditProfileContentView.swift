//
//  ZLEditProfileContentView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/26.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLBaseExtension

class ZLEditProfileContentView: UIView, UITextFieldDelegate, UITextViewDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(bioBackView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(companyBackView)
        stackView.addArrangedSubview(addrBackView)
        stackView.addArrangedSubview(blogBackView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        bioBackView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(250)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(bioBackView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        companyBackView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        addrBackView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        blogBackView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.endEditing(true)
    }
    
    // MARK: Lazy View
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var bioBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLCellBack")
        view.addSubview(bioLabel)
        view.addSubview(bioTextView)
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(10)
        }
        
        bioTextView.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
        return view
    }()
    
    lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named:"ZLLabelColor1")
        label.font = .zlMediumFont(withSize: 17)
        label.text = ZLLocalizedString(string: "bio", comment: "")
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var companyBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLCellBack")
        view.addSubview(companyLabel)
        view.addSubview(companyTextField)
        companyLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        companyTextField.snp.makeConstraints { make in
            make.left.equalTo(companyLabel.snp.right).offset(10)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-20)
        }
        return view
    }()
    
    lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named:"ZLLabelColor1")
        label.font = .zlMediumFont(withSize: 17)
        label.text = ZLLocalizedString(string: "company", comment: "")
        return label
    }()
    
    lazy var addrBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLCellBack")
        view.addSubview(addrLabel)
        view.addSubview(addressTextField)
        addrLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        addressTextField.snp.makeConstraints { make in
            make.left.equalTo(addrLabel.snp.right).offset(10)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-20)
        }
        return view
    }()
    
    lazy var addrLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named:"ZLLabelColor1")
        label.font = .zlMediumFont(withSize: 17)
        label.text = ZLLocalizedString(string: "location", comment: "")
        return label
    }()
    
    lazy var blogBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLCellBack")
        view.addSubview(blogLabel)
        view.addSubview(blogTextField)
        blogLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        blogTextField.snp.makeConstraints { make in
            make.left.equalTo(blogLabel.snp.right).offset(10)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-20)
        }
        return view
    }()
    
    lazy var blogLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named:"ZLLabelColor1")
        label.font = .zlMediumFont(withSize: 17)
        label.text = ZLLocalizedString(string: "blog", comment: "")
        return label
    }()
    
    lazy var bioTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.textColor = UIColor(named:"ZLLabelColor1")
        textView.backgroundColor = UIColor(named:"ZLVCBackColor")
        textView.font = .zlRegularFont(withSize: 15)
        return textView
    }()
    
    lazy var companyTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.textColor = UIColor(named: "ZLLabelColor1")
        textField.font = .zlRegularFont(withSize: 15)
        textField.textAlignment = .right
        textField.attributedPlaceholder = ZLLocalizedString(string: "Input Company", comment: "")
            .asMutableAttributedString()
            .font(.zlRegularFont(withSize: 12))
            .foregroundColor(ZLRGBValue_H(colorValue: 0xCED1D6))
        return textField
    }()
    
    lazy var addressTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.textColor = UIColor(named: "ZLLabelColor1")
        textField.font = .zlRegularFont(withSize: 15)
        textField.textAlignment = .right
        textField.attributedPlaceholder = ZLLocalizedString(string: "Input Address", comment: "")
            .asMutableAttributedString()
            .font(.zlRegularFont(withSize: 12))
            .foregroundColor(ZLRGBValue_H(colorValue: 0xCED1D6))
        return textField
    }()
    
    lazy var blogTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.textColor = UIColor(named: "ZLLabelColor1")
        textField.font = .zlRegularFont(withSize: 15)
        textField.textAlignment = .right
        textField.attributedPlaceholder = ZLLocalizedString(string: "Input Blog", comment: "")
            .asMutableAttributedString()
            .font(.zlRegularFont(withSize: 12))
            .foregroundColor(ZLRGBValue_H(colorValue: 0xCED1D6))
        return textField
    }()
}
