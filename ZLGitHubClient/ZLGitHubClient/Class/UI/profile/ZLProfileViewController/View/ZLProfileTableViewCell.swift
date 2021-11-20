//
//  ZLProfileTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/16.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLProfileTableViewCell: UITableViewCell {

    lazy var itemTitleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label(withName: "ZLLabelColor1")
        label.font = .zlSemiBoldFont(withSize: 16)
        return label
    }()
    
    lazy var itemContentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label(withName: "ZLLabelColor2")
        label.font = .zlRegularFont(withSize: 13)
         return label
    }()
    
    lazy var nextLabel: UILabel = {
        let nextTag = UILabel()
        nextTag.font = UIFont.zlIconFont(withSize: 15)
        nextTag.textColor = UIColor(named: "ICON_Common")
        nextTag.text = ZLIconFont.NextArrow.rawValue
        return nextTag
    }()
    
    lazy var singleLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .back(withName: "ZLSeperatorLineColor")
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        self.contentView.backgroundColor = .back(withName: "ZLCellBack")
        
        self.contentView.addSubview(itemTitleLabel)
        self.contentView.addSubview(itemContentLabel)
        self.contentView.addSubview(nextLabel)
        self.contentView.addSubview(singleLineView)
        
        itemTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        nextLabel.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.size.equalTo(CGSize(width: 15, height: 20))
            make.centerY.equalToSuperview()
        }
        
        itemContentLabel.snp.makeConstraints { make in
            make.right.equalTo(-50)
            make.centerY.equalToSuperview()
        }
        
        singleLineView.snp.makeConstraints { make in
            make.left.equalTo(itemTitleLabel)
            make.bottom.right.equalToSuperview()
            make.height.equalTo(1.0 / UIScreen.main.scale)
        }
    }
    
}
