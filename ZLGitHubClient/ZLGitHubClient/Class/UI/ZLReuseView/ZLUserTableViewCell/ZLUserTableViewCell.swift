//
//  ZLUserTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/1.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLUserTableViewCellDelegate : NSObjectProtocol {
    
    func getName() -> String?
    
    func getLoginName() -> String?
    
    func getAvatarUrl() -> String?
    
    func getCompany() -> String?
    
    func getLocation() -> String?
    
    func desc() -> String?
}


class ZLUserTableViewCell: UITableViewCell {
    
    weak var delegate : ZLUserTableViewCellDelegate?
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLCellBack")
        view.cornerRadius = 8.0
        return view
    }()
    
    lazy var headImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.circle = true
        return imageView
    }()
    
    lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlMediumFont(withSize: 14)
        label.textColor = UIColor(named: "ZLLabelColor2")
  
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlSemiBoldFont(withSize: 17)
        label.textColor = UIColor(named: "ZLLabelColor1")
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlRegularFont(withSize: 12)
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.numberOfLines = 5
        return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(headImageView)
        containerView.addSubview(loginNameLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
        
        headImageView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(headImageView)
            make.left.equalTo(headImageView.snp.right).offset(15)
            make.right.equalTo(-15)
        }
        
        loginNameLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.right.equalTo(-15)
        }
        
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(headImageView.snp.bottom).offset(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBackSelected")
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }
    
    
    
}


extension ZLUserTableViewCell
{
    func fillWithData(data : ZLUserTableViewCellDelegate) -> Void
    {
        self.delegate = data
        
        self.headImageView.sd_setImage(with: URL.init(string: data.getAvatarUrl() ?? ""), placeholderImage: UIImage.init(named: "default_avatar"))
        self.loginNameLabel.text = data.getLoginName()
        self.nameLabel.text = "\(data.getName() ?? "")"
        self.descLabel.text = data.desc()
       
    }
}

