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
    var searchItemsViewModel : ZLSearchItemsViewModel?
    var searchRecordViewModel : ZLSearchRecordViewModel?
    
    var preSearchKeyWord : String?                // 保存之前搜索的关键字
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if !(targetView is ZLSearchView)
        {
            ZLLog_Warn("targetView is not ZLSearchView")
            return
        }
        
        self.searchView = targetView as? ZLSearchView
        self.searchView?.searchTextField.delegate = self
        
        let searchItemsViewModel = ZLSearchItemsViewModel.init()
        searchItemsViewModel.bindModel(nil, andView: self.searchView!.searchItemsView!)
        self.addSubViewModel(searchItemsViewModel)
        self.searchItemsViewModel = searchItemsViewModel;
        
        let searchRecordViewModel = ZLSearchRecordViewModel.init()
        searchRecordViewModel.bindModel(nil, andView: self.searchView!.searchRecordView!)
        weak var weakSelf = self
        searchRecordViewModel.resultBlock = {(searchKey : String) in
            weakSelf?.searchView?.setUnEditStatus()
            weakSelf?.searchView?.searchTextField.text = searchKey
            weakSelf?.searchView?.searchTextField.resignFirstResponder()
            weakSelf?.searchItemsViewModel?.startSearch(keyWord: searchKey)
            weakSelf?.searchRecordViewModel?.onSearhKeyConfirmed(searchKey: searchKey)
        }
        self.addSubViewModel(searchRecordViewModel)
        self.searchRecordViewModel = searchRecordViewModel;
        
    }
    
    
    override func getEvent(_ event: Any?, fromSubViewModel subViewModel: ZLBaseViewModel) {
        
        guard let eventType : ZLSearchViewEventType = event as? ZLSearchViewEventType else
        {
            ZLLog_Warn("event is not valid")
            return
        }
        
        switch eventType
        {
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
extension ZLSearchViewModel: UITextFieldDelegate
{
    @available(iOS 2.0, *)
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.preSearchKeyWord  = self.searchView?.searchTextField.text
        self.searchView?.setEditStatus()
        self.searchItemsViewModel?.startInput()
        self.searchRecordViewModel?.onSearchKeyChanged(searchKey: textField.text)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textStr : NSString? = textField.text as NSString?
        let text : String = textStr?.replacingCharacters(in: range, with: string) ?? ""
        self.searchRecordViewModel?.onSearchKeyChanged(searchKey: text)
        return true
    }
    

    func textFieldDidEndEditing(_ textField: UITextField)
    {

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
