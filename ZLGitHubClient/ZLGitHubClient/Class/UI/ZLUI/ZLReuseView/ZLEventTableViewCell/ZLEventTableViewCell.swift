//
//  ZLEventTableViewCell.swift
//  ZLGitHubClient
//
//  Created by BeeCloud on 2019/11/25.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLEventTableViewCell: UITableViewCell {
    
    var containerView : UIView?
    
    var headImageButton: UIButton?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
     
    }
    
    
    func setUpUI()
    {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8.0
        self.contentView.addSubview(view)
        view.snp.makeConstraints({(make) -> Void in
            make.edges.equalTo(self.contentView).offset(10)
        })
        self.containerView = view
        
        let headImageButton = UIView.init()
        
        
           
    }
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
