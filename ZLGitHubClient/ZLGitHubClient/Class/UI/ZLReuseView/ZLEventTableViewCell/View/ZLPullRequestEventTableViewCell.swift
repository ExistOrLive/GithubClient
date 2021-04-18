//
//  ZLPullRequestEventTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLPullRequestEventTableViewCell: ZLEventTableViewCell {
    
    
    let prBodyLabel : UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        self.prBodyLabel = UILabel.init()
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        self.prBodyLabel.numberOfLines = 8
        self.assistInfoView?.addSubview(self.prBodyLabel)
        self.prBodyLabel.snp.makeConstraints( { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 5, left: 10, bottom: 10, right: 10))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func fillWithData(cellData: ZLEventTableViewCellData) {
        
        super.fillWithData(cellData: cellData)
        
        guard let issueCellData : ZLPullRequestEventTableViewCellData = cellData as? ZLPullRequestEventTableViewCellData else{
            return
        }
        
        self.prBodyLabel.attributedText = issueCellData.getPRBody()
    }
    

}
