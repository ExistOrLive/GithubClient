//
//  ZLPushEventTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/1.
//  Copyright © 2019 ZM. All rights reserved.
//

import Foundation

class ZLPushEventTableViewCell: ZLEventTableViewCell {
    
    let commitInfoLabel : UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
         self.commitInfoLabel = UILabel.init()
         super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        self.commitInfoLabel.numberOfLines = 0
        self.assistInfoView?.addSubview(self.commitInfoLabel)
        self.commitInfoLabel.snp.makeConstraints( { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 5, left: 10, bottom: 10, right: 10))
        })
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func fillWithData(cellData: ZLEventTableViewCellData) {
        
        super.fillWithData(cellData: cellData)
        
        guard let pushEventCellData : ZLPushEventTableViewCellData = cellData as? ZLPushEventTableViewCellData else
        {
            return
        }
        
        self.commitInfoLabel.attributedText = pushEventCellData.commitInfoAttributedStr()
    }
}
