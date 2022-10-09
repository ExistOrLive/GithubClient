//
//  ZLCommonTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/5.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLUIUtilities
import ZLBaseExtension

protocol ZLCommonTableViewCellDataSourceAndDelegate {

    var canClick: Bool { get }

    var title: String { get }

    var info: String { get }
    
    var showSeparateLine: Bool { get }

}

class ZLCommonTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        contentView.backgroundColor = UIColor(named: "ZLCellBack")

        contentView.addSubview(titleLabel)
        contentView.addSubview(scrollView)
        scrollView.addSubview(subLabel)
        contentView.addSubview(nextLabel)
        contentView.addSubview(separateLine)

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.width.lessThanOrEqualTo(100)
            make.height.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.right.equalTo(-50)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(120)
            make.height.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.equalTo(scrollView)
            make.width.equalTo(scrollView).priority(.low)
        }

        nextLabel.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.height.equalToSuperview()
        }

        separateLine.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(1.0/UIScreen.main.scale)
        }
    }

    // MARK: View
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zlMediumFont(withSize: 16)
        label.textColor = UIColor(named: "ZLLabelColor1")
        return label
    }()
    
    lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = false
        return scrollView
    }()

    lazy var subLabel: UILabel = {
        let label = UILabel()
        label.font = .zlRegularFont(withSize: 12)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var nextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlIconFont(withSize: 15)
        label.textColor = UIColor(named: "ICON_Common")
        label.text = ZLIconFont.NextArrow.rawValue
        return label
    }()
    
    lazy var separateLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLSeperatorLineColor")
        view.isHidden = true
        return view
    }()
}


extension ZLCommonTableViewCell: ZLViewUpdatableWithViewData {
    // MARK: fillWithData
    func fillWithViewData(viewData: ZLCommonTableViewCellDataSourceAndDelegate) {
        selectionStyle = viewData.canClick ? .gray : .none
        titleLabel.text = viewData.title
        subLabel.text = viewData.info
        nextLabel.isHidden = !viewData.canClick
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        separateLine.isHidden = !viewData.showSeparateLine
    }
    
    func justUpdateView() {
        
    }
}
