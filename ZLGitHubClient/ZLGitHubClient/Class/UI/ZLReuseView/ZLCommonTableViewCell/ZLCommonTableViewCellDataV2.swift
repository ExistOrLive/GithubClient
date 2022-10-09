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
    private var _titleBlock: () -> String = { "" }
    private var _infoBlock: () -> String = { "" }
    private var _cellHeight: CGFloat = 0.0
    private var _showSeparateLine: Bool = false
    private var _actionBlock: (() -> Void)?

    init(canClick: Bool,
         title: @escaping () -> String,
         info: @escaping () -> String,
         cellHeight: CGFloat,
         showSeparateLine:Bool = false,
         actionBlock:(() -> Void)? = nil) {
        _canClick = canClick
        _titleBlock = title
        _infoBlock = info
        _cellHeight = cellHeight
        _showSeparateLine = showSeparateLine
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
        _titleBlock()
    }

    var info: String {
        _infoBlock()
    }
    
    var showSeparateLine: Bool {
        _showSeparateLine
    }

}
