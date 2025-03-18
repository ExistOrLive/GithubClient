//
//  ZLWorkboardTableViewSectionHeader.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/20.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZMMVVM

class ZLWorkboardTableViewSectionHeader: UITableViewHeaderFooterView {

    var viewData: ZLWorkboardTableViewSectionHeaderData? {
        zm_viewModel as? ZLWorkboardTableViewSectionHeaderData
    }
    
    lazy var titleLabel: UILabel =  {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor1")
        label.font = UIFont.init(name: Font_PingFangSCSemiBold, size: 20)
        return label
    }()
    
    lazy var button: UIButton = {
        let button = ZMButton()
        button.titleLabel?.font = UIFont.init(name: Font_PingFangSCRegular, size: 13)
        button.setTitle(ZLLocalizedString(string: "Edit", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(onEditButtonClicked), for: .touchUpInside)
        return button
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        if #available(iOS 14.0, *) {
            self.backgroundConfiguration?.backgroundColor = UIColor.clear
        } else {
            self.backgroundColor = UIColor.clear
        }

        contentView.addSubview(self.titleLabel)
        contentView.addSubview(self.button)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
        self.button.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 60, height: 30))
            make.centerY.equalTo(self.titleLabel)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right).offset(-20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc dynamic func onEditButtonClicked() {
        viewData?.onEditAction()
    }
}


extension ZLWorkboardTableViewSectionHeader: ZMBaseViewUpdatableWithViewData {
    func zm_fillWithViewData(viewData: ZLWorkboardTableViewSectionHeaderData) {
        self.button.setTitle(viewData.editButtonTitle, for: .normal)
        self.button.isHidden = !viewData.showEditButton
        self.titleLabel.text = viewData.title
    }
}
