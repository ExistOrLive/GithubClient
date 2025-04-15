//
//  ZLSearchView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/3.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLBaseExtension
import ZMMVVM
import ZLUtilities
import ZLUIUtilities

class ZLSearchView: UIView {
    
    var viewModel: ZLSearchViewModel? {
        zm_viewModel as? ZLSearchViewModel
    }
    
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
        topNavigationView.addSubview(searchStackView)
        contentView.addSubview(searchItemsView)
        contentView.addSubview(searchRecordView)
        
        topBackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top).offset(ZMUIConfig.shared.navigationBarHeight)
        }
        
        topNavigationView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(ZMUIConfig.shared.navigationBarHeight)
        }
        
        searchStackView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.bottom.equalToSuperview()
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
        backButton.isHidden = true
        cancelButton.isHidden = false
        searchRecordView.isHidden = false
    }
    
    func setUnEditStatus() {
        backButton.isHidden = false
        cancelButton.isHidden = true
        searchRecordView.isHidden = true
        searchRecordView.tableView.reloadData()
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
    
    lazy var searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.addArrangedSubview(backButton)
        stackView.addArrangedSubview(searchTextField)
        stackView.addArrangedSubview(cancelButton)
        backButton.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalToSuperview()
        }
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalToSuperview()
        }
        searchTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        return stackView
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
        textField.delegate = self
        return textField
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle(ZLIconFont.BackArrow.rawValue, for: .normal)
        button.setTitleColor(UIColor.label(withName: "ZLLabelColor1"), for: .normal)
        button.titleLabel?.font = .iconFont(size: 24)
        button.addTarget(self, action: #selector(onBackButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setTitleColor(UIColor.label(withName: "ZLLabelColor1"), for: .normal)
        button.titleLabel?.font = .zlMediumFont(withSize: 14)
        button.setTitle(ZLLocalizedString(string: "Cancel", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(onCancelButtonClicked), for: .touchUpInside)
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

// MARK: - Action
extension ZLSearchView {
    @objc func onBackButtonClicked() {
        viewModel?.onBackButtonClicked()
    }
    
    @objc func onCancelButtonClicked() {
        searchTextField.text = viewModel?.preSearchKeyWord
        searchTextField.resignFirstResponder()
        setUnEditStatus()
    }
}




// MARK: UITextFieldDelegate
extension ZLSearchView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewModel?.preSearchKeyWord  = textField.text
        setEditStatus()
        viewModel?.searchRecordViewModel.onSearchKeyChanged(searchKey: textField.text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textStr: NSString? = textField.text as NSString?
        let text: String = textStr?.replacingCharacters(in: range, with: string) ?? ""
        viewModel?.searchRecordViewModel.onSearchKeyChanged(searchKey: text)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel?.searchRecordViewModel.onSearchKeyChanged(searchKey: "")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setUnEditStatus()
        textField.resignFirstResponder()
        viewModel?.searchItemsViewModel.startSearch(keyWord: textField.text)
        viewModel?.searchRecordViewModel.onSearhKeyConfirmed(searchKey: textField.text)
        return false
    }
}


extension ZLSearchView: ZMBaseViewUpdatableWithViewData {
    func zm_fillWithViewData(viewData: ZLSearchViewModel) {
        self.searchTextField.text = viewData.searchKey
        
        searchRecordView.zm_fillWithData(data: viewData.searchRecordViewModel)
        searchItemsView.zm_fillWithData(data: viewData.searchItemsViewModel)
    }
}
