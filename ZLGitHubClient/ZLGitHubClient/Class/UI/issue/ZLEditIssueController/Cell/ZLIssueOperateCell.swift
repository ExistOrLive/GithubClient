//
//  ZLIssueOperateCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/9.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit

protocol ZLIssueOperateCellDataSource {
    var attributedTitle: NSAttributedString { get }
    
    var opeationType: ZLEditIssueOperationType { get }
}

class ZLIssueOperateCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private lazy var operateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var separateLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLSeperatorLineColor")
        return view
    }()
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(operateLabel)
      
        operateLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
    }

}

extension ZLIssueOperateCell: ViewUpdatable {
    
    func fillWithData(viewData: ZLIssueOperateCellDataSource) {
        operateLabel.attributedText = viewData.attributedTitle
    }
}
