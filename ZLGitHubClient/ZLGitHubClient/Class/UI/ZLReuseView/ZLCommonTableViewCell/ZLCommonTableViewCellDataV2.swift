//
//  ZLCommonTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/7.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities

class ZLCommonTableViewCellDataV2: ZLTableViewBaseCellData {

    private var _canClick: Bool = false
    private var _title: String = ""
    private var _info: String = ""
    private var _cellHeight: CGFloat = 0.0
    private var _actionBlock: (() -> Void)?

    init(canClick: Bool,
         title: String,
         info: String,
         cellHeight: CGFloat,
         actionBlock:(() -> Void)? = nil) {
        _canClick = canClick
        _title = title
        _info = info
        _cellHeight = cellHeight
        _actionBlock = actionBlock
        super.init()
    }

    override func onCellSingleTap() {
       _actionBlock?()
    }

    override var cellReuseIdentifier: String {
        "ZLCommonTableViewCell"
    }
    
    override var cellHeight: CGFloat {
        _cellHeight
    }
}

extension ZLCommonTableViewCellDataV2: ZLCommonTableViewCellDataSourceAndDelegate {

    var canClick: Bool {
        _canClick
    }

    var title: String {
        _title
    }

    var info: String {
        _info
    }

}
