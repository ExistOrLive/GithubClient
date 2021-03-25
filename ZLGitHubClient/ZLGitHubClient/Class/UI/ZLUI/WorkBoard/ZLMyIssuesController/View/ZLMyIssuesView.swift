//
//  ZLMyIssuesView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/23.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

protocol ZLMyIssuesViewDelegate : NSObjectProtocol {
    func onFilterTypeChange(type:ZLMyIssueFilterType)
}

class ZLMyIssuesView: ZLBaseView {
    
    private var filterIndex : ZLMyIssueFilterType = .creator
    
    var githubItemListView : ZLGithubItemListView!
    var label : UILabel!
    
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
        
        let label = UILabel()
        label.text = "Created"
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
                                                            withInitIndex: self.filterIndex.rawValue,
                                                            withDataArray: ["Created","Assigned","Mentioned"])
        { (index : UInt) in
            self.label.text = ["Created","Assigned","Mentioned"][Int(index)]
            self.filterIndex = ZLMyIssueFilterType.init(rawValue: index)!
            self.delegate?.onFilterTypeChange(type: self.filterIndex)
        }
    }
}
