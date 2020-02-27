//
//  ZLRepoInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLRepoInfoView: ZLBaseView {
    
    var scrollView : UIScrollView?
    
    var headerView : ZLRepoHeaderInfoView?
    var itemView : ZLRepoItemInfoView?
    var footerView : ZLRepoFooterInfoView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.scrollView = UIScrollView.init()
        self.addSubview(self.scrollView!)
        self.scrollView?.backgroundColor = UIColor.clear
        self.scrollView!.snp.makeConstraints( { (make) in
            make.edges.equalToSuperview()
        })
        
        guard let headerView: ZLRepoHeaderInfoView = Bundle.main.loadNibNamed("ZLRepoHeaderInfoView", owner: nil, options: nil)?.first as? ZLRepoHeaderInfoView else
        {
            return
        }
        
        self.scrollView?.addSubview(headerView)
        headerView.snp.makeConstraints( { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.right.equalToSuperview()
            make.width.equalTo(self.snp_width)
        })
        self.headerView = headerView
        
        
        guard let itemView : ZLRepoItemInfoView =  Bundle.main.loadNibNamed("ZLRepoItemInfoView", owner: nil, options: nil)?.first as? ZLRepoItemInfoView else
        {
            return
        }
        
        self.scrollView?.addSubview(itemView)
        itemView.snp.makeConstraints( { (make) in
            make.top.equalTo(self.headerView!.snp_bottom).offset(10)
            make.left.equalToSuperview()
            make.width.equalTo(self.snp_width)
        });
        self.itemView = itemView
        
        guard let footView : ZLRepoFooterInfoView = Bundle.main.loadNibNamed("ZLRepoFooterInfoView", owner: nil, options: nil)?.first as? ZLRepoFooterInfoView else
        {
            return
        }
        
        self.scrollView?.addSubview(footView)
        footView.snp.makeConstraints { (make) in
            make.top.equalTo(self.itemView!.snp_bottom).offset(10)
            make.left.bottom.equalToSuperview()
            make.width.equalTo(self.snp_width)
            make.height.equalTo(ZLSCreenHeight)
            
        }
        self.footerView = footView
        
        
        self.footerView?.markdownView.value(forKey: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
