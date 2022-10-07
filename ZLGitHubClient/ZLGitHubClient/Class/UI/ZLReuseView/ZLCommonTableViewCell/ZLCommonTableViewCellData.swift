//
//  ZLCommonTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/7.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLCommonTableViewCellData: ZLGithubItemTableViewCellData {

    private var _canClick: Bool = false
    private var _title: String = ""
    private var _info: String = ""
    private var _cellHeight: CGFloat = 0.0
    private var _showSeparateLine: Bool = false
    private var _actionBlock: (() -> Void)?

    init(canClick: Bool,
         title: String,
         info: String,
         cellHeight: CGFloat,
         showSeparateLine: Bool = false,
         actionBlock:(() -> Void)? = nil) {
        _canClick = canClick
        _title = title
        _info = info
        _cellHeight = cellHeight
        _showSeparateLine = showSeparateLine
        _actionBlock = actionBlock
        super.init()
    }

    override func onCellSingleTap() {
       _actionBlock?()
    }

    override func getCellHeight() -> CGFloat {
        _cellHeight
    }

    override func getCellReuseIdentifier() -> String {
        "ZLCommonTableViewCell"
    }

}

extension ZLCommonTableViewCellData: ZLCommonTableViewCellDataSourceAndDelegate {

    var canClick: Bool {
        _canClick
    }

    var title: String {
        _title
    }

    var info: String {
        _info
    }
    
    var showSeparateLine: Bool {
        _showSeparateLine
    }

}
