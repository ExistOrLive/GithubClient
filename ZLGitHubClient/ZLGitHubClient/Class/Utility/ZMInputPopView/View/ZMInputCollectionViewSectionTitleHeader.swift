//
//  ZMInputCollectionViewSectionTitleHeader.swift
//  ZMInputCollectionViewSectionTitleHeader
//
//  Created by zhumeng on 2022/7/31.
//

import UIKit
import ZLBaseExtension
import SnapKit

/// 标题Section Header
///
public class ZMInputCollectionViewSectionTitleHeaderData: ZMInputCollectionViewSectionTitleHeaderDataType {
    
    public var title: String = ""
    public var sectionViewIdentifier: String = "ZMInputCollectionViewSectionTitleHeader"
    public var titleFont: UIFont = .zlMediumFont(withSize: 18)
    public var titleColor: UIColor = .black
    public var titleTopPadding: CGFloat = 0
    public var titleLeftPadding: CGFloat = 0
    public var id: String = ""

    public init() {}
    
    public init(title: String,
                sectionViewIdentifier: String = "ZMInputCollectionViewSectionTitleHeader",
                titleFont: UIFont = .zlMediumFont(withSize: 18),
                titleColor: UIColor = .black,
                titleTopPadding: CGFloat = 0,
                titleLeftPadding: CGFloat = 0,
                id: String = "") {
        self.title = title
        self.sectionViewIdentifier = sectionViewIdentifier
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.titleTopPadding = titleTopPadding
        self.titleLeftPadding = titleLeftPadding
        self.id = id
    }
}


public protocol ZMInputCollectionViewSectionTitleHeaderDataType: ZMInputCollectionViewBaseSectionViewDataType {
    var title: String { get }
    var titleFont: UIFont { get }
    var titleColor: UIColor { get }
    var titleTopPadding: CGFloat { get }
    var titleLeftPadding: CGFloat { get }
}

public class ZMInputCollectionViewSectionTitleHeader: UICollectionReusableView,ZMInputCollectionViewConcreteUpdatable {
   
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = .zlMediumFont(withSize: 18)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateConcreteViewData(viewData: ZMInputCollectionViewSectionTitleHeaderDataType) {
        titleLabel.text = viewData.title
        titleLabel.font = viewData.titleFont
        titleLabel.textColor = viewData.titleColor
        if viewData.titleTopPadding > 0 || viewData.titleLeftPadding > 0 {
            titleLabel.snp.remakeConstraints { make in
                make.left.equalTo(viewData.titleLeftPadding)
                if viewData.titleTopPadding > 0 {
                    make.top.equalTo(viewData.titleTopPadding)
                } else {
                    make.center.equalToSuperview()
                }
            }
        }
    }
}

