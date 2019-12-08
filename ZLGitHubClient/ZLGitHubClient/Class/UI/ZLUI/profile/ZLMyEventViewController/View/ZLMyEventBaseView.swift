//
//  ZLMyEventBaseView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/8.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLMyEventBaseView: ZLBaseView {

    let eventListView : ZLEventListView
    
    override init(frame: CGRect) {
        self.eventListView = ZLEventListView(frame: ZLScreenBounds)
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        self.eventListView = ZLEventListView(frame: ZLScreenBounds)
        super.init(coder: coder)
        self.setUpView()
    }
    
    
    func setUpView()
    {
        self.addSubview(self.eventListView)
        self.eventListView.snp.makeConstraints( { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0))
        })
    }

}
