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
        didSet{
            self.selectedTag?.isHidden = !self.isSelected
        }
    }

    var branchNameLabel : UILabel?
    var selectedTag : UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectedTag = UIImageView.init()
        self.selectedTag?.image = UIImage.init(named: "selected")
        self.contentView.addSubview(self.selectedTag!)
        self.selectedTag?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
            make.centerY.equalToSuperview()
        })
        
        self.branchNameLabel = UILabel.init()
        self.branchNameLabel?.textColor = ZLRGBValue_H(colorValue: 0x586069)
        self.branchNameLabel?.font = UIFont.init(name: Font_PingFangSCRegular, size: 14)
        self.contentView.addSubview(self.branchNameLabel!)
        self.branchNameLabel!.snp.makeConstraints ({ (make) in
            make.left.equalTo(self.selectedTag!.snp_right).offset(20)
            make.centerY.equalToSuperview()
        })
        
        let view = UIView.init()
        view.backgroundColor = ZLRGBValue_H(colorValue: 0xEAECEF)
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.right.left.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
