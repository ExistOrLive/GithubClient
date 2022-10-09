//
//  ZLLanguageSelectView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/18.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import FFPopup
import ZLBaseExtension
import ZLUIUtilities

class ZLLanguageSelectView: UIView {

    var allLanguagesArray: [String] = []

    var filterLanguagesArray: [String] = []

    weak var popup: FFPopup?

    var resultBlock: ((String?) -> Void)?

    static func showLanguageSelectView(resultBlock : @escaping ((String?) -> Void)) {

        let view: ZLLanguageSelectView = ZLLanguageSelectView(frame: CGRect.init(x: 0, y: 0, width: 280, height: 500))
        view.resultBlock = resultBlock
        
        let popup = FFPopup(contentView: view, showType: .bounceIn, dismissType: .bounceOut, maskType: FFPopup.MaskType.dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        view.popup = popup
        popup.show(layout: .Center)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        let languageArray = ZLServiceManager.sharedInstance.additionServiceModel?.getLanguagesWithSerialNumber(NSString.generateSerialNumber(), completeHandle: {[weak self](resultModel: ZLOperationResultModel) in

            if resultModel.result == true {
                guard let languageArray: [String] = resultModel.data as? [String] else {
                    ZLToastView.showMessage("language list transfer failed", duration: 3.0)
                    return
                }
                if self?.allLanguagesArray.count ?? 0 == 0 {
                    var newLanguageArray = ["Any"]
                    newLanguageArray.append(contentsOf: languageArray)
                    self?.allLanguagesArray = newLanguageArray
                    self?.filterLanguagesArray = newLanguageArray
                    self?.tableView.reloadData()
                }
            } else {
                guard let errorModel: ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    ZLToastView.showMessage("query language list failed", duration: 3.0)
                    return
                }
                ZLToastView.showMessage("query language list failed statusCode[\(errorModel.statusCode) message[\(errorModel.message)]]", duration: 3.0)
            }
        })

        if let realLanguageArray = languageArray {
            var newLanguageArray = ["Any"]
            newLanguageArray.append(contentsOf: realLanguageArray)
            self.allLanguagesArray = newLanguageArray
            self.filterLanguagesArray = newLanguageArray
            self.tableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        cornerRadius = 5
        
        addSubview(headerView)
        addSubview(tableView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(seperateLine)
        headerView.addSubview(textField)
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        seperateLine.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(1.0 / UIScreen.main.scale)
            make.left.right.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(seperateLine.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(40)
            make.bottom.equalTo(-10)
        }
        
        tableView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLPopUpTitleBackView")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zlMediumFont(withSize: 15)
        label.textColor = UIColor(named: "ZLPopupTitleColor")
        label.text = ZLLocalizedString(string: "Select a language", comment: "选择一种语言")
        return label
    }()
    
    lazy var seperateLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLSeperatorLineColor")
        return view
    }()
    
    lazy var textField: UITextField = {
       let textField = UITextField()
        textField.delegate = self
        let attributedPlaceHolder = NSAttributedString.init(string: ZLLocalizedString(string: "Filter languages", comment: "筛选语言"), attributes: [NSAttributedString.Key.foregroundColor: ZLRGBValue_H(colorValue: 0xCED1D6), NSAttributedString.Key.font: UIFont.init(name: Font_PingFangSCRegular, size: 12) ?? UIFont.systemFont(ofSize: 12)])
        textField.attributedPlaceholder = attributedPlaceHolder
        textField.font = .zlRegularFont(withSize: 14)
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "ZLPopUpTextFieldBackColor")
        return textField
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.register(ZLSpokenLanguageSelectViewCell.self, forCellReuseIdentifier: "ZLSpokenLanguageSelectViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets.zero
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()


}

extension ZLLanguageSelectView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ZLSpokenLanguageSelectViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSpokenLanguageSelectViewCell", for: indexPath) as? ZLSpokenLanguageSelectViewCell else {
            return UITableViewCell.init()
        }

        let language = self.filterLanguagesArray[indexPath.row]
        cell.languageLabel.text = language
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterLanguagesArray.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var language: String? = self.filterLanguagesArray[indexPath.row]

        if "Any" == language {
            language = nil
        }
        self.resultBlock?(language)

        self.popup?.dismiss(animated: true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.endEditing(true)
    }
}

extension ZLLanguageSelectView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }

        let textStr: NSString? = self.textField.text as NSString?
        let text: String = textStr?.replacingCharacters(in: range, with: string) ?? ""
        let array = self.allLanguagesArray.filter({ str in
            return str.lowercased().contains(find: text.lowercased())
        })
        self.filterLanguagesArray = array
        self.tableView.reloadData()

        return true
    }

}
