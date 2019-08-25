//
//  ZLRepoFooterInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLRepoFooterInfoView: ZLBaseView {

    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.refreshButton.layer.cornerRadius = 5.0
        self.refreshButton.layer.borderColor = UIColor.lightGray.cgColor
        
        self.refreshButton.layer.borderWidth = 1.0
        
        self.webView.scrollView.isScrollEnabled = false
    }
    
}
