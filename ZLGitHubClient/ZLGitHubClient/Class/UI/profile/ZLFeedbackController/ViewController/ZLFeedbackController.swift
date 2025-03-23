//
//  ZLFeedbackController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLBaseExtension
import ZLUIUtilities
import ZMMVVM
import ZLGitRemoteService
import UITextView_Placeholder


class ZLFeedbackController: ZMViewController {
    
    let context = "\(ZLDeviceInfo.getDeviceSystemVersion()) - \(ZLDeviceInfo.getDeviceModel()) - \(ZLDeviceInfo.getAppName())\(ZLDeviceInfo.getAppVersion())"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func setupUI() {
        super.setupUI()
        self.title = ZLLocalizedString(string: "feedback", comment: "反馈")
        contentView.addSubview(feedbackTextView)
        contentView.addSubview(submitButton)
        contentView.addSubview(contextLabel)
        
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
        
        contextLabel.text = context
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
       let button = ZMButton()
        button.setTitle(ZLLocalizedString(string: "submit", comment: "提交"), for: .normal)
        button.titleLabel?.font = .zlMediumFont(withSize: 16)
        button.addTarget(self, action: #selector(onSubmitButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var contextLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named:"ZLLabelColor2")
        label.font = .zlRegularFont(withSize: 13)
        return label
    }()
}

// MARK: - Action
extension ZLFeedbackController {
    @objc func onSubmitButtonClicked() {
       
        feedbackTextView.endEditing(true)
        
        guard let feedback = feedbackTextView.text,
              !feedback.isEmpty else {
            ZLToastView.showMessage(ZLLocalizedString(string: "input feedback", comment: ""))
            return
        }
        
        var feedbackTitle = feedback
        if feedbackTitle.count > 100 {
            let index = feedbackTitle.index(feedbackTitle.startIndex, offsetBy: 100)
            feedbackTitle = String(feedbackTitle[..<index])
        }
        let title = "Feedback: \(feedbackTitle)"
        let body = "\(feedback) \n >\(context)"
        let serialNumber = NSString.generateSerialNumber()
        
#if DEBUG
        let fullName = "MengAndJie/GithubClient"
#else
        let fullName = "ExistOrLive/GithubClient"
#endif
        
        contentView.showProgressHUD()
        ZLServiceManager.sharedInstance.eventServiceModel?.createIssue(withFullName: fullName,
                                                                       title: title,
                                                                       body: body,
                                                                       labels: nil,
                                                                       assignees: nil,
                                                                       serialNumber: serialNumber)
        { [weak self] (resultModel: ZLOperationResultModel) in
            
            
            guard let self = self else { return }
            self.contentView.dismissProgressHUD()
            
            if resultModel.result == true {
                ZLToastView .showMessage(ZLLocalizedString(string: "thanks for your feedback", comment: ""))
                self.navigationController?.popViewController(animated: true)
                
            } else {
                
                guard let errorModel: ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    ZLToastView.showMessage(ZLLocalizedString(string: "submission failed", comment: ""))
                    return
                }
                
                if errorModel.statusCode == 401 {
                    
                } else {
                    ZLToastView.showMessage("\(ZLLocalizedString(string: "submission failed", comment: "")) Code[\(errorModel.statusCode )] Message[\(errorModel.message)]")
                }
                
            }
        }
        
    }
}

