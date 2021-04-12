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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let contentView : ZLEditProfileContentView = Bundle.main.loadNibNamed("ZLEditProfileContentView", owner: nil, options: nil)?.first as? ZLEditProfileContentView else
        {
            ZLLog_Warn("ZLEditProfileContentView load failed")
            return
        }
        
        self.scrollView.addSubview(contentView)
        contentView.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.contentView = contentView
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    
}
