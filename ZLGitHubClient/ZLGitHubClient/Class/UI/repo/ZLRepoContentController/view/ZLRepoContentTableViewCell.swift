//
//  ZLRepoContentTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/22.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoContentTableViewCell: UITableViewCell {
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlIconFont(withSize: 30)
        label.textColor = UIColor(named: "ICON_Common")
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlSemiBoldFont(withSize: 14)
        label.textAlignment = .left
        label.textColor = UIColor(named: "ZLLabelColor1")
        return label
    }()
    
    private lazy var nextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlIconFont(withSize: 15)
        label.textColor = UIColor(named: "ICON_Common")
        label.text = ZLIconFont.NextArrow.rawValue
        return label
    }()
    
    
    private lazy var seperateLine: UIView  = {
        let view = UIView()
        view.backgroundColor = .back(withName: "ZLSeperatorLineColor")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        
        self.contentView.backgroundColor = UIColor(named: "ZLCellBack")
        
        self.contentView.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(typeLabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(nextLabel)
        nextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 15, height: 15))
            make.left.equalTo(titleLabel.snp.right).offset(10)
        }
        
        self.contentView.addSubview(seperateLine)
        seperateLine.snp.makeConstraints { make in
            make.height.equalTo(ZLSeperateLineHeight)
            make.bottom.right.equalToSuperview()
            make.left.equalTo(titleLabel)
        }
    }
    
    func setCellData(cellData : ZLGithubContentModel?)
    {
        if cellData?.type == "dir"{
            self.typeLabel.text = ZLIconFont.DirClose.rawValue
        }
        else if cellData?.type == "file"{
            self.typeLabel.text = ZLIconFont.File.rawValue
        }
        self.titleLabel.text = cellData?.name
    }
    
    
}
