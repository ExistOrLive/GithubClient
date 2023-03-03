//
//  ZLLoginBaseView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI

@objc protocol ZLLoginBaseViewDelegate: NSObjectProtocol {
    func onLoginButtonClicked()
    func onAccessTokenButtonClicked()
}

class ZLLoginBaseView: ZLBaseView {

    weak var delegate: ZLLoginBaseViewDelegate?

    @IBOutlet weak var loginInfoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var accessTokenButton: UIButton!
    
    override func awakeFromNib() {
        self.loginButton.layer.cornerRadius = 5.0
        self.activityIndicator.isHidden = true
        self.loginButton.setTitle(ZLLocalizedString(string: "login", comment: "登录"), for: .normal)
    }

    @IBAction func onLoginButtonClicked(_ sender: Any) {
        if self.delegate?.responds(to: #selector(ZLLoginBaseViewDelegate.onLoginButtonClicked)) ?? false {
            self.delegate?.onLoginButtonClicked()
        }
    }

    @IBAction func onAccessTokenButtonClicked(_ sender: Any) {
        if self.delegate?.responds(to: #selector(ZLLoginBaseViewDelegate.onAccessTokenButtonClicked)) ?? false {
            self.delegate?.onAccessTokenButtonClicked()
        }
    }
//    
//    lazy var loginInfoLabel = {
//        let label = UILabel()
//        return label
//    }()
    
}
