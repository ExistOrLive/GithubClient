//
//  ZLFeedbackView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLFeedbackView: ZLBaseView {
    
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var contextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.feedbackTextView.placeholder = ZLLocalizedString(string: "thanks for your feedback", comment: "感谢您的反馈")
        self.submitButton.setTitle(ZLLocalizedString(string: "submit", comment: "提交"), for: .normal)
    }

}
