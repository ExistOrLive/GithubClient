//
//  ZLSearchView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/3.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSearchView: ZLBaseView {

    @IBOutlet private weak var topViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var backButtonWidthConstraint: NSLayoutConstraint!

    @IBOutlet private weak var cancelButtonWidthConstraint: NSLayoutConstraint!
 
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var searchRecordView : ZLSearchRecordView?
    var searchItemsView: ZLSearchItemsView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.topViewHeightConstraint.constant = self.topViewHeightConstraint.constant + ZLStatusBarHeight
        
        // ZLSearchItemsView
        self.searchItemsView = Bundle.main.loadNibNamed("ZLSearchItemsView", owner: self, options: nil)?.first as? ZLSearchItemsView
        self.searchItemsView?.frame = self.contentView.bounds
        self.searchItemsView?.autoresizingMask = AutoresizingMask.init(rawValue: AutoresizingMask.flexibleHeight.rawValue | AutoresizingMask.flexibleWidth.rawValue)
        if self.searchItemsView != nil
        {
            self.contentView.addSubview(self.searchItemsView!)
        }
        
        // ZLSearchRecordView
        self.searchRecordView = Bundle.main.loadNibNamed("ZLSearchRecordView", owner: self, options: nil)?.first as? ZLSearchRecordView
        self.searchRecordView?.frame = self.contentView.bounds
        self.searchRecordView?.autoresizingMask = AutoresizingMask.init(rawValue: AutoresizingMask.flexibleHeight.rawValue | AutoresizingMask.flexibleWidth.rawValue)
        if self.searchRecordView != nil
        {
            self.contentView.addSubview(self.searchRecordView!)
        }
        self.searchRecordView?.isHidden = true
    }
    
    
    func setEditStatus()
    {
       self.backButtonWidthConstraint.constant = 0.0
        self.cancelButtonWidthConstraint.constant = 40.0
        self.searchRecordView?.isHidden = false
    }
    
    func setUnEditStatus()
    {
        self.backButtonWidthConstraint.constant = 30.0
        self.cancelButtonWidthConstraint.constant = 0.0
        self.searchRecordView?.isHidden = true
    }

}
