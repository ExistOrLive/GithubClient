//
//  ZLSubmitCommentController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/2/27.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLGitRemoteService

class ZLSubmitCommentController: ZLBaseViewController {
    
    //
    var issueId: String?
    
    // view
    private let submitCommentView = ZLSubmitCommentView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.addSubview(submitCommentView)
        submitCommentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        submitCommentView.fillWithData(viewData: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ZLSubmitCommentController: ZLSubmitCommentViewDelegate {
    
    
    func onCancelButtonClicked() {
        onBackButtonClicked(nil)
    }
    
    func onSubmitButtonClicked(comment: String) {
        
        guard let issueId = self.issueId else { return }
        
        submitCommentView.showProgressHUD()
        
        ZLServiceManager.sharedInstance.eventServiceModel?.addIssueComment(withIssueId: issueId,
                                                                           comment: comment,
                                                                           serialNumber: NSString.generateSerialNumber() ,
                                                                           completeHandle: { [weak self] model in
            guard let self = self else { return }
            UIView.dismissProgressHUD()
            
            if model.result {
                if let data = model.data as? AddIssueCommentMutation.Data,
                   let cursor = data.addComment?.timelineEdge?.cursor,
                   let mutationId = data.addComment?.clientMutationId {
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
