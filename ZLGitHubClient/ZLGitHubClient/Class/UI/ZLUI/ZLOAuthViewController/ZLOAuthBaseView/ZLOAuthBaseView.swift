//
//  ZLOAuthBaseView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/7.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLOAuthBaseViewDelegate: NSObjectProtocol {
    
    func onBackButtonClicked(button: UIButton);
}

class ZLOAuthBaseView: ZLBaseView {
    
    weak var delegate: ZLOAuthBaseViewDelegate?
    @IBOutlet weak var webView: UIWebView!
    
    @IBAction func onBackButtonClicked(_ sender: Any) {
        
        if (self.delegate != nil) && self.delegate!.responds(to: #selector(self.delegate!.onBackButtonClicked(button:)))
        {
            self.delegate!.onBackButtonClicked(button: sender as! UIButton);
        }
    }
    
}
