//
//  ZLRepoInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

protocol ZLRepoInfoViewDelegate: ZLRepoItemInfoViewDelegate,ZLReadMeViewDelegate{
    var fullName: String? {get}
    
}

class ZLRepoInfoView: ZLBaseView {
    
    weak var delegate: ZLRepoInfoViewDelegate?
    
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clear
        return scrollView
    }()
    
    lazy var headerView : ZLRepoHeaderInfoView = {
        guard let headerView = Bundle.main.loadNibNamed("ZLRepoHeaderInfoView", owner: nil, options: nil)?.first as? ZLRepoHeaderInfoView else
        {
            return ZLRepoHeaderInfoView()
        }
        return headerView
    }()
    
    lazy var itemView : ZLRepoItemInfoView = {
        guard let itemView : ZLRepoItemInfoView =  Bundle.main.loadNibNamed("ZLRepoItemInfoView", owner: nil, options: nil)?.first as? ZLRepoItemInfoView else
        {
            return ZLRepoItemInfoView()
        }
        return itemView
    }()
    
    lazy var readMeView : ZLReadMeView = {
        guard let readMeView : ZLReadMeView = Bundle.main.loadNibNamed("ZLReadMeView", owner: nil, options: nil)?.first as? ZLReadMeView else
        {
            return ZLReadMeView()
        }
        return readMeView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints( { (make) in
            make.edges.equalToSuperview()
        })
                
        self.scrollView.addSubview(headerView)
        headerView.snp.makeConstraints( { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.right.equalToSuperview()
            make.width.equalTo(self.snp_width)
        })
        
            
        self.scrollView.addSubview(itemView)
        itemView.snp.makeConstraints( { (make) in
            make.top.equalTo(self.headerView.snp_bottom).offset(10)
            make.left.equalToSuperview()
            make.width.equalTo(self.snp_width)
        });
        
        self.scrollView.addSubview(readMeView)
        readMeView.snp.makeConstraints { (make) in
            make.top.equalTo(self.itemView.snp_bottom).offset(10)
            make.left.bottom.equalToSuperview()
            make.width.equalTo(self.snp_width)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func justUpdate() {
        self.headerView.justUpdate()
        self.itemView.justUpdate()
        self.readMeView.justUpdate()
    }
    
    func fillWithData(delegate: ZLRepoInfoViewDelegate){
        self.delegate = delegate

        self.itemView.fillWithData(delegate: delegate)
        
        self.readMeView.delegate = delegate
        self.readMeView.startLoad(fullName: delegate.fullName ?? "", branch: delegate.branch)
    }
    
    func reloadData(){
        self.itemView.reloadData()
    }
    
}
