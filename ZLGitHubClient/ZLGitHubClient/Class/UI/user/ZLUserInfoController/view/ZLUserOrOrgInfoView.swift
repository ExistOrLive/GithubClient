//
//  ZLUserOrOrgInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/4/10.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

protocol ZLUserOrOrgInfoViewDelegate: NSObjectProtocol {
    var isOrgView: Bool {get}
    var isUserView: Bool {get}
}

class ZLUserOrOrgInfoView: ZLBaseView {
    
    private var delegate: ZLUserOrOrgInfoViewDelegate?
    
    private var scrollView: UIScrollView!
    var userInfoView: ZLUserInfoView?
    var orgInfoView: ZLOrgInfoView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpUI()
    }
    
    private func setUpUI() {
        scrollView = UIScrollView.init()
        scrollView.backgroundColor = UIColor.clear
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func fillWithData(_ delegate: ZLUserOrOrgInfoViewDelegate){
        
        self.delegate = delegate
        
        self.reloadData()
    }
    
    func reloadData(){
        
        for view in scrollView.subviews{
            view.removeFromSuperview()
        }
        
        if self.delegate?.isOrgView ?? false {
            
            if orgInfoView == nil {
                guard let baseView : ZLOrgInfoView = Bundle.main.loadNibNamed("ZLOrgInfoView", owner: nil, options: nil)?.first as? ZLOrgInfoView else{
                    return
                }
                orgInfoView = baseView
            }
            scrollView.addSubview(orgInfoView!)
            orgInfoView!.snp.makeConstraints { (make) in
                make.edges.equalTo(scrollView)
                make.width.equalTo(scrollView.snp_width)
            }
            
        } else if self.delegate?.isUserView ?? false {
            
            if userInfoView == nil {
                guard let baseView : ZLUserInfoView = Bundle.main.loadNibNamed("ZLUserInfoView", owner: nil, options: nil)?.first as? ZLUserInfoView else{
                    return
                }
                userInfoView = baseView
            }
  
            scrollView.addSubview(userInfoView!)
            userInfoView!.snp.makeConstraints { (make) in
                make.edges.equalTo(scrollView)
                make.width.equalTo(scrollView.snp_width)
            }
        }
    }
}
