//
//  ZLMyIssuesView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/23.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

protocol ZLMyIssuesViewDelegate : NSObjectProtocol {
    func onFilterTypeChange(type:ZLIssueFilterType)
    func onStateChange(state:ZLGithubIssueState)
}

class ZLMyIssuesView: ZLBaseView {
    
    private var filterIndex : ZLIssueFilterType = .created
    private var stateIndex : ZLGithubIssueState = .open

    
    var githubItemListView : ZLGithubItemListView!
    
    var filterButton: UIButton!
    var stateButton: UIButton!
    
    
    weak var delegate : ZLMyIssuesViewDelegate?
    
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
            make.top.equalToSuperview()
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(30)
        }
            
        let button1 = UIButton(type: .custom)
        button1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button1.setAttributedTitle(NSAttributedString(string: "Created",
                                                      attributes: [.foregroundColor:UIColor.label(withName: "ZLLabelColor3"),
                                                                   .font:UIFont.zlRegularFont(withSize: 12)]),
                                   for: .normal)
        
        button1.setImage(UIImage(named: "down"), for: .normal)
        view.addSubview(button1)
        button1.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        button1.addTarget(self, action: #selector(ZLMyPullRequestsView.onFilterButtonClicked), for: .touchUpInside)
        filterButton = button1
    
        let button2 = UIButton(type: .custom)
        button2.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button2.setAttributedTitle(NSAttributedString(string: "Open",
                                                      attributes: [.foregroundColor:UIColor.label(withName: "ZLLabelColor3"),
                                                                   .font:UIFont.zlRegularFont(withSize: 12)]),
                                   for: .normal)
        button2.setImage(UIImage(named: "down"), for: .normal)
        view.addSubview(button2)
        button2.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(button1.snp_left).offset(-10)
        }
        button2.addTarget(self, action: #selector(ZLMyPullRequestsView.onStateButtonClicked), for: .touchUpInside)
        stateButton = button2
        
        
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
                                                            withDataArray: ["Created","Assigned","Mentioned"])
        { (index : UInt) in
            
            let str = ["Created","Assigned","Mentioned"][Int(index)]
            self.filterButton.setAttributedTitle(NSAttributedString(string: str,
                                                                    attributes: [.foregroundColor:UIColor.label(withName: "ZLLabelColor3"),
                                                                                 .font:UIFont.zlRegularFont(withSize: 12)]),
                                                 for: .normal)
            self.filterIndex = ZLIssueFilterType.init(rawValue: Int(index)) ?? .created
            self.delegate?.onFilterTypeChange(type: self.filterIndex)
        }
    }
    
    @objc func onStateButtonClicked(){
        
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: ZLLocalizedString(string: "Filter", comment: ""),
                                                            withInitIndex: UInt(self.stateIndex.rawValue),
                                                            withDataArray: ["Open","Closed"])
        { (index : UInt) in
            let str = ["Open","Closed"][Int(index)]
            self.stateButton.setAttributedTitle(NSAttributedString(string: str,
                                                                   attributes:[.foregroundColor:UIColor.label(withName: "ZLLabelColor3"),
                                                                               .font:UIFont.zlRegularFont(withSize: 12)]),
                                                for: .normal)
            self.stateIndex = ZLGithubIssueState.init(rawValue: index) ?? .open
            self.delegate?.onStateChange(state:self.stateIndex)
        }
        
    }
}
