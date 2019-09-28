//
//  ZLSearchFilterPickerView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/18.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

enum ZLSearchFilterPickerViewType {
    case language
    case userOrder
    case repoOrder
}

@objc protocol ZLSearchFilterPickerViewDelegate : NSObjectProtocol {
    
    func pickerViewDidFinishPicker(pickerView: ZLSearchFilterPickerView, result : String)
    
}



class ZLSearchFilterPickerView: ZLBaseView {
    
    var picekerViewType : ZLSearchFilterPickerViewType = .language
    {
        didSet{
            self.pickerView.reloadAllComponents()
        }
    }
    
    // delegate
    var delegate : ZLSearchFilterPickerViewDelegate?
    
    var rowIndex : Int = 0

    // View
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.heightConstraint.constant = self.heightConstraint.constant + AreaInsetHeightBottom
        
        self.cancelButton.setTitle(ZLLocalizedString(string: "Cancel", comment: "取消"), for: .normal)
        self.confirmButton.setTitle(ZLLocalizedString(string: "Confirm", comment: "确认"), for: .normal)
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
    }
    
    
    @IBAction func onCancelButtonClicked(_ sender: Any) {
        
        UIView.animate(withDuration: 1.0, animations: {
            self.removeFromSuperview()
        })
        
    }
    
    
    
    @IBAction func onConfirmButtonClicked(_ sender: Any) {
        
        if self.delegate?.responds(to: #selector(ZLSearchFilterPickerViewDelegate.pickerViewDidFinishPicker(pickerView:result:))) ?? false
        {
            var resultString = ""
            switch self.picekerViewType{
            case .language:
                resultString = ZLSearchFilterPickerView.languageArray[self.rowIndex]
            case .repoOrder:
                resultString =  ZLSearchFilterPickerView.repoOrderArray[self.rowIndex]
            case .userOrder:
                resultString = ZLSearchFilterPickerView.userOrderArray[self.rowIndex]
            }
            
            self.delegate?.pickerViewDidFinishPicker(pickerView: self, result: resultString)
        }
        
    }
    
}

extension ZLSearchFilterPickerView: UIPickerViewDelegate,UIPickerViewDataSource
{
    static let languageArray = ["Any Language","Action Sheet","C","C++","C#","Clojure","CoffeeScript","CSS","Dart","Go","Haskell","HTML","Java","JavaScript","Lua","MATLAB","Objective-C","Objective-C++","Perl","PHP","Python","R","Ruby","Scala","Shell","Swift","Tex","Vim script"]
    
    static let repoOrderArray = ["Best match","Most stars","Fewst stars","Most forks","Fewest forks","Recently updated","Least recently updated"]
    
    static let userOrderArray = ["Best match","Most followers","Fewest followers","Most recently joined","Least recently joined","Most repositories","Fewest repositories"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    // returns the # of rows in each component..
    @available(iOS 2.0, *)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch self.picekerViewType{
        case .language:
            return ZLSearchFilterPickerView.languageArray.count
        case .repoOrder:
            return ZLSearchFilterPickerView.repoOrderArray.count
        case .userOrder:
            return ZLSearchFilterPickerView.userOrderArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        switch self.picekerViewType{
        case .language:
            return ZLSearchFilterPickerView.languageArray[row]
        case .repoOrder:
            return ZLLocalizedString(string: ZLSearchFilterPickerView.repoOrderArray[row], comment: "")
        case .userOrder:
            return ZLLocalizedString(string: ZLSearchFilterPickerView.userOrderArray[row], comment: "")
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.rowIndex = row
    }
}


extension ZLSearchFilterPickerView
{
    static func showSearchFilterPickerView(type: ZLSearchFilterPickerViewType, delegate : ZLSearchFilterPickerViewDelegate?)
    {
        let window = UIApplication.shared.keyWindow
        
        guard  let pickerView : ZLSearchFilterPickerView = Bundle.main.loadNibNamed("ZLSearchFilterPickerView", owner: nil, options: nil)?.first as? ZLSearchFilterPickerView else
        {
            return
        }
        
        pickerView.picekerViewType = type
        pickerView.frame = window?.bounds ?? CGRect.init(x: 0, y: 0, width: 0, height: 0)
        
        UIView.animate(withDuration: 1.0, animations: {
            window?.addSubview(pickerView)
        })
    }
}
