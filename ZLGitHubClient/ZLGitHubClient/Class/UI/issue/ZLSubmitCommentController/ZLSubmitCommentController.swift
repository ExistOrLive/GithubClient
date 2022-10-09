//
//  ZLSubmitCommentController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/2/27.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService
import RxRelay
import RxSwift

class ZLSubmitCommentController: ZLBaseViewController {
    
    //
    var issueId: String?
    
    // observale
    let _clearEvent: PublishRelay<Void> = PublishRelay<Void>()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.addSubview(submitCommentView)
        submitCommentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        submitCommentView.fillWithData(data: self)
    }
    
    override func watchKeyboardStatusNotification() -> Bool{
        return true 
    }
    
    override func keyboardWillShow(_ payload: ZLKeyboardNotificationPayload) {
        UIView.animate(withDuration: TimeInterval(payload.duration)) { [weak self] in
            self?.submitCommentView.snp_remakeConstraints({ make in
                make.top.left.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(-payload.endFrame.height)
            })
        }
    }
    
    override func keyboardWillHide(_ payload: ZLKeyboardNotificationPayload) {
        UIView.animate(withDuration: TimeInterval(payload.duration)) { [weak self] in
            self?.submitCommentView.snp_remakeConstraints({ make in
                make.top.left.right.bottom.equalToSuperview()
            })
        }
    }
    
    // MARK: Lazy View
    lazy var submitCommentView: ZLSubmitCommentView = {
        ZLSubmitCommentView()
    }()
}


extension ZLSubmitCommentController: ZLSubmitCommentViewDelegate {
    
    
    func onCancelButtonClicked() {
        onBackButtonClicked(nil)
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
                   let cursor = data.addComment?.timelineEdge?.cursor,
                   let mutationId = data.addComment?.clientMutationId {
                    
                   self._clearEvent.accept(())
                   self.dismiss(animated: true, completion: nil)
                } else {
                    ZLToastView.showMessage("Nerwork Error")
                }
            } else {
                ZLToastView.showMessage("Nerwork Error")
            }
        
        })
    }
    
    var clearObservable: Observable<Void> {
        _clearEvent.asObservable()
    }
}

