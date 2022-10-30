//
//  ZLSearchFilterViewForUser.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/10/27.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import FFPopup
import ZLGitRemoteService

class ZLSearchFilterViewForUser: UIView {

    static let minWidth: CGFloat = 300.0

    @IBOutlet private weak var orderLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var createTimeLabel: UILabel!
    @IBOutlet private weak var followerLabel: UILabel!
    @IBOutlet private weak var pubReposLabel: UILabel!

    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!

    @IBOutlet weak var firstTimeFileld: UITextField!
    @IBOutlet weak var secondTimeField: UITextField!
    @IBOutlet weak var firstFollowerNumField: UITextField!
    @IBOutlet weak var secondFollowerNumField: UITextField!
    @IBOutlet weak var firstPubRepoNumField: UITextField!
    @IBOutlet weak var secondPubRepoNumField: UITextField!

    weak var popup: FFPopup?

    var resultBlock: ((ZLSearchFilterInfoModel) -> Void)?

    static func showSearchFilterViewForUser(filterInfo: ZLSearchFilterInfoModel?, resultBlock: ((ZLSearchFilterInfoModel) -> Void)?) {
        guard  let view: ZLSearchFilterViewForUser = Bundle.main.loadNibNamed("ZLSearchFilterViewForUser", owner: nil, options: nil)?.first as? ZLSearchFilterViewForUser else {
            return
        }
        view.frame = CGRect.init(x: 0, y: 0, width: ZLSearchFilterViewForUser.minWidth, height: ZLSCreenHeight)
        view.setViewDataForSearchFilterViewForUser(searchFilterModel: filterInfo)
        view.resultBlock = resultBlock

        let popup = FFPopup(contentView: view, showType: .slideInFromRight, dismissType: .slideOutToRight, maskType: FFPopup.MaskType.dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        view.popup = popup
        popup.show(layout: FFPopupLayout.init(horizontal: FFPopup.HorizontalLayout.right, vertical: FFPopup.VerticalLayout.center))
    }

    override func awakeFromNib() {

        super.awakeFromNib()

        self.orderLabel.text = ZLLocalizedString(string: "Order", comment: "排序")
        self.languageLabel.text = ZLLocalizedString(string: "Language", comment: "语言")
        self.createTimeLabel.text = ZLLocalizedString(string: "CreateTime", comment: "创建于")
        self.followerLabel.text = ZLLocalizedString(string: "FollowersNum", comment: "粉丝")
        self.pubReposLabel.text = ZLLocalizedString(string: "PubReposNum", comment: "公共仓库")
        self.finishButton.setTitle(ZLLocalizedString(string: "FilterFinish", comment: ""), for: .normal)

        self.firstTimeFileld.delegate = self
        self.secondTimeField.delegate = self
        self.firstFollowerNumField.delegate = self
        self.secondFollowerNumField.delegate = self
        self.firstPubRepoNumField.delegate = self
        self.secondPubRepoNumField.delegate = self

        let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(resignAllResponder))
        self.addGestureRecognizer(gestureRecognizer)

        self.finishButton.titleLabel?.font = UIFont.init(name: Font_PingFangSCSemiBold, size: 14)
    }

    @IBAction func onOrderButtonClicked(_ sender: UIButton) {
        ZLSearchFilterPickerView.showUserOrderPickerView(initTitle: sender.titleLabel?.text, resultBlock: {(result: String) in
            sender.setTitle(result, for: .normal)
        })
    }

    @IBAction func onLanguageButtonClicked(_ sender: UIButton) {
//        ZLLanguageSelectView.showLanguageSelectView { (result: String?) in
//            sender.setTitle(result ?? "Any", for: .normal)
//        }
    }

    @objc func resignAllResponder() {
        self.endEditing(true)
    }

    func setViewDataForSearchFilterViewForUser(searchFilterModel: ZLSearchFilterInfoModel?) {
        guard let model = searchFilterModel else {
            return
        }

        if model.order != nil {
            if model.order == "followers" && model.isAsc == false {
                self.orderButton.setTitle("Most followers", for: .normal)
            } else if model.order == "followers" && model.isAsc == true {
                self.orderButton.setTitle("Fewest followers", for: .normal)
            } else if model.order == "joined" && model.isAsc == false {
                self.orderButton.setTitle("Most recently joined", for: .normal)
            } else if model.order == "joined" && model.isAsc == true {
                self.orderButton.setTitle("Least recently joined", for: .normal)
            } else if model.order == "repositories" && model.isAsc == false {
                self.orderButton.setTitle("Most repositories", for: .normal)
            } else if model.order == "repositories" && model.isAsc == true {
                self.orderButton.setTitle("Fewest repositories", for: .normal)
            }
        }
        if model.language != ""{
            self.languageButton.setTitle(searchFilterModel?.language, for: .normal)
        }

        self.firstTimeFileld.text = model.firstCreatedTimeStr
        self.secondTimeField.text = model.secondCreatedTimeStr
        self.firstFollowerNumField.text = model.firstFollowersNum == 0 ? nil : String(model.firstFollowersNum)
        self.secondFollowerNumField.text = model.secondFollowersNum == 0 ? nil : String(model.secondFollowersNum)
        self.firstPubRepoNumField.text = model.firstPubReposNum == 0 ? nil : String(model.firstPubReposNum)
        self.secondPubRepoNumField.text = model.secondPubReposNum == 0 ? nil :  String(model.secondPubReposNum)
    }

    @IBAction func onFinishButtonClicked(_ sender: Any) {

        let searchFilterModel = ZLSearchFilterInfoModel()
        let str = self.orderButton.title(for: .normal) ?? ""
        switch str {
        case "Most followers":do {
            searchFilterModel.isAsc = false
            searchFilterModel.order = "followers"
        }
        case "Fewest followers":do {
            searchFilterModel.isAsc = true
            searchFilterModel.order = "followers"
        }
        case "Most recently joined":do {
            searchFilterModel.isAsc = false
            searchFilterModel.order = "joined"
        }
        case "Least recently joined":do {
            searchFilterModel.isAsc = true
            searchFilterModel.order = "joined"
        }
        case "Most repositories":do {
            searchFilterModel.isAsc = false
            searchFilterModel.order = "repositories"
        }
        case "Fewest repositories":do {
            searchFilterModel.isAsc = true
            searchFilterModel.order = "repositories"
        }
        default:do {
            searchFilterModel.order = nil
        }
        }
        searchFilterModel.language = self.languageButton.title(for: .normal) ?? ""
        searchFilterModel.firstCreatedTimeStr = self.firstTimeFileld.text ?? ""
        searchFilterModel.secondCreatedTimeStr = self.secondTimeField.text ?? ""
        searchFilterModel.firstFollowersNum = UInt(self.firstFollowerNumField.text ?? "0") ?? 0
        searchFilterModel.secondFollowersNum = UInt(self.secondFollowerNumField.text ?? "0") ?? 0
        searchFilterModel.firstPubReposNum = UInt(self.firstPubRepoNumField.text ?? "0") ?? 0
        searchFilterModel.secondPubReposNum = UInt(self.secondPubRepoNumField.text ?? "0") ?? 0

        if self.resultBlock != nil {
            self.resultBlock?(searchFilterModel)
        }

        self.popup?.dismiss(animated: true)
    }

}

extension ZLSearchFilterViewForUser: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if textField == self.firstTimeFileld || textField == self.secondTimeField {
            self.endEditing(true)

            ZLSearchFilterPickerView.showDatePickerView(resultBlock: {(dateStr: String) in
                textField.text = dateStr
            })
            return false
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
