//
//  ZLMyPullRequestsView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/12/11.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

protocol ZLMyPullRequestsViewDelegate : NSObjectProtocol {
    func onFilterTypeChange(type : ZLGithubPullRequestState)
}


class ZLMyPullRequestsView: ZLBaseView {
    
    private var filterIndex : ZLGithubPullRequestState = .opened
    
    var githubItemListView : ZLGithubItemListView!
    var label : UILabel!
    
    weak var delegate : ZLMyPullRequestsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpUI()
    }
    
    
    func setUpUI(){
        self.backgroundColor = UIColor.clear
        
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLSubBarColor")
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        let label = UILabel()
        label.text = "open"
        label.textColor = UIColor(named: "ZLLabelColor3")
        label.font = UIFont(name: Font_PingFangSCRegular, size: 14)
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        self.label = label
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "filter"), for: .normal)
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.top.bottom.right.equalToSuperview()
        }
        button.addTarget(self, action: #selector(ZLMyIssuesView.onFilterButtonClicked), for: .touchUpInside)
        
        let itemListView = ZLGithubItemListView()
        itemListView.setTableViewFooter()
        itemListView.setTableViewHeader()
        self.addSubview(itemListView)
        itemListView.snp.makeConstraints { (make) in
            make.right.bottom.left.equalToSuperview()
            make.top.equalTo(view.snp_bottom)
        }
        self.githubItemListView = itemListView
    }
    
    
    @objc func onFilterButtonClicked(){
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: ZLLocalizedString(string: "Filter", comment: ""),
                                                            withInitIndex: UInt(self.filterIndex.rawValue),
                                                            withDataArray: ["open","closed","merged"])
        { (index : UInt) in
            self.label.text = ["open","closed","merged"][Int(index)]
            self.filterIndex = ZLGithubPullRequestState.init(rawValue: Int(index))!
            self.delegate?.onFilterTypeChange(type: self.filterIndex)
        }
    }
}
