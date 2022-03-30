//
//  ZLCommonButtonCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/30.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit

protocol ZLCommonButtonCellDelegate {
    
    var relayoutBlock: ((UIButton) -> Void)? { get }
    
    var clickBlock: ((UIButton) -> Void)? { get }
     
}

class ZLCommonButtonCell: UITableViewCell {
    
    var clickBlock: ((UIButton) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func onButtonClicked(button: UIButton) {
        clickBlock?(button)
    }
    
    // MAKR: view
    private var button: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(onButtonClicked(button:)), for: .touchUpInside)
        return button
    }()
}


extension ZLCommonButtonCell: ViewUpdatable {
    func fillWithData(viewData: ZLCommonButtonCellDelegate) {
        viewData.relayoutBlock?(button)
        clickBlock = viewData.clickBlock
    }
}
