//
//  ZLRepoBranchTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/18.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoBranchTableViewCell: UITableViewCell {

    var branchNameLabel : UILabel?
    var currentBranchTag : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.branchNameLabel = UILabel.init()
        self.branchNameLabel?.font = UIFont.init(name: Font_PingFangSCMedium, size: 14)
        self.contentView.addSubview(self.branchNameLabel!)
        self.branchNameLabel!.snp.makeConstraints ({ (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        })
        
        self.currentBranchTag = UILabel.init()
        self.currentBranchTag?.textAlignment = .center
        self.currentBranchTag?.font = UIFont.init(name: Font_PingFangSCMedium, size: 12)
        self.currentBranchTag?.backgroundColor = ZLRGBValue_H(colorValue: 0x999999)
        self.currentBranchTag?.textColor = ZLRGBValue_H(colorValue: 0x666666)
        self.currentBranchTag?.text = ZLLocalizedString(string: "current", comment: "当前")
        self.contentView.addSubview(self.currentBranchTag!)
        self.currentBranchTag?.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(40)
          //  make.left.equalTo(self.branchNameLabel!.snp_right).offset(20)
        })
        self.currentBranchTag?.isHidden = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
