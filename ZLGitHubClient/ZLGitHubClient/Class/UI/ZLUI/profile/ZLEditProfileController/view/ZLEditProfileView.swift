//
//  ZLEditProfileView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/26.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit


class ZLEditProfileView: ZLBaseView {
    
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    
    var contentView: ZLEditProfileContentView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.topViewHeightConstraint.constant = self.topViewHeightConstraint.constant + ZLStatusBarHeight
        
        self.saveButton.layer.cornerRadius = 5.0
        
        guard let contentView : ZLEditProfileContentView = Bundle.main.loadNibNamed("ZLEditProfileContentView", owner: nil, options: nil)?.first as? ZLEditProfileContentView else
        {
            ZLLog_Warn("ZLEditProfileContentView load failed")
            return
        }
        contentView.frame = CGRect.init(x: 0, y: 10, width: self.scrollView.frame.size.width, height: ZLEditProfileContentView.minHeight)
        contentView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.scrollView.addSubview(contentView)
        self.scrollView.contentSize = CGSize.init(width: ZLScreenWidth, height:ZLEditProfileContentView.minHeight)
        self.contentView = contentView
        
    }
    
    
}
