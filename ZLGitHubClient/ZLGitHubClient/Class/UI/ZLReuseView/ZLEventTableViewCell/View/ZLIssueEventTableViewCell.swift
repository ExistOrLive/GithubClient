//
//  ZLIssueEventTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLIssueEventTableViewCell: ZLEventTableViewCell {

       let issueBodyLabel : UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        self.issueBodyLabel = UILabel.init()
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        self.issueBodyLabel.numberOfLines = 8
        self.assistInfoView?.addSubview(self.issueBodyLabel)
        self.issueBodyLabel.snp.makeConstraints( { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 5, left: 10, bottom: 10, right: 10))
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func fillWithData(cellData: ZLEventTableViewCellData) {
        
        super.fillWithData(cellData: cellData)
        
        guard let issueCellData : ZLIssueEventTableViewCellData = cellData as? ZLIssueEventTableViewCellData else{
            return
        }
        
        self.issueBodyLabel.attributedText = issueCellData.getIssueBody()
    }
    

}
