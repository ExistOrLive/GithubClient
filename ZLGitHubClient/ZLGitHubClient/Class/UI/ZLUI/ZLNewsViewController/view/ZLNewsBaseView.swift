//
//  ZLNewsBaseView.swift
//  ZLGitHubClient
//
//  Created by LongMac on 2019/8/30.
//  Copyright © 2019年 ZM. All rights reserved.
//

import UIKit

class ZLNewsBaseView: ZLBaseView {

    let eventListView : ZLEventListView
    
    required init?(coder: NSCoder) {
        
        self.eventListView = ZLEventListView(frame: ZLScreenBounds)
        super.init(coder: coder)
        
        self.setUpView()
    }
    
    override init(frame: CGRect) {
        self.eventListView = ZLEventListView(frame: ZLScreenBounds)
        super.init(frame: frame)
        
        self.setUpView()
    }
    
    
    func setUpView()
    {
        self.addSubview(self.eventListView)
        self.eventListView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0))
        })
    }

}
