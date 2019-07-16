//
//  ZLLoginBaseView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZTE. All rights reserved.
//

import UIKit

 @objc protocol ZLLoginBaseViewDelegate:NSObjectProtocol{
     func onLoginButtonClicked();
}

class ZLLoginBaseView: ZLBaseView {

    weak var delegate: ZLLoginBaseViewDelegate?
    
    @IBOutlet weak var loginLogoView: ZLLoginLogoView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func awakeFromNib() {
        
        self.loginLogoView.isVertical = true
        self.logoTopConstraint.constant += self.logoTopConstraint.constant + ZLStatusBarHeight;
        self.loginButton.layer.cornerRadius = 5.0;
        self.activityIndicator.isHidden = true;
        
    }
    

    
    
    @IBAction func onLoginButtonClicked(_ sender: Any) {
        
        if self.delegate?.responds(to: #selector(self.delegate?.onLoginButtonClicked)) ?? false
        {
            self.delegate?.onLoginButtonClicked();
        }
        
    }
}
