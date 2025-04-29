//
//  ZLSubmitCommentController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/2/27.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService


class ZLSubmitCommentController: ZMViewController {
    
    //
    var issueId: String?
    
    var submitSuccessBlock: (() -> Void)?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.addSubview(submitCommentView)
        submitCommentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        submitCommentView.zm_fillWithData(data: self)
    }
    
    // MARK: Lazy View
    lazy var submitCommentView: ZLSubmitCommentView = {
        ZLSubmitCommentView()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        submitCommentView.textView.becomeFirstResponder()
    }
}


extension ZLSubmitCommentController: ZLSubmitCommentViewDelegate {
    
    
    func onCancelButtonClicked() {
        onBackButtonClicked(UIButton())
    }
    
    func onSubmitButtonClicked(comment: String) {
        
        guard let issueId = self.issueId else { return }
        
        view.showProgressHUD()
        
        ZLServiceManager.sharedInstance.eventServiceModel?.addIssueComment(withIssueId: issueId,
                                                                           comment: comment,
                                                                           serialNumber: NSString.generateSerialNumber() ,
                                                                           completeHandle: { [weak self] model in
            guard let self = self else { return }
            self.view.dismissProgressHUD()
            
            if model.result {
                if let data = model.data as? AddIssueCommentMutation.Data,
                   let _ = data.addComment?.timelineEdge?.cursor,
                   let _ = data.addComment?.clientMutationId {
                    
                   self.submitCommentView.textView.text = nil
                    self.submitSuccessBlock?()
                   self.dismiss(animated: true, completion: nil)
                } else {
                    ZLToastView.showMessage("Nerwork Error")
                }
            } else {
                ZLToastView.showMessage("Nerwork Error")
            }
        
        })
    }
}

