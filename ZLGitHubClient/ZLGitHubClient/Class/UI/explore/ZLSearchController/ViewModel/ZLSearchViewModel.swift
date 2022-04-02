//
//  ZLSearchViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/3.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSearchViewModel: ZLBaseViewModel {

    // view
    var searchView: ZLSearchView?

    // viewModel
    var searchItemsViewModel: ZLSearchItemsViewModel?
    var searchRecordViewModel: ZLSearchRecordViewModel?

    var preSearchKeyWord: String?                // 保存之前搜索的关键字

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {

        guard let targetView = targetView as? ZLSearchView else {
            ZLLog_Warn("targetView is not ZLSearchView")
            return
        }

        self.searchView = targetView
        self.searchView?.searchTextField.delegate = self

        if let searchItemsView = self.searchView?.searchItemsView {
            let searchItemsViewModel = ZLSearchItemsViewModel.init()
            self.addSubViewModel(searchItemsViewModel)
            self.searchItemsViewModel = searchItemsViewModel
            searchItemsViewModel.bindModel(nil, andView: searchItemsView)
        }

        if let searchRecordView = self.searchView?.searchRecordView {
            let searchRecordViewModel = ZLSearchRecordViewModel.init()
            searchRecordViewModel.resultBlock = {[weak self](searchKey: String) in
                self?.searchView?.setUnEditStatus()
                self?.searchView?.searchTextField.text = searchKey
                self?.searchView?.searchTextField.resignFirstResponder()
                self?.searchItemsViewModel?.startSearch(keyWord: searchKey)
                self?.searchRecordViewModel?.onSearhKeyConfirmed(searchKey: searchKey)
            }
            self.addSubViewModel(searchRecordViewModel)
            self.searchRecordViewModel = searchRecordViewModel
            searchRecordViewModel.bindModel(nil, andView: searchRecordView)
        }

        if let searchKey = targetModel as? String {
            self.searchView?.searchTextField.text = searchKey
            self.searchItemsViewModel?.startSearch(keyWord: searchKey)
            self.searchRecordViewModel?.onSearhKeyConfirmed(searchKey: searchKey)
        }

    }

    override func getEvent(_ event: Any?, fromSubViewModel subViewModel: ZLBaseViewModel) {

        guard let eventType: ZLSearchViewEventType = event as? ZLSearchViewEventType else {
            ZLLog_Warn("event is not valid")
            return
        }

        switch eventType {
        case .filterButtonClicked:
            do {

            }
        }
    }

    @IBAction func onBackButtonClicked(_ sender: Any) {
        self.viewController?.navigationController?.popViewController(animated: true)
    }

    @IBAction func onCancelButtonClicked(_ sender: Any) {

        self.searchView?.searchTextField.text = self.preSearchKeyWord
        self.searchView?.searchTextField.resignFirstResponder()
        self.searchView?.setUnEditStatus()

    }

}

// MARK: UITextFieldDelegate
extension ZLSearchViewModel: UITextFieldDelegate {
    @available(iOS 2.0, *)
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.preSearchKeyWord  = self.searchView?.searchTextField.text
        self.searchView?.setEditStatus()
        self.searchItemsViewModel?.startInput()
        self.searchRecordViewModel?.onSearchKeyChanged(searchKey: textField.text)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textStr: NSString? = textField.text as NSString?
        let text: String = textStr?.replacingCharacters(in: range, with: string) ?? ""
        self.searchRecordViewModel?.onSearchKeyChanged(searchKey: text)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.searchRecordViewModel?.onSearchKeyChanged(searchKey: "")
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchView?.setUnEditStatus()
        textField.resignFirstResponder()
        self.searchItemsViewModel?.startSearch(keyWord: self.searchView?.searchTextField.text)
        self.searchRecordViewModel?.onSearhKeyConfirmed(searchKey: self.searchView?.searchTextField.text)
        return false
     }

}
