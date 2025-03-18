//
//  ZLLoginBaseView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI

protocol ZLLoginBaseViewDelegate: NSObjectProtocol {
    func onLoginButtonClicked()
    func onAccessTokenButtonClicked()
}

class ZLLoginBaseView: UIView {

    weak var delegate: ZLLoginBaseViewDelegate?
    
    @objc func onLoginButtonClicked(_ sender: Any) {
        self.delegate?.onLoginButtonClicked()
    }

    @objc func onAccessTokenButtonClicked(_ sender: Any) {
         self.delegate?.onAccessTokenButtonClicked()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor.clear
        addSubview(icon)
        addSubview(titleLabel)
        addSubview(activityIndicator)
        addSubview(loginInfoLabel)
        addSubview(loginButton)
        addSubview(accessTokenButton)
        
        icon.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(100)
            make.size.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(icon.snp.bottom).offset(40)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-100)
        }
        
        loginInfoLabel.snp.makeConstraints { make in
            make.left.equalTo(45)
            make.top.equalTo(loginButton.snp.bottom).offset(20)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.left.equalTo(loginInfoLabel.snp.right).offset(10)
        }
        
        accessTokenButton.snp.makeConstraints { make in
            make.right.equalTo(-40)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(33)
        }
    }
    
    
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon")
        imageView.cornerRadius = 5.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ZLGithub"
        label.textColor = UIColor(named:"ZLLabelColor1")
        label.font = UIFont.zlMediumFont(withSize: 30)
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .gray
        activityIndicator.color = UIColor(named:"ZLLabelColor2")
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    lazy var loginInfoLabel = {
        let label = UILabel()
        label.textColor = UIColor(named:"ZLLabelColor2")
        label.font = UIFont.zlRegularFont(withSize: 12)
        return label
    }()
    
    lazy var loginButton: UIButton = {
        let button = ZLBaseButton()
        button.titleLabel?.font = UIFont.zlMediumFont(withSize: 16)
        button.setTitle(ZLLocalizedString(string: "login", comment: "登录"), for: .normal)
        button.addTarget(self, action: #selector(onLoginButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var accessTokenButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named:"ZLLinkLabelColor1"), for: .normal)
        button.setTitle("Access Token", for: .normal)
        button.titleLabel?.font = UIFont.zlMediumFont(withSize: 15)
        button.addTarget(self, action: #selector(onAccessTokenButtonClicked), for: .touchUpInside)
        return button
    }()
    
}
