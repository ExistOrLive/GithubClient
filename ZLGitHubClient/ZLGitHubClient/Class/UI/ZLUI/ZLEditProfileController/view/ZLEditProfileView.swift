//
//  ZLEditProfileView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/26.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLEditProfileViewDelegate: NSObjectProtocol{
    
    func onBackButtonClicked(button: UIButton)
    
    func onSaveButtonClicked(button: UIButton)
}

class ZLEditProfileView: ZLBaseView {
    
    weak var delegate : ZLEditProfileViewDelegate?

    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var contentView: ZLEditProfileContentView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.topViewHeightConstraint.constant = self.topViewHeightConstraint.constant + ZLStatusBarHeight
        
        guard let contentView : ZLEditProfileContentView = Bundle.main.loadNibNamed("ZLEditProfileContentView", owner: nil, options: nil)?.first as? ZLEditProfileContentView else
        {
            ZLLog_Warn("ZLEditProfileContentView load failed")
            return
        }
        contentView.frame = CGRect.init(x: 0, y: 10, width: self.scrollView.frame.size.width, height: ZLEditProfileContentView.minHeight)
        contentView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.scrollView.addSubview(contentView)
        self.contentView = contentView
        
    }
    

    @IBAction func onBackButtonClicked(_ sender: Any) {
        
        if self.delegate?.responds(to: #selector(ZLEditProfileViewDelegate.onBackButtonClicked(button:))) ?? false
        {
            self.delegate?.onBackButtonClicked(button: sender as! UIButton)
        }
    }
    
}
