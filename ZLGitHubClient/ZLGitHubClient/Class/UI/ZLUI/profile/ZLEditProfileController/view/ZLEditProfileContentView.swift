//
//  ZLEditProfileContentView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/26.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLEditProfileContentView: ZLBaseView,UITextFieldDelegate,UITextViewDelegate {

    static let minHeight: CGFloat = 550.0
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var addrLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    
    
    @IBOutlet weak var personalDescTextView: UITextView!
    
    @IBOutlet weak var companyTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var blogTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.blogTextField.delegate = self
        self.personalDescTextView.delegate = self
        self.companyTextField.delegate = self
        self.addressTextField.delegate = self
        
        self.descLabel.text = ZLLocalizedString(string: "bio", comment: "")
        self.companyLabel.text = ZLLocalizedString(string: "company", comment: "")
        self.blogLabel.text = ZLLocalizedString(string: "blog", comment: "")
        self.addrLabel.text = ZLLocalizedString(string: "location", comment: "")
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
