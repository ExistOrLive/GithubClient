//
//  ZLRepoFooterInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import MarkdownView

class ZLRepoFooterInfoView: ZLBaseView {

    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    var markdownView : MarkdownView!
    
    required init?(coder: NSCoder) {
        self.markdownView = MarkdownView()
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.refreshButton.layer.cornerRadius = 5.0
        self.refreshButton.layer.borderColor = UIColor.lightGray.cgColor
        self.refreshButton.layer.borderWidth = 1.0
        
     //   self.markdownView?.isScrollEnabled = false
        self.addSubview(self.markdownView)
        self.markdownView.snp.makeConstraints { (make) in
            make.top.equalTo(self.progressView.snp_bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
//        self.markdownView.onRendered = { [weak self] (height) in
//            self?.frame = CGRect.init(x: 0, y: 0, width: ZLScreenWidth, height: 300 + height)
//        }
        
    }
    
}
