//
//  ZLEditProfileView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/26.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit


class ZLEditProfileView: ZLBaseView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var contentView: ZLEditProfileContentView?
    
    
    deinit {
        self.removeObservers()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        
        self.addObservers()
        
    }
    
    func addObservers()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeObservers()
    {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyBoardWillShow(notification: Notification)
    {
        guard let userInfo = notification.userInfo else {return}
        let value = userInfo["UIKeyboardFrameBeginUserInfoKey"] as! NSValue
        let keyboardRect = value.cgRectValue
        let keyboradHeight = keyboardRect.size.height
        
        
        self.scrollView.contentSize.height = (ZLEditProfileContentView.minHeight > ZLSCreenHeight ? ZLEditProfileContentView.minHeight : ZLSCreenHeight) + keyboradHeight
    }
    
    @objc func keyBoardWillHide(notification: Notification)
    {
        self.scrollView.contentSize.height = ZLEditProfileContentView.minHeight
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    
}
