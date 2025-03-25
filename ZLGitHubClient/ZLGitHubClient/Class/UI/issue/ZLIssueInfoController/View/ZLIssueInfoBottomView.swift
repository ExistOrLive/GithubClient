//
//  ZLIssueInfoBottomView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/3/25.
//  Copyright © 2025 ZM. All rights reserved.
//

import Foundation
import UIKit


// MARK: ZLIssueInfoBottomView
class ZLIssueInfoBottomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        backgroundColor = UIColor(named: "ZLTabBarBackColor")
        
        if getRealUserInterfaceStyle() == .light {
            layer.shadowColor = UIColor.black.cgColor
        } else {
            layer.shadowColor = UIColor.white.cgColor
        }
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: -1.5)
        
        addSubview(stackView)
        stackView.addArrangedSubview(commentButton)
        stackView.addArrangedSubview(infoButton)
        addSubview(seperateLine)
        
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalTo(super.safeAreaLayoutGuide.snp.bottom)
        }
        
        seperateLine.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 1.0 / UIScreen.main.scale , height: 30))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(7)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // 外观模式切换
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
                
                if getRealUserInterfaceStyle() == .light {
                    layer.shadowColor = UIColor.black.cgColor
                } else {
                    layer.shadowColor = UIColor.white.cgColor
                }
            }
        }
    }
    

    // MARK: Lazy View
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var commentButton: UIButton = {
       let button = UIButton()
        button.setTitle(ZLLocalizedString(string: "Comment", comment: ""), for: .normal)
        button.setTitleColor(UIColor(named: "ZLLabelColor1"), for: .normal)
        button.setTitleColor(UIColor(named: "ZLLabelColor2"), for: .disabled)
        button.titleLabel?.font = UIFont.zlMediumFont(withSize: 16)
        button.isEnabled = false
        return button
    }()
    
    lazy var infoButton: UIButton = {
       let button = UIButton()
        button.setTitle(ZLLocalizedString(string: "Infomation", comment: ""), for: .normal)
        button.setTitleColor(UIColor(named: "ZLLabelColor1"), for: .normal)
        button.setTitleColor(UIColor(named: "ZLLabelColor2"), for: .disabled)
        button.titleLabel?.font = UIFont.zlMediumFont(withSize: 16)
        return button
    }()
    
    lazy var seperateLine: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "ZLSeperatorLineColor")
        return view
    }()
}
