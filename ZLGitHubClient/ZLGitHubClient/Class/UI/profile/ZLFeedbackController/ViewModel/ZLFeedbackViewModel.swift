//
//  ZLFeedbackViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/14.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLGitRemoteService

class ZLFeedbackViewModel: ZLBaseViewModel {

    var targetView: ZLFeedbackView?

    var context: String?

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {

        guard let view = targetView as? ZLFeedbackView else {
            return
        }
        self.targetView = view

        self.context = "\(ZLDeviceInfo.getDeviceSystemVersion()) - \(ZLDeviceInfo.getDeviceModel()) - \(ZLDeviceInfo.getAppName())\(ZLDeviceInfo.getAppVersion())"
        self.targetView?.contextLabel.text = self.context
    }

    @IBAction func onSubmitButtonClicked(_ sender: Any) {

        self.targetView?.endEditing(true)
        
        guard let feedback = self.targetView?.feedbackTextView.text,
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
        let body = "\(feedback) \n >\(self.context ?? "")"
        let serialNumber = NSString.generateSerialNumber()
        
        #if DEBUG
        let fullName = "MengAndJie/GithubClient"
        #else
        let fullName = "ExistOrLive/GithubClient"
        #endif

        targetView?.showProgressHUD()
        ZLServiceManager.sharedInstance.eventServiceModel?.createIssue(withFullName: fullName,
                                                                       title: title,
                                                                       body: body,
                                                                       labels: nil,
                                                                       assignees: nil,
                                                                       serialNumber: serialNumber)
        { [weak self] (resultModel: ZLOperationResultModel) in
           
            
            guard let self = self else { return }
            self.targetView?.dismissProgressHUD()
            
            if resultModel.result == true {
                ZLToastView .showMessage(ZLLocalizedString(string: "thanks for your feedback", comment: ""))
                self.viewController?.navigationController?.popViewController(animated: true)

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
