//
//  ZLFeedbackView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import UITextView_Placeholder

class ZLFeedbackView: ZLBaseView {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .clear
        addSubview(feedbackTextView)
        addSubview(submitButton)
        addSubview(contextLabel)
        
        feedbackTextView.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        contextLabel.snp.makeConstraints { make in
            make.top.equalTo(feedbackTextView.snp.bottom).offset(20)
            make.right.equalTo(-20)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(feedbackTextView.snp.bottom).offset(80)
            make.right.equalTo(-40)
            make.left.equalTo(40)
            make.height.equalTo(45)
        }
        
    }
    
    // MARK: Lazy View
    lazy var feedbackTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(named:"ZLCellBack")
        textView.textColor = UIColor(named:"ZLLabelColor1")
        textView.font = .zlRegularFont(withSize: 14)
        textView.placeholder = ZLLocalizedString(string: "thanks for your feedback", comment: "感谢您的反馈")
        return textView
    }()
    
    lazy var submitButton: UIButton = {
       let button = ZLBaseButton()
        button.setTitle(ZLLocalizedString(string: "submit", comment: "提交"), for: .normal)
        button.titleLabel?.font = .zlMediumFont(withSize: 16)
        return button
    }()
    
    lazy var contextLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named:"ZLLabelColor2")
        label.font = .zlRegularFont(withSize: 13)
        return label
    }()
}
