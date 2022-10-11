//
//  ZLSearchView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/3.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLBaseExtension

class ZLSearchView: ZLBaseView {
                
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(topBackView)
        addSubview(contentView)
        topBackView.addSubview(topNavigationView)
        topNavigationView.addSubview(backButton)
        topNavigationView.addSubview(searchTextField)
        topNavigationView.addSubview(cancelButton)
        contentView.addSubview(searchItemsView)
        contentView.addSubview(searchRecordView)
                
        topBackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top).offset(ZLBaseUIConfig.sharedInstance().navigationBarHeight)
        }
        
        topNavigationView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(ZLBaseUIConfig.sharedInstance().navigationBarHeight)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(30)
            make.left.equalTo(10)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(0)
            make.right.equalTo(-10)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.left.equalTo(backButton.snp.right).offset(10)
            make.right.equalTo(cancelButton.snp.left).offset(-10)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(topBackView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        searchItemsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchRecordView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setEditStatus() {
        backButton.snp.updateConstraints { make in
            make.width.equalTo(0.0)
        }
        cancelButton.snp.updateConstraints { make in
            make.width.equalTo(60.0)
        }
        self.searchRecordView.isHidden = false
    }
    
    func setUnEditStatus() {
        backButton.snp.updateConstraints { make in
            make.width.equalTo(30.0)
        }
        cancelButton.snp.updateConstraints { make in
            make.width.equalTo(0.0)
        }
        self.searchRecordView.isHidden = true
    }
        
    // MARK: Lazy View
    lazy var topBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLCellBack")
        return view
    }()
    
    lazy var topNavigationView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLCellBack")
        return view
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = .zlRegularFont(withSize: 14)
        textField.textColor = UIColor(named:"ZLLabelColor1")
        textField.backgroundColor = UIColor(named:"ZLExploreTextFieldBackColor")
        textField.borderStyle = .none
        let placeHolder = ZLLocalizedString(string: "Search", comment: "")
        textField.attributedPlaceholder = NSAttributedString.init(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: ZLRGBValue_H(colorValue: 0x999999), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
        leftView.backgroundColor = UIColor.clear
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.cornerRadius = 4.0
        return textField
    }()
    
    lazy var backButton: UIButton = {
       let button = UIButton()
        button.setTitle(ZLIconFont.BackArrow.rawValue, for: .normal)
        button.setTitleColor(UIColor.label(withName: "ZLLabelColor1"), for: .normal)
        button.titleLabel?.font = .iconFont(size: 24)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(UIColor.label(withName: "ZLLabelColor1"), for: .normal)
        button.titleLabel?.font = .zlMediumFont(withSize: 14)
        button.setTitle(ZLLocalizedString(string: "Cancel", comment: ""), for: .normal)
        return button
    }()
    
    lazy var contentView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    

    lazy var searchRecordView: ZLSearchRecordView = {
        let searchRecordView = ZLSearchRecordView()
        searchRecordView.isHidden = true
        return searchRecordView
    }()
    lazy var searchItemsView: ZLSearchItemsView = {
        let searchItemsView = ZLSearchItemsView()
        return searchItemsView
    }()
}
