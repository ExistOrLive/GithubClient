//
//  ZLUserContributionsCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/9.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

protocol ZLUserContributionsCellDelegate: NSObjectProtocol {
    var loginName: String {get}
}

class ZLUserContributionsCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        contentView.backgroundColor = UIColor(named: "ZLCellBack")
        contentView.addSubview(contributionsView)
        contributionsView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.height.equalTo(100)
        }
    }

    // MARK: View
    private lazy var contributionsView: ZLUserContributionsView = {
        ZLUserContributionsView()
    }()
}


extension ZLUserContributionsCell: ZLViewUpdatableWithViewData {
    
    func fillWithViewData(viewData: ZLUserContributionsCellDelegate) {
        let loginName = viewData.loginName
        if !loginName.isEmpty {
            contributionsView.update(loginName: loginName)
        }
    }
}
