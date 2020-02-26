//
//  ZLEventTableViewCell.swift
//  ZLGitHubClient
//
//  Created by BeeCloud on 2019/11/25.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLEventTableViewCellDelegate: NSObjectProtocol{
    func onAvatarClicked() -> Void;
    
    func onCellSingleTap() -> Void;
    
}

class ZLEventTableViewCell: UITableViewCell {
    
    weak var delegate : ZLEventTableViewCellDelegate?
    
    var containerView : UIView?
    
    var headImageButton: UIButton?
    
    var actorNameLabel: UILabel?
    
    var timeLabel : UILabel?
    
    var eventDesLabel : UILabel?
    
    var assistInfoView : UIView?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.setUpUI()
    }
    
    
    func setUpUI()
    {
        // containerView
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8.0
        self.contentView.addSubview(view)
        view.snp.makeConstraints({(make) -> Void in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10))
        })
        self.containerView = view
        let singleTagGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.onCellSingleTap(gestureRecognizer:)))
        self.containerView?.addGestureRecognizer(singleTagGesture)
        
        // headImageButton
        let headImageButton = UIButton.init(type: .custom)
        headImageButton.layer.cornerRadius = 20.0
        headImageButton.layer.masksToBounds = true
        self.containerView?.addSubview(headImageButton)
        headImageButton.snp.makeConstraints({(make) -> Void in
            make.left.equalTo(self.containerView!.snp_left).offset(10)
            make.top.equalTo(self.containerView!.snp_top).offset(10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        })
        self.headImageButton = headImageButton
        self.headImageButton?.addTarget(self, action: #selector(self.onAvatarButtonClicked(button:)), for: .touchUpInside)
        
        let actorNameLabel = UILabel.init()
        actorNameLabel.textColor = UIColor.black
        actorNameLabel.font = UIFont.init(name: Font_PingFangSCMedium, size: 16.0)
        self.containerView?.addSubview(actorNameLabel)
        actorNameLabel.snp.makeConstraints({(make) -> Void in
            make.left.equalTo(self.headImageButton!.snp_right).offset(10)
            make.centerY.equalTo(self.headImageButton!.snp_centerY)
        })
        self.actorNameLabel = actorNameLabel
        
        let timeLabel = UILabel.init()
        timeLabel.textColor = UIColor.init(hexString: "#878787", alpha: 1.0)
        timeLabel.font = UIFont.init(name: Font_PingFangSCMedium, size: 15.0)
        self.containerView?.addSubview(timeLabel)
        timeLabel.snp.makeConstraints({(make) -> Void in
            make.right.equalTo(self.containerView!.snp_right).offset(-10)
            make.centerY.equalTo(self.actorNameLabel!.snp_centerY)
        })
        self.timeLabel = timeLabel
        
        let eventDesLabel = UILabel.init()
        eventDesLabel.textColor = UIColor.init(hexString: "#333333", alpha: 1.0)
        eventDesLabel.font = UIFont.init(name: Font_PingFangSCRegular, size: 15.0)
        self.containerView?.addSubview(eventDesLabel)
        eventDesLabel.snp.makeConstraints({(make) -> Void in
            make.left.equalTo(self.containerView!.snp_left).offset(10)
            make.right.equalTo(self.containerView!.snp_right).offset(-10)
            make.top.equalTo(self.headImageButton!.snp.bottom).offset(10)
            make.height.equalTo(30)
        })
        self.eventDesLabel = eventDesLabel
        
        let assistInfoView = UIView.init()
        self.containerView?.addSubview(assistInfoView)
        assistInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.eventDesLabel!.snp_bottom).offset(10)
            make.left.equalTo(self.containerView!.snp_left).offset(10)
            make.right.equalTo(self.containerView!.snp_right).offset(-10)
            make.bottom.equalTo(self.containerView!.snp_bottom).offset(-10)
        }
        self.assistInfoView = assistInfoView
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillWithData(cellData : ZLEventTableViewCellData)
    {
        self.headImageButton?.sd_setBackgroundImage(with: URL.init(string: cellData.getActorAvaterURL()), for: .normal, placeholderImage: UIImage.init(named: "default_avatar"), options: .refreshCached, context: nil)
        self.actorNameLabel?.text = cellData.getActorName()
        self.timeLabel?.text = cellData.getTimeStr()
        self.eventDesLabel?.text = cellData.getEventDescrption()
    }
}


// MARK : action
extension ZLEventTableViewCell
{
    @objc func onAvatarButtonClicked(button: UIButton) -> Void
    {
        if self.delegate?.responds(to: #selector(ZLEventTableViewCellDelegate.onAvatarClicked)) ?? false
        {
            self.delegate?.onAvatarClicked()
        }
    }
    
    @objc func onCellSingleTap(gestureRecognizer : UITapGestureRecognizer)
    {
        if self.delegate?.responds(to: #selector(ZLEventTableViewCellDelegate.onCellSingleTap)) ?? false
        {
            self.delegate?.onCellSingleTap()
        }
    }
}
