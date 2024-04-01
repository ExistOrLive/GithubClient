//
//  ZLSearchFilterSingleLineCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/11/5.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import UIKit
import ZLUIUtilities

protocol ZLSearchFilterSingleLineCellDelegate: AnyObject & ZMInputCollectionViewBaseCellDataType {
    
}

extension ZLSearchFilterSingleLineCellDelegate {
    var cellIdentifier: String {
        "ZLSearchFilterSingleLineCell"
    }
    var cellType: ZMInputCollectionViewBaseCellType {
        .base 
    }
}

class ZLSearchFilterSingleLineCellData: ZLSearchFilterSingleLineCellDelegate {
    var id = ""
    init(id: String = "") {
        self.id = id
    }
}

class ZLSearchFilterSingleLineCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    // MARK: Lazy View
    var line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLSeperatorLineColor2")
        return view
    }()
}
