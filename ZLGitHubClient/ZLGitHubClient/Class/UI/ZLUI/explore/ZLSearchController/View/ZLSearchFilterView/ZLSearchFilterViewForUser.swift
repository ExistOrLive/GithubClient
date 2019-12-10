//
//  ZLSearchFilterViewForUser.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/10/27.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit



class ZLSearchFilterViewForUser: UIView {
    
    static let minWidth : CGFloat = 300.0

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
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

    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.topConstraint.constant = self.topConstraint.constant + ZLStatusBarHeight
        self.bottomConstraint.constant = self.bottomConstraint.constant + AreaInsetHeightBottom
        
        self.orderLabel.text = ZLLocalizedString(string: "order", comment: "排序")
        self.languageLabel.text = ZLLocalizedString(string: "language", comment: "语言")
        self.createTimeLabel.text = ZLLocalizedString(string: "create at", comment: "创建于")
        self.followerLabel.text = ZLLocalizedString(string: "Followers", comment: "粉丝")
        self.pubReposLabel.text = ZLLocalizedString(string: "Pub Repos", comment: "公共仓库")
        
        
        self.orderButton.layer.cornerRadius = 17.5
        self.languageButton.layer.cornerRadius = 17.5
        self.finishButton.layer.cornerRadius = 20.0
        
        self.firstTimeFileld.delegate = self;
        self.secondTimeField.delegate = self;
        self.firstFollowerNumField.delegate = self;
        self.secondFollowerNumField.delegate = self;
        self.secondFollowerNumField.delegate = self;
        self.secondPubRepoNumField.delegate = self;
       
        let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(resignAllResponder))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBAction func onOrderButtonClicked(_ sender: UIButton) {
        ZLSearchFilterPickerView.showUserOrderPickerView(initTitle:sender.titleLabel?.text, resultBlock: {(result: String) in
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
        self.firstFollowerNumField.resignFirstResponder()
        self.secondFollowerNumField.resignFirstResponder()
        self.firstPubRepoNumField.resignFirstResponder()
        self.secondPubRepoNumField.resignFirstResponder()
    }

}


extension ZLSearchFilterViewForUser: UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
        {

           if textField == self.firstTimeFileld || textField == self.secondTimeField
           {
                self.firstTimeFileld.resignFirstResponder()
                self.secondTimeField.resignFirstResponder()
                self.firstFollowerNumField.resignFirstResponder()
                self.secondFollowerNumField.resignFirstResponder()
                self.firstPubRepoNumField.resignFirstResponder()
                self.secondPubRepoNumField.resignFirstResponder()
               
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
