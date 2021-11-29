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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.backgroundColor = UIColor.clear
        return scrollView
    }()
    
    lazy var userInfoView: ZLUserInfoView = {
        guard let baseView = Bundle.main.loadNibNamed("ZLUserInfoView", owner: nil, options: nil)?.first as? ZLUserInfoView else{
            return ZLUserInfoView()
        }
        return baseView
    }()
    
    lazy var orgInfoView: ZLOrgInfoView = {
        guard let baseView = Bundle.main.loadNibNamed("ZLOrgInfoView", owner: nil, options: nil)?.first as? ZLOrgInfoView else{
            return ZLOrgInfoView()
        }
        return baseView
    }()
    
    lazy var placeHolderView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpUI()
    }
    
    private func setUpUI() {
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
            
            scrollView.addSubview(orgInfoView)
            orgInfoView.snp.makeConstraints { (make) in
                make.edges.equalTo(scrollView)
                make.width.equalTo(scrollView.snp.width)
            }
            
        } else if self.delegate?.isUserView ?? false {

            scrollView.addSubview(userInfoView)
            userInfoView.snp.makeConstraints { (make) in
                make.edges.equalTo(scrollView)
                make.width.equalTo(scrollView.snp.width)
            }
        } else {
            scrollView.addSubview(placeHolderView)
            placeHolderView.snp.makeConstraints { (make) in
                make.edges.equalTo(scrollView)
                make.width.equalTo(scrollView.snp.width)
                make.height.equalTo(scrollView.snp.height)
            }
        }
    }
}
