//
//  ZLRepoBranchTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/18.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoBranchTableViewCell: UITableViewCell {

    override var isSelected: Bool {
        didSet {
            self.selectedTag.isHidden = !self.isSelected
        }
    }

    lazy var branchNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(named: "ZLLabelColor4")
        label.font = UIFont.init(name: Font_PingFangSCRegular, size: 14)
        return label
    }()

    var selectedTag: UILabel = {
        let label = UILabel()
        label.text = ZLIconFont.LineSelected.rawValue
        label.font = .zlIconFont(withSize: 20)
        label.textColor = UIColor(named: "ICON_Common")
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.init(named: "ZLPopUpCellBack")

        self.contentView.addSubview(selectedTag)
        self.contentView.addSubview(branchNameLabel)

        self.selectedTag.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
            make.centerY.equalToSuperview()
        })

        self.contentView.addSubview(self.branchNameLabel)
        self.branchNameLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.selectedTag.snp_right).offset(20)
            make.right.equalTo(-5)
            make.centerY.equalToSuperview()
        })

        let view = UIView.init()
        view.backgroundColor = UIColor.init(named: "ZLSeperatorLineColor")
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.right.left.bottom.equalToSuperview()
            make.height.equalTo(0.3)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
