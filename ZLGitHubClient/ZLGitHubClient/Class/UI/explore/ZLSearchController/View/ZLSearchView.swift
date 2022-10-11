//
//  ZLSearchView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/3.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLBaseExtension

enum ZLSearchViewEventType: Int {
    case filterButtonClicked
}

class ZLSearchView: ZLBaseView {
    
    @IBOutlet private weak var backButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var cancelButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    lazy var searchRecordView: ZLSearchRecordView = {
        let searchRecordView = ZLSearchRecordView()
        return searchRecordView
    }()
    lazy var searchItemsView: ZLSearchItemsView = {
        let searchItemsView = ZLSearchItemsView()
        return searchItemsView
    }()
    var searchFilterView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let placeHolder = ZLLocalizedString(string: "Search", comment: "")
        self.searchTextField.attributedPlaceholder = NSAttributedString.init(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: ZLRGBValue_H(colorValue: 0x999999), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
        leftView.backgroundColor = UIColor.clear
        self.searchTextField.leftView = leftView
        self.searchTextField.leftViewMode = .always
        
        self.cancelButton.setTitle(ZLLocalizedString(string: "Cancel", comment: ""), for: .normal)
        
        // ZLSearchItemsView
        self.searchItemsView.frame = self.contentView.bounds
        self.searchItemsView.autoresizingMask = UIView.AutoresizingMask.init(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
        self.contentView.addSubview(searchItemsView)
        
        
        // ZLSearchRecordView
        self.searchRecordView.frame = self.contentView.bounds
        self.searchRecordView.autoresizingMask = UIView.AutoresizingMask.init(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
        self.contentView.addSubview(searchRecordView)
        self.searchRecordView.isHidden = true
        
    }
    
    func setEditStatus() {
        self.backButtonWidthConstraint.constant = 0.0
        self.cancelButtonWidthConstraint.constant = 60.0
        self.searchRecordView.isHidden = false
    }
    
    func setUnEditStatus() {
        self.backButtonWidthConstraint.constant = 30.0
        self.cancelButtonWidthConstraint.constant = 0.0
        self.searchRecordView.isHidden = true
    }
    
    func showUserFilterView() {
        
    }
    
    func showRepoFilterView() {
        
    }
    
}
