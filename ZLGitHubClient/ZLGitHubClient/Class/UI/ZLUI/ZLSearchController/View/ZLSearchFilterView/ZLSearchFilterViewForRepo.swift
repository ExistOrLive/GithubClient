//
//  ZLSearchFilterViewForRepo.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/18.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSearchFilterViewForRepo: ZLBaseView {
    
    static let minWidth : CGFloat = 300.0

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var orderLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var createTimeLabel: UILabel!
    @IBOutlet private weak var starLabel: UILabel!
    @IBOutlet private weak var forkLabel: UILabel!
    @IBOutlet private weak var sizeLabel: UILabel!
    
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var firstTimeFileld: UITextField!
    @IBOutlet weak var secondTimeField: UITextField!
    @IBOutlet weak var firstStarNumField: UITextField!
    @IBOutlet weak var secondStarNumField: UITextField!
    @IBOutlet weak var firstForkNumField: UITextField!
    @IBOutlet weak var secondForkNumField: UITextField!
    @IBOutlet weak var sizeFiled: UITextField!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.topConstraint.constant = self.topConstraint.constant + ZLStatusBarHeight
        self.bottomConstraint.constant = self.bottomConstraint.constant + AreaInsetHeightBottom
        
        self.orderLabel.text = ZLLocalizedString(string: "order", comment: "排序")
        self.languageLabel.text = ZLLocalizedString(string: "language", comment: "语言")
        self.createTimeLabel.text = ZLLocalizedString(string: "create at", comment: "创建于")
        self.starLabel.text = ZLLocalizedString(string: "star", comment: "标星")
        self.forkLabel.text = ZLLocalizedString(string: "fork", comment: "复制")
        self.sizeLabel.text = ZLLocalizedString(string: "size", comment: "")
        
        
        self.orderButton.layer.cornerRadius = 17.5
        self.languageButton.layer.cornerRadius = 17.5
        self.finishButton.layer.cornerRadius = 15
        
        self.firstTimeFileld.delegate = self;
        self.secondTimeField.delegate = self;
        self.firstForkNumField.delegate = self;
        self.secondForkNumField.delegate = self;
        self.firstStarNumField.delegate = self;
        self.secondStarNumField.delegate = self;
        self.sizeFiled.delegate = self;
        
        let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(resignAllResponder))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBAction func onOrderButtonClicked(_ sender: UIButton) {
        
        ZLSearchFilterPickerView.showRepoOrderPickerView(initTitle:sender.titleLabel?.text, resultBlock: {(result: String) in
            sender.setTitle(result, for: .normal)
        })
    }
    
    
    @IBAction func onLanguageButtonClicked(_ sender: UIButton) {
        
        ZLSearchFilterPickerView.showLanguagePickerView(initTitle:sender.titleLabel?.text, resultBlock:{ (result: String) in

            sender.setTitle(result, for: .normal)
        })
    }
    
    @objc func resignAllResponder()
    {
        self.firstTimeFileld.resignFirstResponder()
        self.secondTimeField.resignFirstResponder()
        self.firstForkNumField.resignFirstResponder()
        self.secondForkNumField.resignFirstResponder()
        self.firstStarNumField.resignFirstResponder()
        self.secondStarNumField.resignFirstResponder()
        self.sizeFiled.resignFirstResponder()
    }
    
}

//MARK:
extension ZLSearchFilterViewForRepo: UITextFieldDelegate
{
     func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
     {

        if textField == self.firstTimeFileld || textField == self.secondTimeField
        {
            self.firstForkNumField.resignFirstResponder()
            self.secondForkNumField.resignFirstResponder()
            self.firstStarNumField.resignFirstResponder()
            self.secondStarNumField.resignFirstResponder()
            self.sizeFiled.resignFirstResponder()
            
            ZLSearchFilterPickerView.showDatePickerView(resultBlock: {(dateStr:String) in
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
        return true;
    }
}
