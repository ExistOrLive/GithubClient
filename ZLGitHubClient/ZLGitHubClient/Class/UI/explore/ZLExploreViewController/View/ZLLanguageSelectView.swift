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

class ZLLanguageSelectView: UIView {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var tableView: UITableView!

    var allLanguagesArray: [String] = []

    var filterLanguagesArray: [String] = []

    weak var popup: FFPopup?

    var resultBlock: ((String?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.titleLabel.text = ZLLocalizedString(string: "Select a language", comment: "选择一种语言")
        let attributedPlaceHolder = NSAttributedString.init(string: ZLLocalizedString(string: "Filter languages", comment: "筛选语言"), attributes: [NSAttributedString.Key.foregroundColor: ZLRGBValue_H(colorValue: 0xCED1D6), NSAttributedString.Key.font: UIFont.init(name: Font_PingFangSCRegular, size: 12) ?? UIFont.systemFont(ofSize: 12)])
        self.textField.attributedPlaceholder = attributedPlaceHolder

        self.tableView.register(UINib.init(nibName: "ZLLanguageTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLLanguageTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.textField.delegate = self

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

    static func showLanguageSelectView(resultBlock : @escaping ((String?) -> Void)) {

        guard let view: ZLLanguageSelectView = Bundle.main.loadNibNamed("ZLLanguageSelectView", owner: nil, options: nil)?.first as? ZLLanguageSelectView else {
            return
        }
        view.resultBlock = resultBlock

        view.frame = CGRect.init(x: 0, y: 0, width: 280, height: 500)
        let popup = FFPopup(contentView: view, showType: .bounceIn, dismissType: .bounceOut, maskType: FFPopup.MaskType.dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        view.popup = popup
        popup.show(layout: .Center)

    }

}

extension ZLLanguageSelectView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ZLLanguageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLLanguageTableViewCell", for: indexPath) as? ZLLanguageTableViewCell else {
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
