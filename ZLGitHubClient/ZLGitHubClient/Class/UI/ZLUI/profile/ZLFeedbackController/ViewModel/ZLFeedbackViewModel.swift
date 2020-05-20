

//
//  ZLFeedbackViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/14.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLFeedbackViewModel: ZLBaseViewModel {
    
    var targetView : ZLFeedbackView?
    
    var context : String?
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let view : ZLFeedbackView = targetView as? ZLFeedbackView else {
            return
        }
        self.targetView = view
        
        self.context = "\(ZLDeviceInfo.getDeviceSystemVersion()) - \(ZLDeviceInfo.getDeviceModel()) - \(ZLDeviceInfo.getAppName())\(ZLDeviceInfo.getAppVersion())"
        self.targetView?.contextLabel.text = self.context
    }
    
    
    @IBAction func onSubmitButtonClicked(_ sender: Any) {
        
        self.targetView?.endEditing(true)
        
        if self.targetView?.feedbackTextView.text.count ?? 0 <= 0 {
            ZLToastView.showMessage(ZLLocalizedString(string: "input feedback", comment: ""))
            return
        }
        
        let feedback = self.targetView?.feedbackTextView.text
        let title = "Feedback: \(feedback!.prefix(10))"
        let body = "\(feedback!) \n >\(self.context ?? "")"
        let serialNumber = NSString.generateSerialNumber()
        
        weak var weakself = self
        
        ZLRepoServiceModel.shared().createIssue(withFullName: "MengAndJie/GithubClient", title: title, body: body, labels: nil, assignees: nil, serialNumber:serialNumber, completeHandle: { (resultModel : ZLOperationResultModel) in
            
            if resultModel.result == true {
                
                ZLToastView .showMessage(ZLLocalizedString(string: "thanks for your feedback", comment: ""))
                weakself?.viewController?.navigationController?.popViewController(animated: true)
              
            } else {
                
                guard let errorModel : ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    ZLToastView .showMessage(ZLLocalizedString(string: "submission failed", comment: ""))
                    return
                }
                
                if errorModel.statusCode == 401 {
                    
                } else {
                    ZLToastView .showMessage("\(ZLLocalizedString(string: "submission failed", comment: "")) Code[\(errorModel.statusCode )] Message[\(errorModel.message)]")
                }
                
            }
        })
        
        
    }
    
    
    
}
